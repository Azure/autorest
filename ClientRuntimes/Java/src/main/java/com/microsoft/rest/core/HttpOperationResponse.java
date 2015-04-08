/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

public class HttpOperationResponse {
    private int httpStatusCode;

    /**
     * Gets the HTTP status code for the request.
     * 
     * @return The HTTP status code.
     */
    public int getStatusCode() {
        return this.httpStatusCode;
    }

    /**
     * Sets the HTTP status code for the request.
     * 
     * @param httpStatusCode
     *            The HTTP status code.
     */
    public void setStatusCode(int httpStatusCode) {
        this.httpStatusCode = httpStatusCode;
    }

    private String requestId;

    /**
     * Gets the request identifier.
     * 
     * @return The request identifier.
     */
    public String getRequestId() {
        return this.requestId;
    }

    /**
     * Sets the request identifier.
     * 
     * @param requestId
     *            The request identifier.
     */
    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
}
