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
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;

/**
 * An instance of this class stores the client information for making REST calls.
 */
public class RestClient {
    /** The {@link okhttp3.OkHttpClient} object. */
    private OkHttpClient httpClient;
    /** The {@link retrofit2.Retrofit} object. */
    private Retrofit retrofit;
    /** The credentials to authenticate. */
    private ServiceClientCredentials credentials;
    /** The interceptor to handle custom headers. */
    private CustomHeadersInterceptor customHeadersInterceptor;
    /** The interceptor to handle base URL. */
    private BaseUrlHandler baseUrlHandler;
    /** The adapter to a Jackson {@link com.fasterxml.jackson.databind.ObjectMapper}. */
    private JacksonMapperAdapter mapperAdapter;

    private RestClient(OkHttpClient httpClient,
                       Retrofit retrofit,
                       ServiceClientCredentials credentials,
                       CustomHeadersInterceptor customHeadersInterceptor,
                       BaseUrlHandler baseUrlHandler,
                       JacksonMapperAdapter mapperAdapter) {
        this.httpClient = httpClient;
        this.retrofit = retrofit;
        this.credentials = credentials;
        this.customHeadersInterceptor = customHeadersInterceptor;
        this.baseUrlHandler = baseUrlHandler;
        this.mapperAdapter = mapperAdapter;
    }

    /**
     * Get the headers interceptor.
     *
     * @return the headers interceptor.
     */
    public CustomHeadersInterceptor headers() {
        return customHeadersInterceptor;
    }

    /**
     * Get the adapter to {@link com.fasterxml.jackson.databind.ObjectMapper}.
     *
     * @return the Jackson mapper adapter.
     */
    public JacksonMapperAdapter mapperAdapter() {
        return mapperAdapter;
    }

    /**
     * Get the http client.
     *
     * @return the {@link OkHttpClient} object.
     */
    public OkHttpClient httpClient() {
        return httpClient;
    }

    /**
     * Get the retrofit instance.
     *
     * @return the {@link Retrofit} object.
     */
    public Retrofit retrofit() {
        return retrofit;
    }

    /**
     * Get the base URL currently set. If it's a customizable URL, the updated
     * URL instead of the raw one might be returned.
     *
     * @return the base URL.
     * @see {@link RestClient#setBaseUrl(String...)}
     */
    public String baseUrl() {
        return baseUrlHandler.baseUrl();
    }

    /**
     * Handles dynamic replacements on base URL. The arguments must be in pairs
     * with the string in raw URL to replace as replacements[i] and the dynamic
     * part as replacements[i+1]. E.g. {subdomain}.microsoft.com can be set
     * dynamically by calling setBaseUrl("{subdomain}", "azure").
     *
     * @param replacements the string replacements in pairs.
     */
    public void setBaseUrl(String... replacements) {
        baseUrlHandler.setBaseUrl(replacements);
    }

    /**
     * Get the credentials attached to this REST client.
     *
     * @return the credentials.
     */
    public ServiceClientCredentials credentials() {
        return this.credentials;
    }

    /**
     * The builder class for building a REST client.
     */
    public static class Builder {
        /** The builder to build an {@link OkHttpClient}. */
        private OkHttpClient.Builder httpClientBuilder;
        /** The builder to build a {@link Retrofit}. */
        private Retrofit.Builder retrofitBuilder;
        /** The credentials to authenticate. */
        private ServiceClientCredentials credentials;
        /** The interceptor to handle custom headers. */
        private CustomHeadersInterceptor customHeadersInterceptor;
        /** The interceptor to handle base URL. */
        private BaseUrlHandler baseUrlHandler;
        /** The adapter to a Jackson {@link com.fasterxml.jackson.databind.ObjectMapper}. */
        private JacksonMapperAdapter mapperAdapter;

        /**
         * Creates an instance of the builder with a base URL to the service.
         *
         * @param baseUrl the dynamic base URL with varialbes wrapped in "{" and "}".
         */
        public Builder(String baseUrl) {
            this(baseUrl, new OkHttpClient.Builder(), new Retrofit.Builder());
        }

        /**
         * Creates an instance of the builder with a base URL and 2 custom builders.
         *
         * @param baseUrl the dynamic base URL with varialbes wrapped in "{" and "}".
         * @param httpClientBuilder the builder to build an {@link OkHttpClient}.
         * @param retrofitBuilder the builder to build a {@link Retrofit}.
         */
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
            baseUrlHandler = new BaseUrlHandler(baseUrl);
            // Set up OkHttp client
            this.httpClientBuilder = httpClientBuilder
                    .cookieJar(new JavaNetCookieJar(cookieManager))
                    .addInterceptor(new RetryHandler())
                    .addInterceptor(new UserAgentInterceptor());
            // Set up rest adapter
            this.retrofitBuilder = retrofitBuilder.baseUrl(baseUrl);
        }

        /**
         * Sets the base URL.
         *
         * @param baseUrl the dynamic base URL.
         * @return the builder itself for chaining.
         */
        public Builder withBaseUrl(String baseUrl) {
            this.retrofitBuilder.baseUrl(baseUrl);
            this.baseUrlHandler = new BaseUrlHandler(baseUrl);
            return this;
        }

        /**
         * Sets the user agent header.
         *
         * @param userAgent the user agent header.
         * @return the builder itself for chaining.
         */
        public Builder withUserAgent(String userAgent) {
            this.httpClientBuilder.addInterceptor(new UserAgentInterceptor(userAgent));
            return this;
        }

        /**
         * Sets the mapper adapter.
         *
         * @param mapperAdapter an adapter to a Jackson mapper.
         * @return the builder itself for chaining.
         */
        public Builder withMapperAdapter(JacksonMapperAdapter mapperAdapter) {
            if (mapperAdapter != null) {
                this.mapperAdapter = mapperAdapter;
                this.retrofitBuilder = retrofitBuilder.addConverterFactory(mapperAdapter.getConverterFactory());
            }
            return this;
        }

        /**
         * Sets the credentials.
         *
         * @param credentials the credentials object.
         * @return the builder itself for chaining.
         */
        public Builder withCredentials(ServiceClientCredentials credentials) {
            this.credentials = credentials;
            if (credentials != null) {
                credentials.applyCredentialsFilter(httpClientBuilder);
            }
            return this;
        }

        /**
         * Sets the log level.
         *
         * @param logLevel the {@link okhttp3.logging.HttpLoggingInterceptor.Level} enum.
         * @return the builder itself for chaining.
         */
        public Builder withLogLevel(HttpLoggingInterceptor.Level logLevel) {
            this.httpClientBuilder.addInterceptor(new HttpLoggingInterceptor().setLevel(logLevel));
            return this;
        }

        /**
         * Add an interceptor the Http client pipeline.
         *
         * @param interceptor the interceptor to add.
         * @return the builder itself for chaining.
         */
        public Builder withInterceptor(Interceptor interceptor) {
            this.httpClientBuilder.addInterceptor(interceptor);
            return this;
        }

        /**
         * Build a RestClient with all the current configurations.
         *
         * @return a {@link RestClient}.
         */
        public RestClient build() {
            OkHttpClient httpClient = httpClientBuilder
                    .addInterceptor(baseUrlHandler)
                    .addInterceptor(customHeadersInterceptor)
                    .build();
            return new RestClient(httpClient,
                    retrofitBuilder.client(httpClient).build(),
                    credentials,
                    customHeadersInterceptor,
                    baseUrlHandler,
                    mapperAdapter);
        }
    }
}
