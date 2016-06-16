/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public abstract class ServiceClient {
    /**
     * The builder for building the OkHttp client.
     */
    private RestClient restClient;

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param baseUrl the service endpoint
     */
    protected ServiceClient(String baseUrl) {
        this(new RestClient.Builder().withBaseUrl(baseUrl).build());
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param restClient the builder to build up an REST client
     */
    protected ServiceClient(RestClient restClient) {
        if (restClient == null) {
            throw new IllegalArgumentException("restClient == null");
        }
        this.restClient = restClient;
    }

    /**
     * Get the list of interceptors the OkHttp client will execute.
     * @return the list of interceptors
     */
    public RestClient restClient() {
        return this.restClient;
    }
}
