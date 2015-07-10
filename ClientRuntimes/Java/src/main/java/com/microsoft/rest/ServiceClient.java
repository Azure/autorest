/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.pipeline.HttpRequestInterceptorBackAdapter;
import com.microsoft.rest.pipeline.HttpRequestInterceptorFrontAdapter;
import com.microsoft.rest.pipeline.HttpResponseInterceptorBackAdapter;
import com.microsoft.rest.pipeline.HttpResponseInterceptorFrontAdapter;
import com.microsoft.rest.pipeline.ServiceRequestFilter;
import com.microsoft.rest.pipeline.ServiceResponseFilter;
import org.apache.http.HttpHost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;

import java.io.Closeable;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * ServiceClient is the abstraction for accessing REST operations and their payload data types.
 *
 * @param <T> type of the ServiceClient
 */
public abstract class ServiceClient<T> implements Closeable {
    private final ExecutorService executorService;
    private CloseableHttpClient httpClient;
    private HttpRequestInterceptorFrontAdapter httpRequestInterceptorFrontAdapter;
    private HttpRequestInterceptorBackAdapter httpRequestInterceptorBackAdapter;
    private HttpResponseInterceptorFrontAdapter httpResponseInterceptorFrontAdapter;
    private HttpResponseInterceptorBackAdapter httpResponseInterceptorBackAdapter;
    private final HttpClientBuilder httpClientBuilder;

    /**
     * Initializes a new instance of the ServiceClient class.
     */
    public ServiceClient() {
        this(HttpClientBuilder.create(), Executors.newCachedThreadPool());
    }

    /**
     * Initializes a new instance of the ServiceClient class.
     *
     * @param httpClientBuilder the apache HttpClientBuilder for creating Http clients
     * @param executorService   the ExecutorService for asynchronous operations
     */
    public ServiceClient(HttpClientBuilder httpClientBuilder,
            ExecutorService executorService) {
        this.httpClientBuilder = httpClientBuilder;
        this.executorService = executorService;
    }

    /**
     * Get the ExecutorService.
     *
     * @return the ExecutorService
     */
    public ExecutorService getExecutorService() {
        return this.executorService;
    }

    /**
     * Get the HttpClientBuilder.
     *
     * @return the HttpClientBuilder
     */
    public HttpClientBuilder getHttpClientBuilder() {
        return this.httpClientBuilder;
    }

    /**
     * Get the HttpClient. A new HttpClient will be built from the HttpClientBuilder
     * if one is not built yet.
     *
     * @return the HttpClient instance
     */
    public CloseableHttpClient getHttpClient() {
        if (this.httpClient == null) {
            String proxyHost = System.getProperty("http.proxyHost");
            String proxyPort = System.getProperty("http.proxyPort");
            if ((proxyHost != null) && (proxyPort != null)) {
                HttpHost proxy = new HttpHost(proxyHost, Integer.parseInt(proxyPort));
                if (proxy != null) {
                    httpClientBuilder.setProxy(proxy);
                }
            }

            this.httpClient = httpClientBuilder.build();
        }

        return this.httpClient;
    }

    /**
     * Add a ServiceRequestFilter to the beginning of all the request filters in
     * Apache pipeline.
     *
     * @param serviceRequestFilter the filter to be added
     */
    public void addRequestFilterFirst(
            ServiceRequestFilter serviceRequestFilter) {
        if (httpRequestInterceptorFrontAdapter == null) {
            httpRequestInterceptorFrontAdapter = new HttpRequestInterceptorFrontAdapter();
            httpClientBuilder.addInterceptorFirst(httpRequestInterceptorFrontAdapter);
        }
        httpRequestInterceptorFrontAdapter.addFront(serviceRequestFilter);
    }

    /**
     * Add a ServiceRequestFilter to the end of all the request filters in
     * Apache pipeline.
     *
     * @param serviceRequestFilter the filter to be added
     */
    public void addRequestFilterLast(
            ServiceRequestFilter serviceRequestFilter) {
        if (httpRequestInterceptorBackAdapter == null) {
            httpRequestInterceptorBackAdapter = new HttpRequestInterceptorBackAdapter();
            httpClientBuilder.addInterceptorLast(httpRequestInterceptorBackAdapter);
        }
        httpRequestInterceptorBackAdapter.addBack(serviceRequestFilter);
    }

    /**
     * Add a ServiceResponseFilter to the beginning of all the response filters in
     * Apache pipeline.
     *
     * @param serviceResponseFilter the filter to be added
     */
    public void addResponseFilterFirst(
            ServiceResponseFilter serviceResponseFilter) {
        if (httpResponseInterceptorFrontAdapter == null) {
            httpResponseInterceptorFrontAdapter = new HttpResponseInterceptorFrontAdapter();
            httpClientBuilder.addInterceptorFirst(httpResponseInterceptorFrontAdapter);
        }
        httpResponseInterceptorFrontAdapter.addFront(serviceResponseFilter);
    }

    /**
     * Add a ServiceResponseFilter to the end of all the response filters in
     * Apache pipeline.
     *
     * @param serviceResponseFilter the filter to be added
     */
    public void addResponseFilterLast(
            ServiceResponseFilter serviceResponseFilter) {
        if (httpResponseInterceptorBackAdapter == null) {
            httpResponseInterceptorBackAdapter = new HttpResponseInterceptorBackAdapter();
            httpClientBuilder.addInterceptorLast(httpResponseInterceptorBackAdapter);
        }
        httpResponseInterceptorBackAdapter.addBack(serviceResponseFilter);
    }

    /* (non-Javadoc)
     * @see java.io.Closeable#close()
     */
    public void close() throws IOException {
        if (httpClient != null) {
            httpClient.close();
        }
    }
}
