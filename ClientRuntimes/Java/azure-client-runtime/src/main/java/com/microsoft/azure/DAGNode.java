/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import java.util.ArrayList;
import java.util.List;

/**
 * The type representing node in a {@link DAGraph}.
 *
 * @param <T> the type of the data stored in the node
 */
public class DAGNode<T> extends Node<T> {
    private List<String> dependentKeys;
    private int toBeResolved;

    /**
     * Creates a DAG node.
     *
     * @param key unique id of the node
     * @param data data to be stored in the node
     */
    public DAGNode(String key, T data) {
        super(key, data);
        dependentKeys = new ArrayList<>();
    }

    /**
     * @return a list of keys of nodes in {@link DAGraph} those are dependents on this node
     */
    List<String> dependentKeys() {
        return this.dependentKeys;
    }

    /**
     * mark the node identified by the given key as dependent of this node.
     *
     * @param key the id of the dependent node
     */
    public void addDependent(String key) {
        this.dependentKeys.add(key);
    }

    /**
     * @return a list of keys of nodes in {@link DAGraph} that this node depends on
     */
    public List<String> dependencyKeys() {
        return this.children();
    }

    /**
     * mark the node identified by the given key as this node's dependency.
     *
     * @param dependencyKey the id of the dependency node
     */
    public void addDependency(String dependencyKey) {
        toBeResolved++;
        super.addChild(dependencyKey);
    }

    /**
     * @return <tt>true</tt> if this node has any dependency
     */
    public boolean hasDependencies() {
        return this.hasChildren();
    }

    /**
     * @return <tt>true</tt> if all dependencies of this node are ready to be consumed
     */
    boolean hasAllResolved() {
        return toBeResolved == 0;
    }

    /**
     * Reports that one of this node's dependency has been resolved and ready to be consumed.
     *
     * @param dependencyKey the id of the dependency node
     */
    void reportResolved(String dependencyKey) {
        if (toBeResolved == 0) {
            throw new RuntimeException("invalid state - " + this.key() + ": The dependency '" + dependencyKey + "' is already reported or there is no such dependencyKey");
        }
        toBeResolved--;
    }
}
