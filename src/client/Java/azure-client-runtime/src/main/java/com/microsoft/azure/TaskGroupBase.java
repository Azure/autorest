/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;

/**
 * The base implementation of TaskGroup interface.
 *
 * @param <T> the result type of the tasks in the group
 */
public abstract class TaskGroupBase<T>
    implements TaskGroup<T, TaskItem<T>> {
    private DAGraph<TaskItem<T>, DAGNode<TaskItem<T>>> dag;

    /**
     * Creates TaskGroupBase.
     *
     * @param rootTaskItemId the id of the root task in this task group
     * @param rootTaskItem the root task
     */
    public TaskGroupBase(String rootTaskItemId, TaskItem<T> rootTaskItem) {
        this.dag = new DAGraph<>(new DAGNode<>(rootTaskItemId, rootTaskItem));
    }

    @Override
    public DAGraph<TaskItem<T>, DAGNode<TaskItem<T>>> dag() {
        return dag;
    }

    @Override
    public boolean isPreparer() {
        return dag.isPreparer();
    }

    @Override
    public void merge(TaskGroup<T, TaskItem<T>> parentTaskGroup) {
        dag.merge(parentTaskGroup.dag());
    }

    @Override
    public void prepare() {
        if (isPreparer()) {
            dag.prepare();
        }
    }

    @Override
    public void execute() throws Exception {
        DAGNode<TaskItem<T>> nextNode = dag.getNext();
        if (nextNode == null) {
            return;
        }

        if (dag.isRootNode(nextNode)) {
            executeRootTask(nextNode.data());
        } else {
            nextNode.data().execute(this, nextNode);
        }
    }

    @Override
    public ServiceCall executeAsync(final ServiceCallback<Void> callback) {
        final DAGNode<TaskItem<T>> nextNode = dag.getNext();
        if (nextNode == null) {
            return null;
        }

        if (dag.isRootNode(nextNode)) {
            return executeRootTaskAsync(nextNode.data(), callback);
        } else {
            return nextNode.data().executeAsync(this, nextNode, callback);
        }
    }

    @Override
    public T taskResult(String taskId) {
        return dag.getNodeData(taskId).result();
    }

    /**
     * Executes the root task in this group.
     * <p>
     * This method will be invoked when all the task dependencies of the root task are finished
     * executing, at this point root task can be executed by consuming the result of tasks it
     * depends on.
     *
     * @param task the root task in this group
     * @throws Exception the exception
     */
    public abstract void executeRootTask(TaskItem<T> task) throws Exception;

    /**
     * Executes the root task in this group asynchronously.
     * <p>
     * This method will be invoked when all the task dependencies of the root task are finished
     * executing, at this point root task can be executed by consuming the result of tasks it
     * depends on.
     *
     * @param task the root task in this group
     * @param callback the callback when the task fails or succeeds
     * @return the handle to the REST call
     */
    public abstract ServiceCall executeRootTaskAsync(TaskItem<T> task, ServiceCallback<Void> callback);
}
