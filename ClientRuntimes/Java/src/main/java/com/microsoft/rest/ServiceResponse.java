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
import retrofit.converter.Converter;

/**
 * Exception thrown for an invalid response with custom error information.
 */
public class ServiceResponse<T> {
    private T body;
    private Response response;

    public ServiceResponse(T body, Response response) {
        this.body = body;
        this.response = response;
    }

    public T getBody() {
        return this.body;
    }

    public Response getResponse() {
        return this.response;
    }
}
