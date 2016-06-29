/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

/**
 * Exception thrown for an invalid response with custom error information.
 */
public abstract class RestException extends Exception {
    /**
     * Initializes a new instance of the AutoRestException class.
     */
    public RestException() { }

    /**
     * Initializes a new instance of the AutoRestException class.
     *
     * @param message The exception message.
     */
    public RestException(String message) {
        super(message);
    }

    /**
     * Initializes a new instance of the AutoRestException class.
     *
     * @param cause exception that caused this exception to occur
     */
    public RestException(Throwable cause) {
        super(cause);
    }

    /**
     * Initializes a new instance of the AutoRestException class.
     *
     * @param message the exception message
     * @param cause   exception that caused this exception to occur
     */
    public RestException(String message, Throwable cause) {
        super(message, cause);
    }
}
