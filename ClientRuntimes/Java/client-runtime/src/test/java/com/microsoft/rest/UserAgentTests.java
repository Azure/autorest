/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Protocol;
import com.squareup.okhttp.Response;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

public class UserAgentTests {
    @Test
    public void defaultUserAgentTests() throws Exception {
        ServiceClient serviceClient = new ServiceClient() { };
        serviceClient.getClientInterceptors().add(new Interceptor() {
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
    }

    @Test
    public void customUserAgentTests() throws Exception {
        ServiceClient serviceClient = new ServiceClient() { };
        serviceClient.getClientInterceptors().add(new UserAgentInterceptor("Awesome"));
        serviceClient.getClientInterceptors().add(new Interceptor() {
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
    }
}
