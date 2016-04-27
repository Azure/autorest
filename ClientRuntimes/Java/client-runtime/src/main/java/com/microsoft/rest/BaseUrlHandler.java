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
public class BaseUrlHandler implements Interceptor {
    private final String rawUrl;
    private String baseUrl;

    public BaseUrlHandler(String rawUrl) {
        this.rawUrl = rawUrl;
        this.baseUrl = null;
    }

    public String baseUrl() {
        if (this.baseUrl == null) {
            return rawUrl;
        }
        return this.baseUrl;
    }

    public void setBaseUrl(String... replacements) {
        if (replacements.length % 2 != 0) {
            throw new IllegalArgumentException("Must provide a replacement value for each pattern");
        }
        baseUrl = rawUrl;
        for (int i = 0; i < replacements.length; i += 2) {
            baseUrl = baseUrl.replace(replacements[i], replacements[i+1]);
        }
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();
        if (baseUrl != null) {
            HttpUrl baseHttpUrl = HttpUrl.parse(baseUrl);
            HttpUrl newUrl = request.url().newBuilder()
                    .host(baseHttpUrl.host())
                    .scheme(baseHttpUrl.scheme())
                    .port(baseHttpUrl.port())
                    .build();
            request = request.newBuilder()
                    .url(newUrl)
                    .build();
        }
        return chain.proceed(request);
    }
}
