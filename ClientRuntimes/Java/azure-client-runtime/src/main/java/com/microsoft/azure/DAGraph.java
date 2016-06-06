package com.microsoft.azure;

import java.util.ArrayDeque;
import java.util.Map;
import java.util.Queue;

/**
 * Type representing a DAG (directed acyclic graph).
 * <p>
 * each node in a DAG is represented by {@link DAGNode}
 *
 * @param <T> the type of the data stored in the graph nodes
 * @param <U> the type of the nodes in the graph
 */
public class DAGraph<T, U extends DAGNode<T>> extends Graph<T, U> {
    private Queue<String> queue;
    private boolean hasParent;
    private U rootNode;

    /**
     * Creates a new DAG.
     *
     * @param rootNode the root node of this DAG
     */
    public DAGraph(U rootNode) {
        this.rootNode = rootNode;
        this.queue = new ArrayDeque<>();
        this.addNode(rootNode);
    }

    /**
     * @return <tt>true</tt> if this DAG is merged with another DAG and hence has a parent
     */
    public boolean hasParent() {
        return hasParent;
    }

    /**
     * Checks whether the given node is root node of this DAG.
     *
     * @param node the node {@link DAGNode} to be checked
     * @return <tt>true</tt> if the given node is root node
     */
    public boolean isRootNode(U node) {
        return this.rootNode == node;
    }

    /**
     * Merge this DAG with another DAG.
     * <p>
     * this will mark this DAG as a child DAG, the dependencies of nodes in this DAG will be merged
     * with (copied to) the parent DAG
     *
     * @param parent the parent DAG
     */
    public void merge(DAGraph<T, U> parent) {
        this.hasParent = true;
        parent.rootNode.addDependency(this.rootNode.key());
        this.rootNode.addDependent(parent.rootNode.key());
        for (Map.Entry<String, U> entry: graph.entrySet()) {
            String key = entry.getKey();
            if (!parent.graph.containsKey(key)) {
                parent.graph.put(key, entry.getValue());
            }
        }
    }

    /**
     * Prepares this DAG for traversal using getNext method, each call to getNext returns next node
     * in the DAG with no dependencies.
     */
    public void prepare() {
        initializeQueue();
        if (queue.isEmpty()) {
            throw new RuntimeException("Found circular dependency");
        }
    }

    /**
     * Gets next node in the DAG which has no dependency or all of it's dependencies are resolved and
     * ready to be consumed.
     * <p>
     * null will be returned when all the nodes are explored
     *
     * @return next node
     */
    public U getNext() {
        return graph.get(queue.poll());
    }

    /**
     * Gets the data stored in a graph node with a given key.
     *
     * @param key the key of the node
     * @return the value stored in the node
     */
    public T getNodeData(String key) {
       return graph.get(key).data();
    }

    /**
     * Reports that a node is resolved hence other nodes depends on it can consume it.
     *
     * @param completed the node ready to be consumed
     */
    public void reportedCompleted(U completed) {
        String dependency = completed.key();
        for (String dependentKey : graph.get(dependency).dependentKeys()) {
            DAGNode<T> dependent = graph.get(dependentKey);
            dependent.reportResolved(dependency);
            if (dependent.hasAllResolved()) {
                queue.add(dependent.key());
            }
        }
    }

    /**
     * populate dependents of all nodes.
     * <p>
     * the DAG will be explored in DFS order and all node's dependents will be identified,
     * this prepares the DAG for traversal using getNext method, each call to getNext returns next node
     * in the DAG with no dependencies.
     */
    public void populateDependentKeys() {
        this.queue.clear();
        visit(new Visitor<U>() {
            @Override
            public void visit(U node) {
                if (node.dependencyKeys().isEmpty()) {
                    queue.add(node.key());
                    return;
                }

                String dependentKey = node.key();
                for (String dependencyKey : node.dependencyKeys()) {
                    graph.get(dependencyKey)
                            .dependentKeys()
                            .add(dependentKey);
                }
            }
        });
    }

    /**
     * Initializes the queue that tracks the next set of nodes with no dependencies or
     * whose dependencies are resolved.
     */
    private void initializeQueue() {
        this.queue.clear();
        for (Map.Entry<String, U> entry: graph.entrySet()) {
            if (!entry.getValue().hasDependencies()) {
                this.queue.add(entry.getKey());
            }
        }
    }
}
