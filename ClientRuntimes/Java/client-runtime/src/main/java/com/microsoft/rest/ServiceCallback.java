/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * The callback used for client side asynchronous operations.
 */
public abstract class ServiceCallback<T> implements Callback<ServiceResponse<T>> {
    @Override
    public void failure(RetrofitError error) {
        ServiceException ex = new ServiceException(error);
        ex.setResponse(error.getResponse());
        ex.setErrorModel(error.getBody());
        failure(ex);
    }

    @Override
    public void success(ServiceResponse<T> result, Response response) {
        success(result);
    }

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
