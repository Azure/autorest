/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit2.Response;

/**
 * Exception thrown for an invalid response with custom error information.
 */
public class ServiceException extends RestException {
    /**
     * Information about the associated HTTP response.
     */
    private Response response;

    /**
     * The HTTP response body.
     */
    private Object body;

    /**
     * Initializes a new instance of the ServiceException class.
     */
    public ServiceException() { }

    /**
     * Initializes a new instance of the ServiceException class.
     *
     * @param message The exception message.
     */
    public ServiceException(final String message) {
        super(message);
    }

    /**
     * Initializes a new instance of the ServiceException class.
     *
     * @param message the exception message
     * @param cause   exception that caused this exception to occur
     */
    public ServiceException(final String message, final Throwable cause) {
        super(message, cause);
    }

    /**
     * Initializes a new instance of the ServiceException class.
     *
     * @param cause exception that caused this exception to occur
     */
    public ServiceException(final Throwable cause) {
        super(cause);
    }

    /**
     * Gets information about the associated HTTP response.
     *
     * @return the HTTP response
     */
    public Response getResponse() {
        return response;
    }

    /**
     * Gets the HTTP response body.
     *
     * @return the response body
     */
    public Object getBody() {
        return body;
    }

    /**
     * Sets the HTTP response.
     *
     * @param response the HTTP response
     */
    public void setResponse(Response response) {
        this.response = response;
    }

    /**
     * Sets the HTTP response body.
     *
     * @param body the response object
     */
    public void setBody(Object body) {
        this.body = body;
    }
}
