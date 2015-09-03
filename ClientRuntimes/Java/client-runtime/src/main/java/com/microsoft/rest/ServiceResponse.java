/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit.client.Response;

/**
 * An instance of this class holds a response object and a raw REST response.
 */
public class ServiceResponse<T> {
    private T body;
    private Response response;

    /**
     * Instantiate a ServiceResponse instance with a response object and a raw REST response
     * @param body deserialized response object
     * @param response raw REST response
     */
    public ServiceResponse(T body, Response response) {
        this.body = body;
        this.response = response;
    }

    /**
     * Gets the response object.
     * @return the response object. Null if there isn't one.
     */
    public T getBody() {
        return this.body;
    }

    /**
     * Gets the raw REST response.
     * @return the raw REST response.
     */
    public Response getResponse() {
        return this.response;
    }
}
