/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Protocol;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

public class ServiceClientTests {
    @Test
    public void UserAgentTests() throws Exception {
        ServiceClient serviceClient = new ServiceClient() {};
        serviceClient.getClientInterceptors().add(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                String header = chain.request().header("User-Agent");
                if (header != null && header.equals("AutoRest-Java")) {
                    return new Response.Builder()
                            .request(chain.request())
                            .code(200)
                            .protocol(Protocol.HTTP_1_1)
                            .build();
                } else {
                    return new Response.Builder()
                            .request(chain.request())
                            .code(400)
                            .protocol(Protocol.HTTP_1_1)
                            .build();
                }
            }
        });
        Response response = serviceClient.client.newCall(new Request.Builder().get().url("localhost").build()).execute();
        Assert.assertEquals(200, response.code());
    }

    @Test
    public void FilterTests() throws Exception {
        ServiceClient serviceClient = new ServiceClient() {};
        serviceClient.getClientInterceptors().add(0, new FirstFilter());
        serviceClient.getClientInterceptors().add(1, new SecondFilter());
        serviceClient.getClientInterceptors().add(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                Assert.assertEquals("1", chain.request().header("filter1"));
                Assert.assertEquals("2", chain.request().header("filter2"));
                return chain.proceed(chain.request());
            }
        });
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
