/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

/**
 * Represents the base return type of all ServiceClient REST operations.
 *
 * @param <T> the type of Http response object
 */
public class HttpOperationResponse<T> {
    private HttpRequest request;
    private HttpResponse response;
    private T body;

    /**
     * Gets information about the associated HTTP request.
     *
     * @return the HTTP request
     */
    public HttpRequest getRequest() {
        return this.request;
    }

    /**
     * Sets the HTTP request.
     *
     * @param request the HTTP request
     */
    public void setRequest(HttpRequest request) {
        this.request = request;
    }

    /**
     * Gets information about the associated HTTP response.
     *
     * @return the HTTP response
     */
    public HttpResponse getResponse() {
        return this.response;
    }

    /**
     * Sets the HTTP response.
     *
     * @param request the HTTP response
     */
    public void setResponse(HttpResponse request) {
        this.response = response;
    }

    /**
     * Gets the HTTP response object.
     * 
     * @return the HTTP response object
     */
    public T getBody() {
        return this.body;
    }

    /**
     * Sets the HTTP response object.
     * 
     * @param body the HTTP response object
     */
    public void setBody(T body) {
        this.body = body;
    }
}
