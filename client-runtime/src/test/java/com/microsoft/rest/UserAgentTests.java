/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.serializer.JacksonMapperAdapter;
import okhttp3.Interceptor;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.Response;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

public class UserAgentTests {
    @Test
    public void defaultUserAgentTests() throws Exception {
        RestClient.Builder restBuilder = new RestClient.Builder("http://localhost")
                .withInterceptor(new Interceptor() {
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
                })
                .withMapperAdapter(new JacksonMapperAdapter());
        ServiceClient serviceClient = new ServiceClient(restBuilder.build()) { };
        Response response = serviceClient.restClient().httpClient()
                .newCall(new Request.Builder().get().url("http://localhost").build()).execute();
        Assert.assertEquals(200, response.code());
    }

    @Test
    public void customUserAgentTests() throws Exception {
        RestClient.Builder restBuilder = new RestClient.Builder("http://localhost")
                .withUserAgent("Awesome")
                .withInterceptor(new Interceptor() {
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
                })
                .withMapperAdapter(new JacksonMapperAdapter());
        ServiceClient serviceClient = new ServiceClient(restBuilder.build()) { };
        Response response = serviceClient.restClient().httpClient()
                .newCall(new Request.Builder().get().url("http://localhost").build()).execute();
        Assert.assertEquals(200, response.code());
    }
}
