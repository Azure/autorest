/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.RestException;

import javax.xml.bind.DataBindingException;
import javax.xml.ws.WebServiceException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.NoSuchElementException;

/**
 * Defines a list response from a paging operation. The pages are
 * lazy initialized when an instance of this class is iterated.
 *
 * @param <E> the element type.
 */
public abstract class PagedList<E> implements List<E> {
    /** The actual items in the list. */
    private List<E> items;
    /** Stores the link to get the next page of items. */
    private String nextPageLink;
    /** Stores the latest page fetched. */
    private Page<E> currentPage;

    /**
     * Creates an instance of Pagedlist.
     */
    public PagedList() {
        items = new ArrayList<>();
    }

    /**
     * Creates an instance of PagedList from a {@link Page} response.
     *
     * @param page the {@link Page} object.
     */
    public PagedList(Page<E> page) {
        this();
        items.addAll(page.getItems());
        nextPageLink = page.getNextPageLink();
        currentPage = page;
    }

    /**
     * Override this method to load the next page of items from a next page link.
     *
     * @param nextPageLink the link to get the next page of items.
     * @return the {@link Page} object storing a page of items and a link to the next page.
     * @throws RestException thrown if an error is raised from Azure.
     * @throws IOException thrown if there's any failure in deserialization.
     */
    public abstract Page<E> nextPage(String nextPageLink) throws RestException, IOException;

    /**
     * If there are more pages available.
     *
     * @return true if there are more pages to load. False otherwise.
     */
    public boolean hasNextPage() {
        return this.nextPageLink != null;
    }

    /**
     * Loads a page from next page link.
     * The exceptions are wrapped into Java Runtime exceptions.
     */
    public void loadNextPage() {
        try {
            Page<E> nextPage = nextPage(this.nextPageLink);
            this.nextPageLink = nextPage.getNextPageLink();
            this.items.addAll(nextPage.getItems());
            this.currentPage = nextPage;
        } catch (RestException e) {
            throw new WebServiceException(e.toString(), e);
        } catch (IOException e) {
            throw new DataBindingException(e.getMessage(), e);
        }
    }

    /**
     * Keep loading the next page from the next page link until all items are loaded.
     */
    public void loadAll() {
        while (hasNextPage()) {
            loadNextPage();
        }
    }

    /**
     * Gets the latest page fetched.
     *
     * @return the latest page.
     */
    public Page<E> currentPage() {
        return currentPage;
    }

    /**
     * Gets the next page's link.
     *
     * @return the next page link.
     */
    public String nextPageLink() {
        return nextPageLink;
    }

    /**
     * The implementation of {@link ListIterator} for PagedList.
     */
    private class ListItr implements ListIterator<E> {
        /** The list iterator for the actual list of items. */
        private ListIterator<E> itemsListItr;

        /**
         * Creates an instance of the ListIterator.
         *
         * @param index the position in the list to start.
         */
        ListItr(int index) {
            itemsListItr = items.listIterator(index);
        }

        @Override
        public boolean hasNext() {
            return itemsListItr.hasNext() || hasNextPage();
        }

        @Override
        public E next() {
            if (!itemsListItr.hasNext()) {
                if (!hasNextPage()) {
                    throw new NoSuchElementException();
                } else {
                    int size = items.size();
                    loadNextPage();
                    itemsListItr = items.listIterator(size);
                }
            }
            return itemsListItr.next();
        }

        @Override
        public void remove() {
            itemsListItr.remove();
        }

        @Override
        public boolean hasPrevious() {
            return itemsListItr.hasPrevious();
        }

        @Override
        public E previous() {
            return itemsListItr.previous();
        }

        @Override
        public int nextIndex() {
            return itemsListItr.nextIndex();
        }

        @Override
        public int previousIndex() {
            return itemsListItr.previousIndex();
        }

        @Override
        public void set(E e) {
            itemsListItr.set(e);
        }

        @Override
        public void add(E e) {
            itemsListItr.add(e);
        }
    }

    @Override
    public int size() {
        loadAll();
        return items.size();
    }

    @Override
    public boolean isEmpty() {
        return items.isEmpty() && !hasNextPage();
    }

    @Override
    public boolean contains(Object o) {
        return indexOf(o) >= 0;
    }

    @Override
    public Iterator<E> iterator() {
        return new ListItr(0);
    }

    @Override
    public Object[] toArray() {
        loadAll();
        return items.toArray();
    }

    @Override
    public <T> T[] toArray(T[] a) {
        loadAll();
        return items.toArray(a);
    }

    @Override
    public boolean add(E e) {
        return items.add(e);
    }

    @Override
    public boolean remove(Object o) {
        return items.remove(o);
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        for (Object e : c) {
            if (!contains(e)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean addAll(Collection<? extends E> c) {
        return items.addAll(c);
    }

    @Override
    public boolean addAll(int index, Collection<? extends E> c) {
        return items.addAll(index, c);
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        return items.removeAll(c);
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        return items.retainAll(c);
    }

    @Override
    public void clear() {
        items.clear();
    }

    @Override
    public E get(int index) {
        while (index >= items.size() && hasNextPage()) {
            loadNextPage();
        }
        return items.get(index);
    }

    @Override
    public E set(int index, E element) {
        return items.set(index, element);
    }

    @Override
    public void add(int index, E element) {
        items.add(index, element);
    }

    @Override
    public E remove(int index) {
        return items.remove(index);
    }

    @Override
    public int indexOf(Object o) {
        int index = 0;
        if (o == null) {
            for (E item : this) {
                if (item == null) {
                    return index;
                }
                ++index;
            }
        } else {
            for (E item : this) {
                if (item == o) {
                    return index;
                }
                ++index;
            }
        }
        return -1;
    }

    @Override
    public int lastIndexOf(Object o) {
        loadAll();
        return items.lastIndexOf(o);
    }

    @Override
    public ListIterator<E> listIterator() {
        return new ListItr(0);
    }

    @Override
    public ListIterator<E> listIterator(int index) {
        while (index >= items.size() && hasNextPage()) {
            loadNextPage();
        }
        return new ListItr(index);
    }

    @Override
    public List<E> subList(int fromIndex, int toIndex) {
        while ((fromIndex >= items.size()
                || toIndex >= items.size())
                && hasNextPage()) {
            loadNextPage();
        }
        return items.subList(fromIndex, toIndex);
    }
}
