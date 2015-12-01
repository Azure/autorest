/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import com.microsoft.rest.credentials.TokenCredentials;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Protocol;
import com.squareup.okhttp.Response;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

public class CredentialsTests {
    @Test
    public void basicCredentialsTest() throws Exception {
        ServiceClient serviceClient = new ServiceClient() { };
        BasicAuthenticationCredentials credentials = new BasicAuthenticationCredentials("user", "pass");
        credentials.applyCredentialsFilter(serviceClient.client);
        serviceClient.getClientInterceptors().add(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                String header = chain.request().header("Authorization");
                Assert.assertEquals("Basic dXNlcjpwYXNz", header);
                    return new Response.Builder()
                            .request(chain.request())
                            .code(200)
                            .protocol(Protocol.HTTP_1_1)
                            .build();
            }
        });
    }

    @Test
    public void tokenCredentialsTest() throws Exception {
        ServiceClient serviceClient = new ServiceClient() { };
        TokenCredentials credentials = new TokenCredentials(null, "this_is_a_token");
        credentials.applyCredentialsFilter(serviceClient.client);
        serviceClient.getClientInterceptors().add(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                String header = chain.request().header("Authorization");
                Assert.assertEquals("Bearer this_is_a_token", header);
                return new Response.Builder()
                        .request(chain.request())
                        .code(200)
                        .protocol(Protocol.HTTP_1_1)
                        .build();
            }
        });
    }
}
