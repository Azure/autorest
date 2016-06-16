/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.retry.RetryHandler;

import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.Response;
import retrofit2.Retrofit;

public class RetryHandlerTests {
    @Test
    public void exponentialRetryEndOn501() throws Exception {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder();
        Retrofit.Builder retrofitBuilder = new Retrofit.Builder();
        clientBuilder.addInterceptor(new RetryHandler());
        clientBuilder.addInterceptor(new Interceptor() {
            // Send 408, 500, 502, all retried, with a 501 ending
            private int[] codes = new int[]{408, 500, 502, 501};
            private int count = 0;

            @Override
            public Response intercept(Chain chain) throws IOException {
                return new Response.Builder()
                        .request(chain.request())
                        .code(codes[count++])
                        .protocol(Protocol.HTTP_1_1)
                        .build();
            }
        });
        ServiceClient serviceClient = new ServiceClient("http://localhost", clientBuilder, retrofitBuilder) { };
        Response response = serviceClient.httpClient().newCall(
                new Request.Builder().url("http://localhost").get().build()).execute();
        Assert.assertEquals(501, response.code());
    }

    @Test
    public void exponentialRetryMax() throws Exception {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder();
        Retrofit.Builder retrofitBuilder = new Retrofit.Builder();
        clientBuilder.addInterceptor(new RetryHandler());
        clientBuilder.addInterceptor(new Interceptor() {
            // Send 500 until max retry is hit
            private int count = 0;

            @Override
            public Response intercept(Chain chain) throws IOException {
                Assert.assertTrue(count++ < 5);
                return new Response.Builder()
                        .request(chain.request())
                        .code(500)
                        .protocol(Protocol.HTTP_1_1)
                        .build();
            }
        });
        ServiceClient serviceClient = new ServiceClient("http://localhost", clientBuilder, retrofitBuilder) { };
        Response response = serviceClient.httpClient().newCall(
                new Request.Builder().url("http://localhost").get().build()).execute();
        Assert.assertEquals(500, response.code());
    }
}
