/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

/**
 * The base implementation of TaskGroup interface.
 *
 * @param <T> the result type of the tasks in the group
 * @param <U> type representing task in the group
 */
public abstract class TaskGroupBase<T, U extends TaskItem<T>>
    implements TaskGroup<T, U> {
    private DAGraph<U, DAGNode<U>> dag;

    /**
     * Creates TaskGroupBase.
     *
     * @param rootTaskItemId the id of the root task in this task group
     * @param rootTaskItem the root task
     */
    public TaskGroupBase(String rootTaskItemId, U rootTaskItem) {
        this.dag = new DAGraph<>(new DAGNode<>(rootTaskItemId, rootTaskItem));
    }

    @Override
    public DAGraph<U, DAGNode<U>> dag() {
        return dag;
    }

    @Override
    public boolean isRoot() {
        return !dag.hasParent();
    }

    @Override
    public void merge(TaskGroup<T, U> parentTaskGroup) {
        dag.merge(parentTaskGroup.dag());
    }

    @Override
    public void execute() throws Exception {
        if (isRoot()) {
            dag.prepare();
            DAGNode<U> nextNode = dag.getNext();
            while (nextNode != null) {
                if (dag.isRootNode(nextNode)) {
                    executeRootTask(nextNode.data());
                } else {
                    nextNode.data().execute();
                }
                dag.reportedCompleted(nextNode);
                nextNode = dag.getNext();
            }
        }
    }

    @Override
    public T taskResult(String taskId) {
        return dag.getNodeData(taskId).result();
    }

    /**
     * executes the root task in this group.
     * <p>
     * this method will be invoked when all the task dependencies of the root task are finished
     * executing, at this point root task can be executed by consuming the result of tasks it
     * depends on.
     *
     * @param task the root task in this group
     * @throws Exception the exception
     */
    public abstract void executeRootTask(U task) throws Exception;
}
