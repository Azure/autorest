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
import retrofit.client.Response;

/**
 * Exception thrown for an invalid response with custom error information.
 */
public abstract class ServiceResponseCallback<T> implements Callback<T> {
    @Override
    public void failure(RetrofitError error) {
        response(null, error.getResponse(), error);
    }

    @Override
    public void success(T t, Response response) {
        response(t, response, null);
    }

    public abstract void response(T t, Response response, RetrofitError ex);
}
