/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Represents a hash map that supports on-demand initialization.
 *
 * @param <K> type parameter for key
 * @param <V> type parameter for value
 */
public class LazyHashMap<K, V> extends HashMap<K, V> implements LazyCollection {
    private static final long serialVersionUID = 1L;
    
    private boolean initialized;

    /**
     * Get a value indicating whether the hash map is initialized.
     *
     * @return <code>true</code> if hash map has been initialized
     *
     * @see    LazyCollection#isInitialized()
     */
    @Override
    public boolean isInitialized() {
        return initialized;
    }

    /**
     * Removes all elements from the hash map.
     *
     * @see HashMap#clear()
     */
    @Override
    public void clear() {
        initialized = true;
        super.clear();
    }

    /**
     * Determines whether the hash map contains the specified key.
     *
     * @param key the key to locate in the hash map
     * @return    <code>true</code> if the hash map contains an element
     *            with the specified key; otherwise, <code>false</code>.
     */
    @Override
    public boolean containsKey(Object key) {
        initialized = true;
        return super.containsKey(key);
    }

    /**
     * Determines whether the hash map contains the specified value.
     *
     * @param value the value to locate in the hash map
     * @return      <code>true</code> if the hash map contains an element
     *              with the specified value; otherwise, <code>false</code>.
     */
    @Override
    public boolean containsValue(Object value) {
        initialized = true;
        return super.containsValue(value);
    }

    /**
     * Returns a set of the mappings in the hash map.
     *
     * @return a set of the mappings contained in this map
     *
     * @see    HashMap#entrySet()
     */
    @Override
    public Set<java.util.Map.Entry<K, V>> entrySet() {
        initialized = true;
        return super.entrySet();
    }

    /**
     * Gets the value associated with the specified key.
     *
     * @param key the key of the value to get
     * @return    the value associated with the specified key, or {@code null}
     *            if the key is not found
     *
     * @see HashMap#get(Object)
     */
    @Override
    public V get(Object key) {
        initialized = true;
        return super.get(key);
    }

    /**
     * If the hash map is empty.
     *
     * @return <code>true</code> if this hash map is empty
     */
    @Override
    public boolean isEmpty() {
        initialized = true;
        return super.isEmpty();
    }

    /**
     * Gets a set containing the keys in the hash map.
     *
     * @return a set containing the keys.
     */
    @Override
    public Set<K> keySet() {
        initialized = true;
        return super.keySet();
    }

    /**
     * Sets the value associated with the specified key.
     *
     * @param key   key with which the specified value is to be set
     * @param value the value to set with the specified key
     * @return      the previous value associated with the key, or {@code null}
     *              if the key does not previously exist
     *
     * @see         HashMap#put(Object, Object)
     */
    @Override
    public V put(K key, V value) {
        initialized = true;
        return super.put(key, value);
    }

    /**
     * Copy all the mappings into the hash map. Existing mappings with the
     * same keys will be replaced.
     *
     * @param m mappings to be stored in the hash map
     *
     * @see     HashMap#putAll(Map)
     */
    @Override
    public void putAll(Map<? extends K, ? extends V> m) {
        initialized = true;
        super.putAll(m);
    }

    /**
     * Removes the mapping with the specified key from the hash map if present.
     * .
     * @param key key whose mapping is to be removed from the map
     * @return    the previous value associated with the key, or {@code null}
     *            if the key does not previously exist
     *
     * @see       HashMap#remove(Object)
     */
    @Override
    public V remove(Object key) {
        initialized = true;
        return super.remove(key);
    }

    /**
     * Gets the number of mappings contained in the hash map.
     *
     * @return the number of mappings
     */
    @Override
    public int size() {
        initialized = true;
        return super.size();
    }

    /**
     * Gets a collection containing the values in the hash map.
     *
     * @return a collection containing the values.
     */
    @Override
    public Collection<V> values() {
        initialized = true;
        return super.values();
    }
}
