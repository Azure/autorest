/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.retry.RetryHandler;
import com.microsoft.rest.serializer.JacksonUtils;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.logging.HttpLoggingInterceptor;
import com.squareup.okhttp.logging.HttpLoggingInterceptor.Level;
import retrofit.Retrofit;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public abstract class ServiceClient {
    protected final OkHttpClient client;
    protected final Retrofit.Builder retrofitBuilder;

    /**
     * Initializes a new instance of the ServiceClient class.
     */
    protected ServiceClient() {
        this(new OkHttpClient(), new Retrofit.Builder());

        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        this.client.setCookieHandler(cookieManager);

        Executor executor = Executors.newCachedThreadPool();
        this.retrofitBuilder
                .addConverterFactory(new JacksonUtils().getConverterFactory())
                .callbackExecutor(executor);
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param client the OkHttpClient instance to use
     * @param retrofitBuilder the builder to build up a rest adapter
     */
    protected ServiceClient(OkHttpClient client, Retrofit.Builder retrofitBuilder) {
        if (client == null) {
            throw new IllegalArgumentException("client == null");
        }
        if (retrofitBuilder == null) {
            throw new IllegalArgumentException("retrofitBuilder == null");
        }

        // Set up OkHttp client
        this.client = client;
        this.client.interceptors().add(new RetryHandler());
        this.client.interceptors().add(new UserAgentInterceptor());

        // Set up rest adapter builder
        this.retrofitBuilder = retrofitBuilder.client(this.client);
    }

    /**
     * Get the list of interceptors the OkHttp client will execute.
     * @return the list of interceptors
     */
    public List<Interceptor> getClientInterceptors() {
        return this.client.interceptors();
    }

    /**
     * Sets the logging level for OkHttp client.
     *
     * @param logLevel the logging level enum
     */
    public void setLogLevel(Level logLevel) {
        HttpLoggingInterceptor loggingInterceptor = new HttpLoggingInterceptor();
        loggingInterceptor.setLevel(logLevel);
        this.getClientInterceptors().add(loggingInterceptor);
    }
}
