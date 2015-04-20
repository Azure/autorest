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

public abstract class ServiceClient<TClient> implements Closeable {
    private final ExecutorService executorService;
    private CloseableHttpClient httpClient;
    private HttpRequestInterceptorFrontAdapter httpRequestInterceptorFrontAdapter;
    private HttpRequestInterceptorBackAdapter httpRequestInterceptorBackAdapter;
    private HttpResponseInterceptorFrontAdapter httpResponseInterceptorFrontAdapter;
    private HttpResponseInterceptorBackAdapter httpResponseInterceptorBackAdapter;
    private final HttpClientBuilder httpClientBuilder;

    public ServiceClient() {
        this(HttpClientBuilder.create(), Executors.newCachedThreadPool());
    }

    public ServiceClient(HttpClientBuilder httpClientBuilder,
            ExecutorService executorService) {
        this.httpClientBuilder = httpClientBuilder;
        this.executorService = executorService;
        this.withRequestFilterFirst(new UserAgentFilter(this.getClass().getName()));

    }

    public ExecutorService getExecutorService() {
        return this.executorService;
    }

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

    public ServiceClient<TClient> withRequestFilterFirst(
            ServiceRequestFilter serviceRequestFilter) {
        if (httpRequestInterceptorFrontAdapter == null) {
            httpRequestInterceptorFrontAdapter = new HttpRequestInterceptorFrontAdapter();
            httpClientBuilder.addInterceptorFirst(httpRequestInterceptorFrontAdapter);
        }
        httpRequestInterceptorFrontAdapter.addFront(serviceRequestFilter);
        return this;
    }

    public ServiceClient<TClient> withRequestFilterLast(
            ServiceRequestFilter serviceRequestFilter) {
        if (httpRequestInterceptorBackAdapter == null) {
            httpRequestInterceptorBackAdapter = new HttpRequestInterceptorBackAdapter();
            httpClientBuilder.addInterceptorLast(httpRequestInterceptorBackAdapter);
        }
        httpRequestInterceptorBackAdapter.addBack(serviceRequestFilter);
        return this;
    }

    public ServiceClient<TClient> withResponseFilterFirst(
            ServiceResponseFilter serviceResponseFilter) {
        if (httpResponseInterceptorFrontAdapter == null) {
            httpResponseInterceptorFrontAdapter = new HttpResponseInterceptorFrontAdapter();
            httpClientBuilder.addInterceptorFirst(httpResponseInterceptorFrontAdapter);
        }
        httpResponseInterceptorFrontAdapter.addFront(serviceResponseFilter);
        return this;
    }

    public ServiceClient<TClient> withResponseFilterLast(
            ServiceResponseFilter serviceResponseFilter) {
        if (httpResponseInterceptorBackAdapter == null) {
            httpResponseInterceptorBackAdapter = new HttpResponseInterceptorBackAdapter();
            httpClientBuilder.addInterceptorLast(httpResponseInterceptorBackAdapter);
        }
        httpResponseInterceptorBackAdapter.addBack(serviceResponseFilter);
        return this;
    }

    public void close() throws IOException {
        if (httpClient != null) {
            httpClient.close();
        }
    }
}
