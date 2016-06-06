package com.microsoft.azure;

/**
 * Type representing a task in a task group {@link TaskGroup}.
 *
 * @param <U> the task result type
 */
public interface TaskItem<U> {
    /**
     * @return the result of the task execution
     */
    U result();

    /**
     * Executes the task.
     * <p>
     * once executed the result will be available through result getter
     * @throws Exception exception
     */
    void execute() throws Exception;
}
