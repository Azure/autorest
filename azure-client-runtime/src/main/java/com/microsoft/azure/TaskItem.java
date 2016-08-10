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
     *
     * @throws Exception exception
     */
    void execute() throws Exception;

    /**
     * Executes the task asynchronously.
     * <p>
     * once executed the result will be available through result getter
     *
     * @param callback callback to call on success or failure
     * @return the handle of the REST call
     */
    ServiceCall executeAsync(ServiceCallback<U> callback);
}
