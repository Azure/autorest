/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.io.IOException;

import okhttp3.HttpUrl;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.internal.Version;
import retrofit2.BaseUrl;

/**
 * User agent interceptor for putting a 'User-Agent' header in the request.
 */
public class BaseUrlInterceptor implements Interceptor {
    private String baseUrl;

    public BaseUrlInterceptor() {
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();
        if (baseUrl != null) {
            HttpUrl newUrl = request.url().newBuilder()
                    .host(baseUrl)
                    .build();
            request = request.newBuilder()
                    .url(newUrl)
                    .build();
        }
        return chain.proceed(request);
    }
}
