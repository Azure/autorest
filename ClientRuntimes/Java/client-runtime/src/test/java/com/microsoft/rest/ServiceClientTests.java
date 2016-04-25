/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Response;
import retrofit2.Retrofit;

import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

public class ServiceClientTests {
    @Test
    public void filterTests() throws Exception {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder();
        Retrofit.Builder retrofitBuilder = new Retrofit.Builder();
        clientBuilder.interceptors().add(0, new FirstFilter());
        clientBuilder.interceptors().add(1, new SecondFilter());
        clientBuilder.interceptors().add(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                Assert.assertEquals("1", chain.request().header("filter1"));
                Assert.assertEquals("2", chain.request().header("filter2"));
                return chain.proceed(chain.request());
            }
        });
        ServiceClient serviceClient = new ServiceClient(clientBuilder, retrofitBuilder) { };
    }

    public class FirstFilter implements Interceptor {
        @Override
        public Response intercept(Chain chain) throws IOException {
            return chain.proceed(chain.request().newBuilder().header("filter1", "1").build());
        }
    }

    public class SecondFilter implements Interceptor {
        @Override
        public Response intercept(Chain chain) throws IOException {
            return chain.proceed(chain.request().newBuilder().header("filter2", "2").build());
        }
    }
}
