/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceResponse;
import retrofit2.Response;

/**
 * A standard service response including request ID.
 *
 * @param <T> the type of the response resource
 */
public class AzureResponse<T> extends ServiceResponse<T> {
    /**
     * Instantiate a ServiceResponse instance with a response object and a raw REST response.
     *
     * @param body     deserialized response object
     * @param response raw REST response
     */
    public AzureResponse(T body, Response response) {
        super(body, response);
    }

    /**
     * The value that uniquely identifies a request made against the service.
     */
    private String requestId;

    /**
     * Gets the value that uniquely identifies a request made against the service.
     *
     * @return the request id value.
     */
    public String getRequestId() {
        return requestId;
    }

    /**
     * Sets the value that uniquely identifies a request made against the service.
     *
     * @param requestId the request id value.
     */
    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
}
