/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.retry.RetryHandler;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.OkHttpClient;
import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.CloseableHttpClient;
import org.glassfish.jersey.apache.connector.ApacheConnectorProvider;
import org.glassfish.jersey.client.ClientConfig;
import retrofit.ErrorHandler;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import retrofit.client.OkClient;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.ClientRequestFilter;
import javax.ws.rs.client.ClientResponseFilter;
import java.io.Closeable;
import java.io.IOException;
import java.util.List;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 *
 * @param <T> type of the ServiceClient
 */
public abstract class ServiceClient<T> implements Closeable {
    protected OkHttpClient client;
    protected RestAdapter.Builder restAdapterBuilder;
    /**
     * Initializes a new instance of the ServiceClient class.
     */
    public ServiceClient() {
        this(new OkHttpClient(), new RestAdapter.Builder());
    }

    public ServiceClient(OkHttpClient client, RestAdapter.Builder restAdapterBuilder) {
        this.client = client;
        this.client.interceptors().add(new RetryHandler());

        this.restAdapterBuilder = restAdapterBuilder.setClient(new OkClient(this.client));
    }

    public List<Interceptor> getClientInterceptors() {
        return this.client.interceptors();
    }

    @Override
    public void close() {
    }
}
