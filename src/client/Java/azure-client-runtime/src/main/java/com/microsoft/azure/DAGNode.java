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
import java.util.concurrent.locks.ReentrantLock;

/**
 * The type representing node in a {@link DAGraph}.
 *
 * @param <T> the type of the data stored in the node
 */
public class DAGNode<T> extends Node<T> {
    private List<String> dependentKeys;
    private int toBeResolved;
    private boolean isPreparer;
    private ReentrantLock lock;

    /**
     * Creates a DAG node.
     *
     * @param key unique id of the node
     * @param data data to be stored in the node
     */
    public DAGNode(String key, T data) {
        super(key, data);
        dependentKeys = new ArrayList<>();
        lock = new ReentrantLock();
    }

    /**
     * @return the lock to be used while performing thread safe operation on this node.
     */
    public ReentrantLock lock() {
        return this.lock;
    }

    /**
     * @return a list of keys of nodes in {@link DAGraph} those are dependents on this node
     */
    List<String> dependentKeys() {
        return Collections.unmodifiableList(this.dependentKeys);
    }

    /**
     * Mark the node identified by the given key as dependent of this node.
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
     * Mark the node identified by the given key as this node's dependency.
     *
     * @param dependencyKey the id of the dependency node
     */
    public void addDependency(String dependencyKey) {
        super.addChild(dependencyKey);
    }

    /**
     * @return <tt>true</tt> if this node has any dependency
     */
    public boolean hasDependencies() {
        return this.hasChildren();
    }

    /**
     * Mark or un-mark this node as preparer.
     *
     * @param isPreparer <tt>true</tt> if this node needs to be marked as preparer, <tt>false</tt> otherwise.
     */
    public void setPreparer(boolean isPreparer) {
        this.isPreparer = isPreparer;
    }

    /**
     * @return <tt>true</tt> if this node is marked as preparer
     */
    public boolean isPreparer() {
        return isPreparer;
    }

    /**
     * Initialize the node so that traversal can be performed on the parent DAG.
     */
    public void initialize() {
        this.toBeResolved = this.dependencyKeys().size();
        this.dependentKeys.clear();
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
