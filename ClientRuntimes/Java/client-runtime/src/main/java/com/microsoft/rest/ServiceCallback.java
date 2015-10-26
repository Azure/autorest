/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

/**
 * The callback used for client side asynchronous operations.
 */
public abstract class ServiceCallback<T> {
    /**
     * Override this method to handle REST call failures.
     *
     * @param exception the exception thrown from the pipeline.
     */
    public abstract void failure(ServiceException exception);

    /**
     * Override this method to handle successful REST call results.
     *
     * @param result the ServiceResponse holding the response.
     */
    public abstract void success(ServiceResponse<T> result);
}
