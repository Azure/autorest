/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import org.glassfish.jersey.client.ClientConfig;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.ClientRequestFilter;
import javax.ws.rs.client.ClientResponseFilter;
import java.io.Closeable;
import java.io.IOException;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 *
 * @param <T> type of the ServiceClient
 */
public abstract class ServiceClient<T> implements Closeable {
    private Client client;

    /**
     * Initializes a new instance of the ServiceClient class.
     */
    public ServiceClient() {
        this(new ClientConfig());
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param clientConfig the Jersey client configuration for building the client
     */
    public ServiceClient(ClientConfig clientConfig) {
        client = ClientBuilder.newClient(clientConfig);
    }

    /**
     * Get the client instance.
     * @return the client instance.
     */
    public Client getClient() {
        return client;
    }

    /**
     * Add a ServiceRequestFilter to the Jersey client
     *
     * @param clientRequestFilter the filter to be added
     */
    public ServiceClient addRequestFilter(ClientRequestFilter clientRequestFilter) {
        client.register(clientRequestFilter);
        return this;
    }

    /**
     * Add a ServiceResponseFilter to the Jersey client
     *
     * @param clientResponseFilter the filter to be added
     */
    public ServiceClient addResponseFilter(ClientResponseFilter clientResponseFilter) {
        client.register(clientResponseFilter);
        return this;
    }

    /* (non-Javadoc)
     * @see java.io.Closeable#close()
     */
    public void close() throws IOException {
        if (client != null) {
            client.close();
        }
    }
}
