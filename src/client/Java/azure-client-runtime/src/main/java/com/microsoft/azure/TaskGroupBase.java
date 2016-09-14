/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import rx.Observable;
import rx.functions.Func1;

import java.util.ArrayList;
import java.util.List;

/**
 * The base implementation of TaskGroup interface.
 *
 * @param <T> the result type of the tasks in the group
 * @param <U> the task item
 */
public abstract class TaskGroupBase<T, U extends TaskItem<T>>
    implements TaskGroup<T, U> {
    /**
     * Stores the tasks in this group and their dependency information.
     */
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
    public Observable<T> executeAsync() {
        DAGNode<U> nextNode = dag.getNext();
        final List<Observable<T>> observables = new ArrayList<>();
        while (nextNode != null) {
            final DAGNode<U> thisNode = nextNode;
            observables.add(nextNode.data().executeAsync()
                    .flatMap(new Func1<T, Observable<T>>() {
                        @Override
                        public Observable<T> call(T t) {
                            dag().reportedCompleted(thisNode);
                            if (dag().isRootNode(thisNode)) {
                                return Observable.just(t);
                            } else {
                                return executeAsync();
                            }
                        }
                    }));
            nextNode = dag.getNext();
        }
        return Observable.merge(observables);
    }

    @Override
    public T taskResult(String taskId) {
        return dag.getNodeData(taskId).result();
    }
}
