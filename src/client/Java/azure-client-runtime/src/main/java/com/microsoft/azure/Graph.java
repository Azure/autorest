/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Type representing a directed graph data structure.
 * <p>
 * Each node in a graph is represented by {@link Node}
 *
 * @param <T> the type of the data stored in the graph's nodes
 * @param <U> the type of the nodes in the graph
 */
public class Graph<T, U extends Node<T>> {
    protected Map<String, U> graph;
    private Set<String> visited;

    /**
     * Creates a directed graph.
     */
    public Graph() {
        this.graph = new HashMap<>();
        this.visited = new HashSet<>();
    }

    /**
     * Adds a node to this graph.
     *
     * @param node the node
     */
    public void addNode(U node) {
        graph.put(node.key(), node);
    }

    /**
     * Represents a visitor to be implemented by the consumer who want to visit the
     * graph's nodes in DFS order.
     *
     * @param <U> the type of the node
     */
    interface Visitor<U> {
        /**
         * visit a node.
         *
         * @param node the node to visited
         */
        void visit(U node);
    }

    /**
     * Perform DFS visit in this graph.
     * <p>
     * The directed graph will be traversed in DFS order and the visitor will be notified as
     * search explores each node
     *
     * @param visitor the graph visitor
     */
    public void visit(Visitor visitor) {
        for (Map.Entry<String, ? extends Node<T>> item : graph.entrySet()) {
            if (!visited.contains(item.getKey())) {
                this.dfs(visitor, item.getValue());
            }
        }
        visited.clear();
    }

    private void dfs(Visitor visitor, Node<T> node) {
        visitor.visit(node);
        visited.add(node.key());
        for (String childKey : node.children()) {
            if (!visited.contains(childKey)) {
                this.dfs(visitor, this.graph.get(childKey));
            }
        }
    }
}
