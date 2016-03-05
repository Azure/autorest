/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.microsoft.rest.ServiceClient;
import com.microsoft.rest.UserAgentInterceptor;
import com.microsoft.rest.retry.RetryHandler;

import java.net.CookieManager;
import java.net.CookiePolicy;

import okhttp3.JavaNetCookieJar;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public abstract class AzureServiceClient extends ServiceClient {
    /**
     * Initializes a new instance of the ServiceClient class.
     */
    protected AzureServiceClient() {
        super();
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param clientBuilder the builder to build up an OkHttp client
     * @param retrofitBuilder the builder to build up a rest adapter
     */
    protected AzureServiceClient(OkHttpClient.Builder clientBuilder, Retrofit.Builder retrofitBuilder) {
        super(clientBuilder, retrofitBuilder);
    }

    /**
     * This method initializes the builders for Http client and Retrofit with common
     * behaviors for all service clients.
     */
    @Override
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
        this.mapperAdapter = new AzureJacksonMapperAdapter();
        this.retrofitBuilder = retrofitBuilder
                .client(clientBuilder.build())
                .addConverterFactory(mapperAdapter.getConverterFactory());
    }
}
