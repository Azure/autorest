/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Response;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;

public class ServiceClientTests {
    @Test
    public void filterTests() throws Exception {
        ServiceClient serviceClient = new ServiceClient() { };
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
