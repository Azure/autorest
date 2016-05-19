/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import com.microsoft.rest.credentials.TokenCredentials;
import com.microsoft.rest.serializer.JacksonMapperAdapter;
import okhttp3.*;
import org.junit.Assert;
import org.junit.Test;
import retrofit2.Retrofit;

import java.io.IOException;

public class CredentialsTests {
    @Test
    public void basicCredentialsTest() throws Exception {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder();
        Retrofit.Builder retrofitBuilder = new Retrofit.Builder();
        BasicAuthenticationCredentials credentials = new BasicAuthenticationCredentials("user", "pass");
        RestClient.Builder restBuilder = new RestClient.Builder("http://localhost", clientBuilder, retrofitBuilder)
                .withMapperAdapter(new JacksonMapperAdapter())
                .withCredentials(credentials)
                .withInterceptor(new Interceptor() {
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
        ServiceClient serviceClient = new ServiceClient(restBuilder.build()) { };
        Response response = serviceClient.restClient().httpClient().newCall(new Request.Builder().url("http://localhost").build()).execute();
        Assert.assertEquals(200, response.code());
    }

    @Test
    public void tokenCredentialsTest() throws Exception {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder();
        Retrofit.Builder retrofitBuilder = new Retrofit.Builder();
        TokenCredentials credentials = new TokenCredentials(null, "this_is_a_token");
        RestClient.Builder restBuilder = new RestClient.Builder("http://localhost", clientBuilder, retrofitBuilder)
                .withMapperAdapter(new JacksonMapperAdapter())
                .withCredentials(credentials)
                .withInterceptor(new Interceptor() {
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
        ServiceClient serviceClient = new ServiceClient(restBuilder.build()) { };
        Response response = serviceClient.restClient().httpClient().newCall(new Request.Builder().url("http://localhost").build()).execute();
        Assert.assertEquals(200, response.code());
    }
}
