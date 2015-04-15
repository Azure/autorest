/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

public class HttpOperationResponse<T> {
    private HttpRequest request;
    private HttpResponse response;

    /**
     * Gets the HTTP request.
     *
     * @return The HTTP request.
     */
    public HttpRequest getRequest() {
        return this.request;
    }

    /**
     * Sets the HTTP request.
     *
     * @param request The HTTP request.
     */
    public void setRequest(HttpRequest request) {
        this.request = request;
    }

    /**
     * Gets the HTTP response.
     *
     * @return The HTTP response.
     */
    public HttpResponse getResponse() {
        return this.response;
    }

    /**
     * Sets the HTTP response.
     *
     * @param request The HTTP response.
     */
    public void setResponse(HttpResponse request) {
        this.response = response;
    }

    private T body;

    /**
     * Gets the response object.
     * 
     * @return The response object.
     */
    public T getBody() {
        return this.body;
    }

    /**
     * Sets the response object.
     * 
     * @param body The response object.
     */
    public void setBody(T body) {
        this.body = body;
    }
}
