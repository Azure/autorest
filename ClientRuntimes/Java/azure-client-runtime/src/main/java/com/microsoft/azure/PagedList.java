/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.NoSuchElementException;

import javax.xml.bind.DataBindingException;
import javax.xml.ws.WebServiceException;

/**
 * Defines a page interface in Azure responses.
 *
 * @param <E> the element type.
 */
public abstract class PagedList<E> implements List<E> {
    private List<E> items;
    private int pageCount;
    private String nextPageLink;

    public PagedList(Page<E> page) {
        items = page.getItems();
        nextPageLink = page.getNextPageLink();
        pageCount = 1;
    }

    public abstract Page<E> loadPage(String nextPageLink) throws CloudException, IOException;

    public void loadAll() {
        while (nextPageLink != null) {
            try {
                Page<E> nextPage = loadPage(nextPageLink);
                nextPageLink = nextPage.getNextPageLink();
                addAll(nextPage.getItems());
            } catch (CloudException e) {
                throw new WebServiceException(e.toString(), e);
            } catch (IOException e) {
                throw new DataBindingException(e.getMessage(), e);
            }
        }
    }

    private class Itr implements Iterator<E> {
        Iterator<E> itemsItr;

        public Itr() {
            itemsItr = items.iterator();
        }

        @Override
        public boolean hasNext() {
            return itemsItr.hasNext() || nextPageLink != null;
        }

        @Override
        public E next() {
            if (!itemsItr.hasNext()) {
                if (nextPageLink == null) {
                    throw new NoSuchElementException();
                } else {
                    try {
                        loadPage(nextPageLink);
                        itemsItr = items.iterator();
                    } catch (CloudException e) {
                        throw new WebServiceException(e.toString(), e);
                    } catch (IOException e) {
                        throw new DataBindingException(e.getMessage(), e);
                    }
                }
            }
            return itemsItr.next();
        }

        @Override
        public void remove() {
            itemsItr.remove();
        }
    }

    private class ListItr extends Itr implements ListIterator<E> {
        ListIterator<E> itemsListItr;

        public ListItr(int index) {
            itemsListItr = items.listIterator(index);
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
        return items.isEmpty() && nextPageLink == null;
    }

    @Override
    public boolean contains(Object o) {
        loadAll();
        return items.contains(o);
    }

    @Override
    public Iterator<E> iterator() {
        return new Itr();
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
        return items.containsAll(c);
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
        return items.indexOf(o);
    }

    @Override
    public int lastIndexOf(Object o) {
        return items.lastIndexOf(o);
    }

    @Override
    public ListIterator<E> listIterator() {
        return new ListItr(0);
    }

    @Override
    public ListIterator<E> listIterator(int index) {
        return new ListItr(index);
    }

    @Override
    public List<E> subList(int fromIndex, int toIndex) {
        return items.subList(fromIndex, toIndex);
    }
}
