/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit.client.Response;

/**
 * Exception thrown for an invalid response with custom error information.
 */
public class ServiceResponseSyncCallback<T> extends ServiceCallback<T> {
    private boolean complete;
    private T result;
    private ServiceException exception;

    public ServiceResponseSyncCallback() {
        this.complete = false;
    }

    public boolean isComplete() {
        return this.complete;
    }

    public T getResult() {
        return this.result;
    }

    public ServiceException getException() {
        return this.exception;
    }

    @Override
    public void failure(ServiceException exeption) {
        this.exception = exeption;
        complete = true;
        notifyAll();
    }

    @Override
    public void success(T t, Response response) {
        this.result = t;
        notifyAll();
    }
}
