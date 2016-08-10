/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;

import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * The base implementation of TaskGroup interface.
 *
 * @param <T> the result type of the tasks in the group
 * @param <U> the task item
 */
public abstract class TaskGroupBase<T, U extends TaskItem<T>>
    implements TaskGroup<T, U> {
    private DAGraph<U, DAGNode<U>> dag;
    private ParallelServiceCall parallelServiceCall;

    /**
     * Creates TaskGroupBase.
     *
     * @param rootTaskItemId the id of the root task in this task group
     * @param rootTaskItem the root task
     */
    public TaskGroupBase(String rootTaskItemId, U rootTaskItem) {
        this.dag = new DAGraph<>(new DAGNode<>(rootTaskItemId, rootTaskItem));
        this.parallelServiceCall = new ParallelServiceCall();
    }

    @Override
    public DAGraph<U, DAGNode<U>> dag() {
        return dag;
    }

    @Override
    public boolean isPreparer() {
        return dag.isPreparer();
    }

    @Override
    public void merge(TaskGroup<T, U> parentTaskGroup) {
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
        DAGNode<U> nextNode = dag.getNext();
        while (nextNode != null) {
            nextNode.data().execute();
            this.dag().reportedCompleted(nextNode);
            nextNode = dag.getNext();
        }
    }

    @Override
    public ServiceCall<T> executeAsync(final ServiceCallback<T> callback) {
        executeReadyTasksAsync(callback);
        return parallelServiceCall;
    }

    @Override
    public T taskResult(String taskId) {
        return dag.getNodeData(taskId).result();
    }

    /**
     * Executes all runnable tasks, a task is runnable when all the tasks its depends
     * on are finished running.
     *
     * @param callback the callback
     */
    private void executeReadyTasksAsync(final ServiceCallback<T> callback) {
        DAGNode<U> nextNode = dag.getNext();
        while (nextNode != null) {
            ServiceCall serviceCall = nextNode.data().executeAsync(taskCallback(nextNode, callback));
            this.parallelServiceCall.addCall(serviceCall);
            nextNode = dag.getNext();
        }
    }

    /**
     * This method create and return a callback for the runnable task stored in the given node.
     * This callback wraps the given callback.
     *
     * @param taskNode the node containing runnable task
     * @param callback the callback to wrap
     * @return the task callback
     */
    private ServiceCallback<T> taskCallback(final DAGNode<U> taskNode, final ServiceCallback<T> callback) {
        final TaskGroupBase<T, U> self = this;
        return new ServiceCallback<T>() {
            @Override
            public void failure(Throwable t) {
                callback.failure(t);
                parallelServiceCall.failure(t);
            }

            @Override
            public void success(ServiceResponse<T> result) {
                self.dag().reportedCompleted(taskNode);
                if (self.dag().isRootNode(taskNode)) {
                    if (callback != null) {
                        callback.success(result);
                    }
                    parallelServiceCall.success(result);
                } else {
                    self.executeReadyTasksAsync(callback);
                }
            }
        };
    }

    /**
     * Type represents a set of REST calls running possibly in parallel.
     */
    private class ParallelServiceCall extends ServiceCall<T> {
        private ConcurrentLinkedQueue<ServiceCall<?>> serviceCalls;

        /**
         * Creates a ParallelServiceCall.
         */
        ParallelServiceCall() {
            super(null);
            this.serviceCalls = new ConcurrentLinkedQueue<>();
        }

        /**
         * Cancels all the service calls currently executing.
         */
        public void cancel() {
            for (ServiceCall<?> call : this.serviceCalls) {
                call.cancel(true);
            }
        }

        /**
         * @return true if the call has been canceled; false otherwise.
         */
        public boolean isCancelled() {
            for (ServiceCall<?> call : this.serviceCalls) {
                if (!call.isCancelled()) {
                    return false;
                }
            }
            return true;
        }

        /**
         * Add a call to the list of parallel calls.
         *
         * @param call the call
         */
        private void addCall(ServiceCall<?> call) {
            this.serviceCalls.add(call);
        }
    }
}
