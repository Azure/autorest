/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit.Callback;
import retrofit.ResponseCallback;
import retrofit.RetrofitError;
import retrofit.client.Request;
import retrofit.client.Response;

/**
 * Exception thrown for an invalid response with custom error information.
 */
public abstract class ServiceCallback<T> implements Callback<T> {
    public T result;
    public ServiceException exception;

    @Override
    public void failure(RetrofitError error) {
        ServiceException ex = new ServiceException(error);
        ex.setResponse(error.getResponse());
        ex.setErrorModel(error.getBody());
        failure(ex);
    }

    public abstract void failure(ServiceException ex);
}
