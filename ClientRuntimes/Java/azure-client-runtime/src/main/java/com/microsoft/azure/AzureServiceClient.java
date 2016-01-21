/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.ServiceClient;
import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.squareup.okhttp.OkHttpClient;
import retrofit.Retrofit;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 */
public abstract class AzureServiceClient extends ServiceClient {
    /**
     * Initializes a new instance of the ServiceClient class.
     */
    protected AzureServiceClient() {
        this(new OkHttpClient(), new Retrofit.Builder());

        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        this.client.setCookieHandler(cookieManager);

        Executor executor = Executors.newCachedThreadPool();
        this.mapperAdapter = new AzureJacksonMapperAdapter();
        this.retrofitBuilder
                .addConverterFactory(mapperAdapter.getConverterFactory())
                .callbackExecutor(executor);
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param client the OkHttpClient instance to use
     * @param retrofitBuilder the builder to build up a rest adapter
     */
    protected AzureServiceClient(OkHttpClient client, Retrofit.Builder retrofitBuilder) {
        super(client, retrofitBuilder);
    }
}
