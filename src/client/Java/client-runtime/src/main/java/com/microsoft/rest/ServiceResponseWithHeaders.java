/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import okhttp3.ResponseBody;
import retrofit2.Response;

/**
 * An instance of this class holds a response object and a raw REST response.
 *
 * @param <TBody> the type of the response
 * @param <THeader> the type of the response header object
 */
public class ServiceResponseWithHeaders<TBody, THeader> extends ServiceResponse<TBody> {
    /**
     * The response header headers.
     */
    private THeader headers;

    /**
     * Instantiate a ServiceResponse instance with a response object and a raw REST response.
     *
     * @param body deserialized response object
     * @param headers deserialized response header object
     * @param response raw REST response
     */
    public ServiceResponseWithHeaders(TBody body, THeader headers, Response<ResponseBody> response) {
        super(body, response);
        this.headers = headers;
    }

    /**
     * Instantiate a ServiceResponse instance with a response object and a raw REST response.
     *
     * @param headers deserialized response header object
     * @param response raw REST response
     */
    public ServiceResponseWithHeaders(THeader headers, Response<Void> response) {
        super(response);
        this.headers = headers;
    }

    /**
     * Gets the response headers.
     * @return the response headers. Null if there isn't one.
     */
    public THeader getHeaders() {
        return this.headers;
    }
}
