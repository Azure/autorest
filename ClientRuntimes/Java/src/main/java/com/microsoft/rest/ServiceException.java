/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit.client.Request;
import retrofit.client.Response;

/**
 * Exception thrown for an invalid response with custom error information.
 */
public class ServiceException extends Exception {

    /**
     * Information about the associated HTTP response.
     */
    private Response response;

    /**
     * The HTTP response object.
     */
    private Object errorModel;

    /**
     * Initializes a new instance of the ServiceException class.
     */
    public ServiceException() {}

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
     * Gets the HTTP response object.
     *
     * @return the response object
     */
    public Object getErrorModel() {
        return errorModel;
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
     * Sets the HTTP response object.
     *
     * @param errorModel the response object
     */
    public void setErrorModel(Object errorModel) {
        this.errorModel = errorModel;
    }
}
