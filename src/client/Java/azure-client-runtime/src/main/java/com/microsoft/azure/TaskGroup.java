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
 * Represents a group of related tasks.
 * <p>
 * each task in a group is represented by {@link TaskItem}
 *
 * @param <T> the type of result of tasks in the group
 * @param <U> the task type
 */
public interface TaskGroup<T, U extends TaskItem<T>> {
    /**
     * Gets underlying directed acyclic graph structure that stores tasks in the group and
     * dependency information between them.
     *
     * @return the dag
     */
    DAGraph<U, DAGNode<U>> dag();

    /**
     * Merges this task group with parent task group.
     * <p>
     * once merged, calling execute in the parent group will executes the task in this
     * group as well.
     *
     * @param parentTaskGroup task group
     */
    void merge(TaskGroup<T, U> parentTaskGroup);

    /**
     * @return <tt>true</tt> if the group is responsible for preparing execution of original task in
     * this group and all tasks belong other task group it composes.
     */
    boolean isPreparer();

    /**
     * Prepare the graph for execution.
     */
    void prepare();

    /**
     * Executes the tasks in the group.
     * <p>
     * the order of execution of tasks ensure that a task gets selected for execution only after
     * the execution of all the tasks it depends on
     * @throws Exception the exception
     */
    void execute() throws Exception;

    /**
     * Executes the tasks in the group asynchronously.
     *
     * @param callback the callback to call on failure or success
     * @return the handle to the REST call
     */
    ServiceCall executeAsync(ServiceCallback<T> callback);

    /**
     * Gets the result of execution of a task in the group.
     * <p>
     * this method can null if the task has not yet been executed
     *
     * @param taskId the task id
     * @return the task result
     */
    T taskResult(String taskId);
}
