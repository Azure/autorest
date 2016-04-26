/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.microsoft.rest.RestClient;
import com.microsoft.rest.ServiceClient;
import com.microsoft.rest.UserAgentInterceptor;
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
public abstract class AzureServiceClient extends ServiceClient {
    protected AzureServiceClient(String baseUrl) {
        this(new RestClient.Builder(baseUrl)
                .withMapperAdapter(new AzureJacksonMapperAdapter()).build());
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param restClient the REST client
     */
    protected AzureServiceClient(RestClient restClient) {
        super(restClient);
    }
}
