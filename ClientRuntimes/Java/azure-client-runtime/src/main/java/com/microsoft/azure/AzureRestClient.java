/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.microsoft.rest.BaseUrlHandler;
import com.microsoft.rest.CustomHeadersInterceptor;
import com.microsoft.rest.RestClient;
import com.microsoft.rest.UserAgentInterceptor;
import com.microsoft.rest.credentials.ServiceClientCredentials;
import com.microsoft.rest.retry.RetryHandler;
import com.microsoft.rest.serializer.JacksonMapperAdapter;

import okhttp3.OkHttpClient;
import retrofit2.Retrofit;

/**
 * An instance of this class stores the client information for making REST calls to Azure.
 */
public final class AzureRestClient extends RestClient {
    private AzureRestClient(OkHttpClient httpClient,
                            Retrofit retrofit,
                            ServiceClientCredentials credentials,
                            CustomHeadersInterceptor customHeadersInterceptor,
                            UserAgentInterceptor userAgentInterceptor,
                            BaseUrlHandler baseUrlHandler,
                            JacksonMapperAdapter mapperAdapter) {
        super(httpClient, retrofit, credentials, customHeadersInterceptor,
                userAgentInterceptor, baseUrlHandler, mapperAdapter);
    }

    /**
     * The builder class for building a REST client.
     */
    public static class Builder extends RestClient.Builder {
        /**
         * Creates an instance of the builder with a base URL to the service.
         */
        public Builder() {
            super();
        }

        /**
         * Creates an instance of the builder with a base URL and 2 custom builders.
         *
         * @param httpClientBuilder the builder to build an {@link OkHttpClient}.
         * @param retrofitBuilder the builder to build a {@link Retrofit}.
         */
        public Builder(OkHttpClient.Builder httpClientBuilder, Retrofit.Builder retrofitBuilder) {
            super(httpClientBuilder, retrofitBuilder);
            buildable = new Buildable();
        }

        /**
         * Sets the base URL with the default from the Azure Environment.
         *
         * @param environment the environment the application is running in
         * @return the builder itself for chaining
         */
        public RestClient.Builder.Buildable withDefaultBaseUrl(AzureEnvironment environment) {
            withBaseUrl(environment.getBaseUrl());
            return buildable;
        }

        public class Buildable extends RestClient.Builder.Buildable {
            /**
             * Build an AzureRestClient with all the current configurations.
             *
             * @return an {@link AzureRestClient}.
             */
            @Override
            public AzureRestClient build() {
                AzureJacksonMapperAdapter mapperAdapter = new AzureJacksonMapperAdapter();
                OkHttpClient httpClient = httpClientBuilder
                        .addInterceptor(baseUrlHandler)
                        .addInterceptor(customHeadersInterceptor)
                        .addInterceptor(new RetryHandler())
                        .build();
                return new AzureRestClient(httpClient,
                        retrofitBuilder
                                .baseUrl(baseUrl)
                                .client(httpClient)
                                .addConverterFactory(mapperAdapter.getConverterFactory())
                                .build(),
                        credentials,
                        customHeadersInterceptor,
                        userAgentInterceptor,
                        baseUrlHandler,
                        mapperAdapter);
            }
        }
    }
}
