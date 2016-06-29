/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Type represents a node in a {@link Graph}.
 *
 * @param <T> the type of the data stored in the node
 */
public class Node<T> {
    private String key;
    private T data;
    private List<String> children;

    /**
     * Creates a graph node.
     *
     * @param key unique id of the node
     * @param data data to be stored in the node
     */
    public Node(String key, T data) {
        this.key = key;
        this.data = data;
        this.children = new ArrayList<>();
    }

    /**
     * @return this node's unique id
     */
    public String key() {
        return this.key;
    }

    /**
     * @return data stored in this node
     */
    public T data() {
        return data;
    }

    /**
     * @return <tt>true</tt> if this node has any children
     */
    public boolean hasChildren() {
        return !this.children.isEmpty();
    }

    /**
     * @return children (neighbours) of this node
     */
    public List<String> children() {
        return Collections.unmodifiableList(this.children);
    }

    /**
     * @param childKey add a child (neighbour) of this node
     */
    public void addChild(String childKey) {
        this.children.add(childKey);
    }
}
