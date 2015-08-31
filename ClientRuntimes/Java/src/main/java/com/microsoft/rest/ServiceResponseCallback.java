/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit.ResponseCallback;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * Inner callback used to merge both successful and failed responses into one
 * callback for customized response handling in a response handling delegate.
 */
public abstract class ServiceResponseCallback extends ResponseCallback {
    @Override
    public void failure(RetrofitError error) {
        response(error.getResponse(), error);
    }

    @Override
    public void success(Response response) {
        response(response, null);
    }

    /**
     * Override this method to handle REST call responses.
     *
     * @param response the response returned by Retrofit, if any
     * @param error the error returned by Retrofit, if any
     */
    public abstract void response(Response response, RetrofitError error);
}
