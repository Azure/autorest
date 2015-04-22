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
 * The Service Exception indicates an error while executing a service operation.
 */
public class ServiceExceptionModel<T> {

    /**
     * Information about the associated HTTP request.
     */
    private T body;



    public ServiceExceptionModel() {
    }

    public ServiceExceptionModel(final T body) {
        this.body = body;
    }

    public T getBody() {
        return body;
    }
}
