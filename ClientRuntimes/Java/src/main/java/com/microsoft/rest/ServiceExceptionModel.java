/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

import java.io.IOException;

/**
 * A generic wrapper for the HTTP response object.
 *
 * @param <T> the type of the HTTP response object
 */
public class ServiceExceptionModel<T> {

    /**
     * Information about the HTTP response object.
     */
    private T body;

    /**
     * Initialize an instance of ServiceExceptionModel with an empty body.
     */
    public ServiceExceptionModel() {
    }

    /**
     * Initialize an instance of ServiceExceptionModel with a response object.
     *
     * @param body the HTTP response object
     */
    public ServiceExceptionModel(final T body) {
        this.body = body;
    }

    /**
     * Gets the HTTP response object.
     *
     * @return the HTTP response object
     */
    public T getBody() {
        return body;
    }
}
