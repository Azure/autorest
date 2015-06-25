/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

/**
 * Represents an object list that supports on-demand initialization.
 * @param <E> type of the elements
 */
public class LazyArrayList<E> extends ArrayList<E> implements LazyCollection {
    private static final long serialVersionUID = 1L;
    
    private boolean initialized;

    /**
     * Get a value indicating whether the list is initialized.
     *
     * @return <code>true</code> if list has been initialized
     *
     * @see LazyCollection#isInitialized()
     */
    @Override
    public boolean isInitialized() {
        return initialized;
    }

    /**
     * Inserts an element into the list at the specified index.
     *
     * @param index   the zero-based index at which item should be inserted
     * @param element element to insert
     *
     * @see ArrayList#add(int, Object)
     */
    @Override
    public void add(int index, E element) {
        initialized = true;
        super.add(index, element);
    }

    /**
     * Adds all the objects in a collection to a specified position in the list.
     *
     * @param index the zero-based index at which the items should be inserted
     * @param c     the collection to be added to the list
     *
     * @see ArrayList#addAll(int, Collection)
     */
    @Override
    public boolean addAll(int index, Collection<? extends E> c) {
        initialized = true;
        return super.addAll(index, c);
    }

    /**
     * Gets the element at the specified index.
     *
     * @param index the zero-based index of the element
     * @return      the element
     *
     * @see ArrayList#get(int)
     */
    @Override
    public E get(int index) {
        initialized = true;
        return super.get(index);
    }

    /**
     * Searches for the specified item and returns the zero-based index of the
     * first occurrence within the entire list.
     *
     * @param o the item to locate in the list
     * @return  the first occurrence index or -1 if not found
     */
    @Override
    public int indexOf(Object o) {
        initialized = true;
        return super.indexOf(o);
    }

    /**
     * Searches for the specified item and returns the zero-based index of the
     * last occurrence within the entire list.
     *
     * @param o the item to locate in the list
     * @return  the last occurrence index or -1 if not found
     */
    @Override
    public int lastIndexOf(Object o) {
        initialized = true;
        return super.lastIndexOf(o);
    }

    /**
     * Returns a list iterator over the elements in this list.
     *
     * @return a list iterator
     */
    @Override
    public ListIterator<E> listIterator() {
        initialized = true;
        return super.listIterator();
    }

    /**
     * Returns a list iterator over the elements in this list, starting at
     * the specified index in the list.
     *
     * @return a list iterator starting at the specified index
     */
    @Override
    public ListIterator<E> listIterator(int index) {
        initialized = true;
        return super.listIterator(index);
    }

    /**
     * Removes the element at the specified index of the list.
     *
     * @param index the zero-based index of the element to remove
     * @return      the element removed
     */
    @Override
    public E remove(int index) {
        initialized = true;
        return super.remove(index);
    }

    /**
     * Sets the element at the specified index with the specified element
     *
     * @param index   the zero-based index to set
     * @param element the specified element
     * @return        the original element at the specified index
     */
    @Override
    public E set(int index, E element) {
        initialized = true;
        return super.set(index, element);
    }

    /**
     * Gets a portion of the list starting and ending at specified indices.
     *
     * @param fromIndex the index from which the portion starts, inclusive
     * @param toIndex   the index to which the portion ends, exclusive
     *
     * @return          the portion of the list
     */
    @Override
    public List<E> subList(int fromIndex, int toIndex) {
        initialized = true;
        return super.subList(fromIndex, toIndex);
    }

    /**
     * Adds an object to the end of the list
     *
     * @param e the object to be added to the end of the list. The value
     *          can be null for reference types
     * @return  <code>true</code> (as specified by {@link Collection#add})
     *
     * @see     ArrayList#add(Object)
     */
    @Override
    public boolean add(E e) {
        initialized = true;
        return super.add(e);
    }

    /**
     * Adds all the objects in a collection to the list.
     *
     * @param c the collection to be added to the list
     *
     * @see ArrayList#addAll(Collection)
     */
    @Override
    public boolean addAll(Collection<? extends E> c) {
        initialized = true;
        return super.addAll(c);
    }

    /**
     * Removes all elements from the list.
     *
     * @see ArrayList#clear()
     */
    @Override
    public void clear() {
        initialized = true;
        super.clear();
    }

    /**
     * Determines whether an element is in the list.
     *
     * @param o the object to locate in the list. The value can be null
     *          for reference types
     * @return  <code>true</code> if this list contains the specified element
     */
    @Override
    public boolean contains(Object o) {
        initialized = true;
        return super.contains(o);
    }

    /**
     * Determines whether a collection of elements are all in the list.
     *
     * @param c the collection of all the objects to locate in the list.
     * @return  <code>true</code> if this list contains all the elements in
     *          the specified collection
     */
    @Override
    public boolean containsAll(Collection<?> c) {
        initialized = true;
        return super.containsAll(c);
    }

    /**
     * If the list is empty.
     *
     * @return <code>true</code> if this list is empty
     */
    @Override
    public boolean isEmpty() {
        initialized = true;
        return super.isEmpty();
    }

    /**
     * Removes the first occurrence of the specified element
     *
     * @param o the element to remove in the list
     * @return  <code>true</code> if this list contained the specified element
     *
     * @see ArrayList#remove(Object)
     */
    @Override
    public boolean remove(Object o) {
        initialized = true;
        return super.remove(o);
    }

    /**
     * Remove from the list all elements contained in the specified collection.
     *
     * @param c the collection of the elements to remove
     * @return  <code>true</code> if any element was removed from the list
     *
     * @see ArrayList#removeAll(Collection)
     */
    @Override
    public boolean removeAll(Collection<?> c) {
        initialized = true;
        return super.removeAll(c);
    }

    /**
     * Removes from this list all of its elements that are not contained in
     * the specified collection.
     *
     * @param c the collection of the elements to retain
     * @return  <code>true</code> if any element was removed from the list
     *
     * @see ArrayList#retainAll(Collection)
     */
    @Override
    public boolean retainAll(Collection<?> c) {
        initialized = true;
        return super.retainAll(c);
    }

    /**
     * Gets the number of elements contained in the List.
     *
     * @return the number of elements
     */
    @Override
    public int size() {
        initialized = true;
        return super.size();
    }

    /**
     * Returns an array containing all the elements in the list in
     * the proper sequence.
     *
     * @return array of all the elements
     *
     * @see ArrayList#toArray()
     */
    @Override
    public Object[] toArray() {
        initialized = true;
        return super.toArray();
    }

    /**
     * Returns an array containing all the elements in the list in
     * the proper sequence.
     *
     * @see ArrayList#toArray(Object[])
     */
    @Override
    public <T> T[] toArray(T[] a) {
        initialized = true;
        return super.toArray(a);
    }

    /**
     * Returns an iterator over the elements in this list in proper sequence.
     *
     * @return an iterator over the elements in this list in proper sequence
     */
    @Override
    public Iterator<E> iterator() {
        initialized = true;
        return super.iterator();
    }
}
