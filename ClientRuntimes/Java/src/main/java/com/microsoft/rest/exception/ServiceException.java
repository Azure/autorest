/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.exception;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

import java.io.IOException;

/**
 * The Service Exception indicates an error while executing a service operation.
 */
public class ServiceException extends Exception {

    /**
     * Information about the associated HTTP request.
     */
    public HttpRequest request;

    /**
     * Information about the associated HTTP response.
     */
    public HttpResponse response;

    public ServiceException() {
        super();
    }

    public ServiceException(final String message) {
        super(message);
    }

    public ServiceException(final String message, final Throwable cause) {
        super(message, cause);
    }

    public ServiceException(final Throwable cause) {
        super(cause);
    }

    @Override
    public String getMessage() {
        final StringBuffer buffer = new StringBuffer(50);
        buffer.append(super.getMessage());

        if (this.response != null) {
            String responseBody = "\nResponse Body: ";
            try {
                responseBody += IOUtils.toString(response.getEntity().getContent());
            } catch (IOException e) {
                // silent
            }
            buffer.append(responseBody);
        }

        return buffer.toString();
    }
}
