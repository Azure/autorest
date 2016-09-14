/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import rx.Observable;

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
     * Executes the task asynchronously.
     * <p>
     * once executed the result will be available through result getter
     *
     * @return the handle of the REST call
     */
    Observable<U> executeAsync();
}
