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

import okhttp3.JavaNetCookieJar;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public abstract class ServiceClient {
    protected OkHttpClient httpClient;

    protected Retrofit retrofit;

    protected JacksonMapperAdapter mapperAdapter;

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param baseUrl the service endpoint
     */
    protected ServiceClient(String baseUrl) {
        this(baseUrl, new OkHttpClient.Builder(), new Retrofit.Builder());
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     */
    protected ServiceClient(String baseUrl, OkHttpClient.Builder clientBuilder, Retrofit.Builder restBuilder) {
        if (clientBuilder == null) {
            throw new IllegalArgumentException("clientBuilder == null");
        }
        if (restBuilder == null) {
            throw new IllegalArgumentException("restBuilder == null");
        }
        this.mapperAdapter = new JacksonMapperAdapter();
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        this.httpClient = clientBuilder
                .cookieJar(new JavaNetCookieJar(cookieManager))
                .addInterceptor(new UserAgentInterceptor())
                .addInterceptor(new BaseUrlHandler())
                .addInterceptor(new CustomHeadersInterceptor())
                .addInterceptor(new RetryHandler())
                .build();
        this.retrofit = restBuilder
                .baseUrl(baseUrl)
                .client(httpClient)
                .addConverterFactory(mapperAdapter.getConverterFactory())
                .build();
    }

    public Retrofit retrofit() {
        return this.retrofit;
    }

    public OkHttpClient httpClient() {
        return this.httpClient;
    }

    public JacksonMapperAdapter mapperAdapter() {
        return this.mapperAdapter;
    }
}
