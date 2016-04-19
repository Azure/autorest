/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import okhttp3.ResponseBody;
import retrofit2.Response;

/**
 * An instance of this class holds a response object and a raw REST response.
 *
 * @param <T> the type of the response
 */
public class ServiceResponse<T> {
    /**
     * The response body object.
     */
    private T body;

    /**
     * The retrofit response wrapper containing information about the REST response.
     */
    private Response<ResponseBody> response;

    /**
     * The retrofit response wrapper if it's returned from a HEAD operation.
     */
    private Response<Void> headResponse;

    /**
     * Instantiate a ServiceResponse instance with a response object and a raw REST response.
     *
     * @param body deserialized response object
     * @param response raw REST response
     */
    public ServiceResponse(T body, Response<ResponseBody> response) {
        this.body = body;
        this.response = response;
    }

    /**
     * Instantiate a ServiceResponse instance with a response from a HEAD operation.
     *
     * @param headResponse raw REST response from a HEAD operation
     */
    public ServiceResponse(Response<Void> headResponse) {
        this.headResponse = headResponse;
    }

    /**
     * Gets the response object.
     * @return the response object. Null if there isn't one.
     */
    public T getBody() {
        return this.body;
    }

    /**
     * Sets the response object.
     *
     * @param body the response object.
     */
    public void setBody(T body) {
        this.body = body;
    }

    /**
     * Gets the raw REST response.
     *
     * @return the raw REST response.
     */
    public Response<ResponseBody> getResponse() {
        return response;
    }

    /**
     * Gets the raw REST response from a HEAD operation.
     *
     * @return the raw REST response from a HEAD operation.
     */
    public Response<Void> getHeadResponse() {
        return headResponse;
    }
}
