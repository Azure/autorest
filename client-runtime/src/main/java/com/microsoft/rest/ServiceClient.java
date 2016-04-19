/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.retry.RetryHandler;
import com.microsoft.rest.serializer.JacksonMapperAdapter;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.List;

import okhttp3.Interceptor;
import okhttp3.JavaNetCookieJar;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import okhttp3.logging.HttpLoggingInterceptor.Level;
import retrofit2.Retrofit;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public abstract class ServiceClient {
    /**
     * The builder for building the OkHttp client.
     */
    protected OkHttpClient.Builder clientBuilder;

    /**
     * The builder for building Retrofit services.
     */
    protected Retrofit.Builder retrofitBuilder;

    /**
     * The adapter for {@link com.fasterxml.jackson.databind.ObjectMapper} for serialization
     * and deserialization operations.
     */
    protected JacksonMapperAdapter mapperAdapter;

    /**
     * Initializes a new instance of the ServiceClient class.
     */
    protected ServiceClient() {
        this(new OkHttpClient.Builder(), new Retrofit.Builder());
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param clientBuilder the builder to build up an OkHttp client
     * @param retrofitBuilder the builder to build up a rest adapter
     */
    protected ServiceClient(OkHttpClient.Builder clientBuilder, Retrofit.Builder retrofitBuilder) {
        if (clientBuilder == null) {
            throw new IllegalArgumentException("clientBuilder == null");
        }
        if (retrofitBuilder == null) {
            throw new IllegalArgumentException("retrofitBuilder == null");
        }

        this.clientBuilder = clientBuilder;
        this.retrofitBuilder = retrofitBuilder;
    }

    /**
     * Get the list of interceptors the OkHttp client will execute.
     * @return the list of interceptors
     */
    public List<Interceptor> getClientInterceptors() {
        return this.clientBuilder.interceptors();
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

    /**
     * Gets the adapter for {@link com.fasterxml.jackson.databind.ObjectMapper} for serialization
     * and deserialization operations..
     *
     * @return the adapter.
     */
    public JacksonMapperAdapter getMapperAdapter() {
        return this.mapperAdapter;
    }

    /**
     * This method initializes the builders for Http client and Retrofit with common
     * behaviors for all service clients.
     */
    protected void initialize() {
        // Add retry handler
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);

        // Set up OkHttp client
        this.clientBuilder = clientBuilder
                .cookieJar(new JavaNetCookieJar(cookieManager))
                .addInterceptor(new RetryHandler())
                .addInterceptor(new UserAgentInterceptor());
        // Set up rest adapter
        this.mapperAdapter = new JacksonMapperAdapter();
        this.retrofitBuilder = retrofitBuilder
                .addConverterFactory(mapperAdapter.getConverterFactory());
    }
}
