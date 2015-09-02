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

public class RetryHandlerTests {
    @Test
    public void ExponentialRetryEndOn501() throws Exception {
        ServiceClient serviceClient = new ServiceClient() {};
        serviceClient.getClientInterceptors().add(new Interceptor() {
            // Send 408, 500, 502, all retried, with a 501 ending
            int[] codes = new int[] {408, 500, 502, 501};
            int count = 0;
            @Override
            public Response intercept(Chain chain) throws IOException {
                    return new Response.Builder()
                            .request(chain.request())
                            .code(codes[count++])
                            .protocol(Protocol.HTTP_1_1)
                            .build();
            }
        });
        Response response = serviceClient.client.newCall(
                new Request.Builder().url("localhost").get().build()).execute();
        Assert.assertEquals(501, response.code());
    }

    @Test
    public void ExponentialRetryMax() throws Exception {
        ServiceClient serviceClient = new ServiceClient() {};
        serviceClient.getClientInterceptors().add(new Interceptor() {
            // Send 500 until max retry is hit
            int count = 0;
            @Override
            public Response intercept(Chain chain) throws IOException {
                Assert.assertTrue(count ++ < 5);
                return new Response.Builder()
                        .request(chain.request())
                        .code(500)
                        .protocol(Protocol.HTTP_1_1)
                        .build();
            }
        });
        Response response = serviceClient.client.newCall(
                new Request.Builder().url("localhost").get().build()).execute();
        Assert.assertEquals(500, response.code());
    }
}
