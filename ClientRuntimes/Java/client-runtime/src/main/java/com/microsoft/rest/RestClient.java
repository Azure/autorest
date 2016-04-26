/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.credentials.ServiceClientCredentials;
import com.microsoft.rest.retry.RetryHandler;
import com.microsoft.rest.serializer.JacksonMapperAdapter;

import java.net.CookieManager;
import java.net.CookiePolicy;

import okhttp3.Interceptor;
import okhttp3.JavaNetCookieJar;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;

/**
 * An instance of this class stores the client information for making REST calls.
 */
public class RestClient {
    private OkHttpClient httpClient;
    private Retrofit retrofit;
    private ServiceClientCredentials credentials;
    private CustomHeadersInterceptor customHeadersInterceptor;
    private BaseUrlInterceptor baseUrlInterceptor;
    private JacksonMapperAdapter mapperAdapter;

    private RestClient(OkHttpClient httpClient,
                       Retrofit retrofit,
                       ServiceClientCredentials credentials,
                       CustomHeadersInterceptor customHeadersInterceptor,
                       BaseUrlInterceptor baseUrlInterceptor,
                       JacksonMapperAdapter mapperAdapter) {
        this.httpClient = httpClient;
        this.retrofit = retrofit;
        this.credentials = credentials;
        this.customHeadersInterceptor = customHeadersInterceptor;
        this.baseUrlInterceptor = baseUrlInterceptor;
        this.mapperAdapter = mapperAdapter;
    }

    public CustomHeadersInterceptor headers() {
        return customHeadersInterceptor;
    }

    public JacksonMapperAdapter mapperAdapter() {
        return mapperAdapter;
    }

    public OkHttpClient httpClient() {
        return httpClient;
    }

    public Retrofit retrofit() {
        return retrofit;
    }

    public String baseUrl() {
        return retrofit.baseUrl().url().toString();
    }

    public void baseUrl(String baseUrl) {
        baseUrlInterceptor.setBaseUrl(baseUrl);
    }

    public ServiceClientCredentials credentials() {
        return this.credentials;
    }

    public static class Builder {
        private OkHttpClient.Builder httpClientBuilder;
        private Retrofit.Builder retrofitBuilder;
        private ServiceClientCredentials credentials;
        private CustomHeadersInterceptor customHeadersInterceptor;
        private BaseUrlInterceptor baseUrlInterceptor;
        private JacksonMapperAdapter mapperAdapter;

        public Builder(String baseUrl) {
            this(baseUrl, new OkHttpClient.Builder(), new Retrofit.Builder());
        }

        public Builder(String baseUrl, OkHttpClient.Builder httpClientBuilder, Retrofit.Builder retrofitBuilder) {
            if (baseUrl == null) {
                throw new IllegalArgumentException("baseUrl == null");
            }
            if (httpClientBuilder == null) {
                throw new IllegalArgumentException("httpClientBuilder == null");
            }
            if (retrofitBuilder == null) {
                throw new IllegalArgumentException("retrofitBuilder == null");
            }
            CookieManager cookieManager = new CookieManager();
            cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
            customHeadersInterceptor = new CustomHeadersInterceptor();
            baseUrlInterceptor = new BaseUrlInterceptor();
            // Set up OkHttp client
            this.httpClientBuilder = httpClientBuilder
                    .cookieJar(new JavaNetCookieJar(cookieManager))
                    .addInterceptor(new RetryHandler())
                    .addInterceptor(new UserAgentInterceptor())
                    .addInterceptor(customHeadersInterceptor)
                    .addInterceptor(baseUrlInterceptor);
            // Set up rest adapter
            this.retrofitBuilder = retrofitBuilder.baseUrl(baseUrl);
        }

        public Builder withBaseUrl(String baseUrl) {
            this.retrofitBuilder.baseUrl(baseUrl);
            return this;
        }

        public Builder withUserAgent(String userAgent) {
            this.httpClientBuilder.addInterceptor(new UserAgentInterceptor(userAgent));
            return this;
        }

        public Builder withMapperAdapter(JacksonMapperAdapter mapperAdapter) {
            if (mapperAdapter != null) {
                this.mapperAdapter = mapperAdapter;
                this.retrofitBuilder = retrofitBuilder.addConverterFactory(mapperAdapter.getConverterFactory());
            }
            return this;
        }

        public Builder withCredentials(ServiceClientCredentials credentials) {
            this.credentials = credentials;
            if (credentials != null) {
                credentials.applyCredentialsFilter(httpClientBuilder);
            }
            return this;
        }

        public Builder withInterceptor(Interceptor interceptor) {
            this.httpClientBuilder.addInterceptor(interceptor);
            return this;
        }

        public RestClient build() {
            OkHttpClient httpClient = httpClientBuilder.build();
            return new RestClient(httpClient,
                    retrofitBuilder.client(httpClient).build(),
                    credentials,
                    customHeadersInterceptor,
                    baseUrlInterceptor,
                    mapperAdapter);
        }
    }
}
