package com.microsoft.azure;

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
     * @return <tt>true</tt> if this is a root (parent) task group composing other task groups.
     */
    boolean isRoot();

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
     * Executes the tasks in the group.
     * <p>
     * the order of execution of tasks ensure that a task gets selected for execution only after
     * the execution of all the tasks it depends on
     * @throws Exception the exception
     */
    void execute() throws Exception;

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
