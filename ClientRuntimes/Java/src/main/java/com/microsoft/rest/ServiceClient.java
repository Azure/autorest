/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.retry.RetryHandler;
import com.microsoft.rest.serializer.JacksonHelper;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.OkHttpClient;
import retrofit.RestAdapter;
import retrofit.client.OkClient;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public abstract class ServiceClient {
    protected OkHttpClient client;
    protected RestAdapter.Builder restAdapterBuilder;
    /**
     * Initializes a new instance of the ServiceClient class.
     */
    protected ServiceClient() {
        this(new OkHttpClient(), new RestAdapter.Builder());
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param client the OkHttpClient instance to use
     * @param restAdapterBuilder the builder to build up a rest adapter
     */
    protected ServiceClient(OkHttpClient client, RestAdapter.Builder restAdapterBuilder) {
        if (client == null) {
            throw new IllegalArgumentException("client == null");
        }
        if (restAdapterBuilder == null) {
            throw new IllegalArgumentException("restAdapterBuilder == null");
        }

        // Set up OkHttp client
        this.client = client;
        this.client.interceptors().add(new RetryHandler());
        this.client.interceptors().add(new UserAgentInterceptor());
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        this.client.setCookieHandler(cookieManager);
        OkClient okClient = new OkClient(client);

        // Set up rest adapter builder
        Executor executor = Executors.newCachedThreadPool();
        this.restAdapterBuilder = restAdapterBuilder
                .setClient(okClient)
                .setLogLevel(RestAdapter.LogLevel.BASIC)
                .setConverter(JacksonHelper.getConverter())
                .setExecutors(executor, executor);
    }

    /**
     * Get the list of interceptors the OkHttp client will execute.
     * @return the list of interceptors
     */
    public List<Interceptor> getClientInterceptors() {
        return this.client.interceptors();
    }
}
