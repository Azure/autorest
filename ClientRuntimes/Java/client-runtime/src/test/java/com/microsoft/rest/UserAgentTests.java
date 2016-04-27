/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Protocol;
import okhttp3.Response;
import retrofit2.Retrofit;

import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

public class UserAgentTests {
    @Test
    public void defaultUserAgentTests() throws Exception {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder();
        Retrofit.Builder retrofitBuilder = new Retrofit.Builder();
        clientBuilder.addInterceptor(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                String header = chain.request().header("User-Agent");
                Assert.assertEquals("AutoRest-Java", header);
                return new Response.Builder()
                        .request(chain.request())
                        .code(200)
                        .protocol(Protocol.HTTP_1_1)
                        .build();
            }
        });
        RestClient.Builder restBuilder = new RestClient.Builder("http://localhost", clientBuilder, retrofitBuilder);
        ServiceClient serviceClient = new ServiceClient(restBuilder.build()) { };
    }

    @Test
    public void customUserAgentTests() throws Exception {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder();
        Retrofit.Builder retrofitBuilder = new Retrofit.Builder();
        clientBuilder.addInterceptor(new UserAgentInterceptor("Awesome"));
        clientBuilder.addInterceptor(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                String header = chain.request().header("User-Agent");
                Assert.assertEquals("Awesome", header);
                return new Response.Builder()
                        .request(chain.request())
                        .code(200)
                        .protocol(Protocol.HTTP_1_1)
                        .build();
            }
        });
        RestClient.Builder restBuilder = new RestClient.Builder("http://localhost", clientBuilder, retrofitBuilder);
        ServiceClient serviceClient = new ServiceClient(restBuilder.build()) { };
    }
}
