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
import com.microsoft.rest.UserAgentInterceptor;
import com.microsoft.rest.credentials.ServiceClientCredentials;
import com.microsoft.rest.retry.RetryHandler;
import com.microsoft.rest.serializer.JacksonMapperAdapter;
import okhttp3.ConnectionPool;
import okhttp3.Interceptor;
import okhttp3.JavaNetCookieJar;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;

import java.lang.reflect.Field;
import java.net.CookieManager;
import java.net.CookiePolicy;
import java.net.Proxy;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;

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
    /** The interceptor to set 'User-Agent' header. */
    private UserAgentInterceptor userAgentInterceptor;

    protected RestClient(OkHttpClient httpClient,
                       Retrofit retrofit,
                       ServiceClientCredentials credentials,
                       CustomHeadersInterceptor customHeadersInterceptor,
                       UserAgentInterceptor userAgentInterceptor,
                       BaseUrlHandler baseUrlHandler,
                       JacksonMapperAdapter mapperAdapter) {
        this.httpClient = httpClient;
        this.retrofit = retrofit;
        this.credentials = credentials;
        this.customHeadersInterceptor = customHeadersInterceptor;
        this.userAgentInterceptor = userAgentInterceptor;
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
     * Sets the mapper adapter.
     *
     * @param mapperAdapter an adapter to a Jackson mapper.
     * @return the builder itself for chaining.
     */
    public RestClient withMapperAdapater(JacksonMapperAdapter mapperAdapter) {
        this.mapperAdapter = mapperAdapter;
        return this;
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
        /** The dynamic base URL with variables wrapped in "{" and "}". */
        protected String baseUrl;
        /** The builder to build an {@link OkHttpClient}. */
        protected OkHttpClient.Builder httpClientBuilder;
        /** The builder to build a {@link Retrofit}. */
        protected Retrofit.Builder retrofitBuilder;
        /** The credentials to authenticate. */
        protected ServiceClientCredentials credentials;
        /** The interceptor to handle custom headers. */
        protected CustomHeadersInterceptor customHeadersInterceptor;
        /** The interceptor to handle base URL. */
        protected BaseUrlHandler baseUrlHandler;
        /** The interceptor to set 'User-Agent' header. */
        protected UserAgentInterceptor userAgentInterceptor;
        /** The inner Builder instance. */
        protected Buildable buildable;

        /**
         * Creates an instance of the builder with a base URL to the service.
         */
        public Builder() {
            this(new OkHttpClient.Builder(), new Retrofit.Builder());
        }

        /**
         * Creates an instance of the builder with a base URL and 2 custom builders.
         *
         * @param httpClientBuilder the builder to build an {@link OkHttpClient}.
         * @param retrofitBuilder the builder to build a {@link Retrofit}.
         */
        public Builder(OkHttpClient.Builder httpClientBuilder, Retrofit.Builder retrofitBuilder) {
            if (httpClientBuilder == null) {
                throw new IllegalArgumentException("httpClientBuilder == null");
            }
            if (retrofitBuilder == null) {
                throw new IllegalArgumentException("retrofitBuilder == null");
            }
            CookieManager cookieManager = new CookieManager();
            cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
            customHeadersInterceptor = new CustomHeadersInterceptor();
            baseUrlHandler = new BaseUrlHandler();
            userAgentInterceptor = new UserAgentInterceptor();
            // Set up OkHttp client
            this.httpClientBuilder = httpClientBuilder
                    .cookieJar(new JavaNetCookieJar(cookieManager))
                    .addInterceptor(userAgentInterceptor);
            this.retrofitBuilder = retrofitBuilder;
            this.buildable = new Buildable();
        }

        /**
         * Sets the dynamic base URL.
         *
         * @param baseUrl the base URL to use.
         * @return the builder itself for chaining.
         */
        public Buildable withBaseUrl(String baseUrl) {
            this.baseUrl = baseUrl;
            return buildable;
        }

        /**
         * Sets the base URL with the default from the service client.
         *
         * @param serviceClientClass the service client class containing a default base URL.
         * @return the builder itself for chaining.
         */
        public Buildable withDefaultBaseUrl(Class<?> serviceClientClass) {
            try {
                Field field = serviceClientClass.getDeclaredField("DEFAULT_BASE_URL");
                field.setAccessible(true);
                baseUrl = (String) field.get(null);
            } catch (NoSuchFieldException | IllegalAccessException e) {
                throw new UnsupportedOperationException("Cannot read static field DEFAULT_BASE_URL", e);
            }
            return buildable;
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

        /**
         * The inner class from which a Rest Client can be built.
         */
        public class Buildable {
            /**
             * Sets the user agent header.
             *
             * @param userAgent the user agent header.
             * @return the builder itself for chaining.
             */
            public Buildable withUserAgent(String userAgent) {
                userAgentInterceptor.withUserAgent(userAgent);
                return this;
            }

            /**
             * Sets the credentials.
             *
             * @param credentials the credentials object.
             * @return the builder itself for chaining.
             */
            public Buildable withCredentials(ServiceClientCredentials credentials) {
                Builder.this.credentials = credentials;
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
            public Buildable withLogLevel(HttpLoggingInterceptor.Level logLevel) {
                httpClientBuilder.addInterceptor(new HttpLoggingInterceptor().setLevel(logLevel));
                return this;
            }

            /**
             * Add an interceptor the Http client pipeline.
             *
             * @param interceptor the interceptor to add.
             * @return the builder itself for chaining.
             */
            public Buildable withInterceptor(Interceptor interceptor) {
                httpClientBuilder.addInterceptor(interceptor);
                return this;
            }

            /**
             * Set the read timeout on the HTTP client. Default is 10 seconds.
             *
             * @param timeout the timeout numeric value
             * @param unit the time unit for the numeric value
             * @return the builder itself for chaining
             */
            public Buildable withReadTimeout(long timeout, TimeUnit unit) {
                httpClientBuilder.readTimeout(timeout, unit);
                return this;
            }

            /**
             * Set the connection timeout on the HTTP client. Default is 10 seconds.
             *
             * @param timeout the timeout numeric value
             * @param unit the time unit for the numeric value
             * @return the builder itself for chaining
             */
            public Buildable withConnectionTimeout(long timeout, TimeUnit unit) {
                httpClientBuilder.connectTimeout(timeout, unit);
                return this;
            }

            /**
             * Set the maximum idle connections for the HTTP client. Default is 5.
             *
             * @param maxIdleConnections the maximum idle connections
             * @return the builder itself for chaining
             */
            public Buildable withMaxIdleConnections(int maxIdleConnections) {
                httpClientBuilder.connectionPool(new ConnectionPool(maxIdleConnections, 5, TimeUnit.MINUTES));
                return this;
            }

            /**
             * Sets the executor for async callbacks to run on.
             *
             * @param executor the executor to execute the callbacks.
             * @return the builder itself for chaining
             */
            public Buildable withCallbackExecutor(Executor executor) {
                retrofitBuilder.callbackExecutor(executor);
                return this;
            }

            /**
             * Sets the proxy for the HTTP client.
             *
             * @param proxy the proxy to use
             * @return the builder itself for chaining
             */
            public Buildable withProxy(Proxy proxy) {
                httpClientBuilder.proxy(proxy);
                return this;
            }

            /**
             * Build a RestClient with all the current configurations.
             *
             * @return a {@link RestClient}.
             */
            public RestClient build() {
                AzureJacksonMapperAdapter mapperAdapter = new AzureJacksonMapperAdapter();
                OkHttpClient httpClient = httpClientBuilder
                        .addInterceptor(baseUrlHandler)
                        .addInterceptor(customHeadersInterceptor)
                        .addInterceptor(new RetryHandler(new ResourceGetExponentialBackoffRetryStrategy()))
                        .addInterceptor(new RetryHandler())
                        .build();
                return new RestClient(httpClient,
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
