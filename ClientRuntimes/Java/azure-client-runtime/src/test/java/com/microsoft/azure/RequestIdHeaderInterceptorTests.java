/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.retry.RetryHandler;

import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.Response;

public class RequestIdHeaderInterceptorTests {
    private static final String REQUEST_ID_HEADER = "x-ms-client-request-id";

    @Test
    public void newRequestIdForEachCall() throws Exception {
        RestClient restClient = new RestClient.Builder()
                .withBaseUrl("http://localhost")
                .withInterceptor(new RequestIdHeaderInterceptor())
                .withInterceptor(new Interceptor() {
                    private String firstRequestId = null;
                    @Override
                    public Response intercept(Chain chain) throws IOException {
                        Request request = chain.request();
                        if (request.header(REQUEST_ID_HEADER) != null) {
                            if (firstRequestId == null) {
                                firstRequestId = request.header(REQUEST_ID_HEADER);
                                return new Response.Builder().code(200).request(request)
                                        .protocol(Protocol.HTTP_1_1).build();
                            } else if (!request.header(REQUEST_ID_HEADER).equals(firstRequestId)) {
                                return new Response.Builder().code(200).request(request)
                                        .protocol(Protocol.HTTP_1_1).build();
                            }
                        }
                        return new Response.Builder().code(400).request(request)
                                .protocol(Protocol.HTTP_1_1).build();
                    }
                })
                .build();
        AzureServiceClient serviceClient = new AzureServiceClient(restClient) { };
        Response response = serviceClient.restClient().httpClient()
                .newCall(new Request.Builder().get().url("http://localhost").build()).execute();
        Assert.assertEquals(200, response.code());
        response = serviceClient.restClient().httpClient()
                .newCall(new Request.Builder().get().url("http://localhost").build()).execute();
        Assert.assertEquals(200, response.code());
    }

    @Test
    public void sameRequestIdForRetry() throws Exception {
        RestClient restClient = new RestClient.Builder()
                .withBaseUrl("http://localhost")
                .withInterceptor(new RequestIdHeaderInterceptor())
                .withInterceptor(new RetryHandler())
                .withInterceptor(new Interceptor() {
                    private String firstRequestId = null;

                    @Override
                    public Response intercept(Chain chain) throws IOException {
                        Request request = chain.request();
                        if (request.header(REQUEST_ID_HEADER) != null) {
                            if (firstRequestId == null) {
                                firstRequestId = request.header(REQUEST_ID_HEADER);
                                return new Response.Builder().code(500).request(request)
                                        .protocol(Protocol.HTTP_1_1).build();
                            } else if (request.header(REQUEST_ID_HEADER).equals(firstRequestId)) {
                                return new Response.Builder().code(200).request(request)
                                        .protocol(Protocol.HTTP_1_1).build();
                            }
                        }
                        return new Response.Builder().code(400).request(request)
                                .protocol(Protocol.HTTP_1_1).build();
                    }
                })
                .build();
        AzureServiceClient serviceClient = new AzureServiceClient(restClient) { };
        Response response = serviceClient.restClient().httpClient()
                .newCall(new Request.Builder().get().url("http://localhost").build()).execute();
        Assert.assertEquals(200, response.code());
    }
}
