/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import java.util.Collection;
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
    private Integer time;
    private Map<String, Integer> entryTime;
    private Map<String, Integer> exitTime;
    private Map<String, String> parent;
    private Set<String> processed;

    /**
     * Creates a directed graph.
     */
    public Graph() {
        this.graph = new HashMap<>();
        this.visited = new HashSet<>();
        this.time = 0;
        this.entryTime = new HashMap<>();
        this.exitTime = new HashMap<>();
        this.parent = new HashMap<>();
        this.processed = new HashSet<>();
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
     * @return all nodes in the graph.
     */
    public Collection<U> getNodes() {
        return graph.values();
    }

    /**
     * Perform DFS visit in this graph.
     * <p>
     * The directed graph will be traversed in DFS order and the visitor will be notified as
     * search explores each node and edge.
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
        time = 0;
        entryTime.clear();
        exitTime.clear();
        parent.clear();
        processed.clear();
    }

    private void dfs(Visitor visitor, Node<T> node) {
        visitor.visitNode(node);

        String fromKey = node.key();
        visited.add(fromKey);
        time++;
        entryTime.put(fromKey, time);
        for (String toKey : node.children()) {
            if (!visited.contains(toKey)) {
                parent.put(toKey, fromKey);
                visitor.visitEdge(fromKey, toKey, edgeType(fromKey, toKey));
                this.dfs(visitor, this.graph.get(toKey));
            } else {
                visitor.visitEdge(fromKey, toKey, edgeType(fromKey, toKey));
            }
        }
        time++;
        exitTime.put(fromKey, time);
        processed.add(fromKey);
    }

    private EdgeType edgeType(String fromKey, String toKey) {
        if (parent.containsKey(toKey) && parent.get(toKey).equals(fromKey)) {
            return EdgeType.TREE;
        }

        if (visited.contains(toKey) && !processed.contains(toKey)) {
            return EdgeType.BACK;
        }

        if (processed.contains(toKey) && entryTime.containsKey(toKey) && entryTime.containsKey(fromKey)) {
            if (entryTime.get(toKey) > entryTime.get(fromKey)) {
                return EdgeType.FORWARD;
            }

            if (entryTime.get(toKey) < entryTime.get(fromKey)) {
                return EdgeType.CROSS;
            }
        }

        throw new IllegalStateException("Internal Error: Unable to locate the edge type {" + fromKey + ", " + toKey + "}");
    }

    protected String findPath(String start, String end) {
        if (start.equals(end)) {
            return start;
        } else {
            return findPath(start, parent.get(end)) + " -> " + end;
        }
    }

    /**
     * The edge types in a graph.
     */
    enum EdgeType {
        /**
         * An edge (u, v) is a tree edge if v is visited the first time.
         */
        TREE,
        /**
         * An edge (u, v) is a forward edge if v is descendant of u.
         */
        FORWARD,
        /**
         * An edge (u, v) is a back edge if v is ancestor of u.
         */
        BACK,
        /**
         * An edge (u, v) is a cross edge if v is neither ancestor or descendant of u.
         */
        CROSS
    }

    /**
     * Represents a visitor to be implemented by the consumer who want to visit the
     * graph's nodes in DFS order by calling visit method.
     *
     * @param <U> the type of the node
     */
    interface Visitor<U> {
        /**
         * visit a node.
         *
         * @param node the node to visited
         */
        void visitNode(U node);

        /**
         * visit an edge.
         *
         * @param fromKey key of the from node
         * @param toKey key of the to node
         * @param edgeType the edge type
         */
        void visitEdge(String fromKey, String toKey, EdgeType edgeType);
    }
}
