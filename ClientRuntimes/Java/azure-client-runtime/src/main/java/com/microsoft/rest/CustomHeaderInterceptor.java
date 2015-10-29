/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.squareup.okhttp.Headers;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * User agent interceptor for putting a 'User-Agent' header in the request.
 */
public class CustomHeaderInterceptor implements Interceptor {
    private Map<String, List<String>> headers;

    /**
     * Initialize an instance of {@link UserAgentInterceptor} class with the default
     * 'User-Agent' header.
     */
    public CustomHeaderInterceptor() {
        headers = new HashMap<>();
    }

    public CustomHeaderInterceptor addHeader(String name, String value) {
        this.headers.put(name, Collections.singletonList(value));
        return this;
    }

    /**
     * Initialize an instance of {@link UserAgentInterceptor} class with the specified
     * 'User-Agent' header.
     *
     * @param headers the 'User-Agent' header value.
     */
    public CustomHeaderInterceptor addHeaders(Headers headers) {
        this.headers.putAll(headers.toMultimap());
        return this;
    }

    public CustomHeaderInterceptor addHeaderMap(Map<String, String> headers) {
        for (Map.Entry<String, String> header : headers.entrySet()) {
            this.headers.put(header.getKey(), Collections.singletonList(header.getValue()));
        }
        return this;
    }

    public CustomHeaderInterceptor addHeaderMultimap(Map<String, List<String>> headers) {
        this.headers.putAll(headers);
        return this;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request.Builder builder = chain.request().newBuilder();
        for (Map.Entry<String, List<String>> header : headers.entrySet()) {
            for (String value : header.getValue()) {
                builder = builder.addHeader(header.getKey(), value);
            }
        }
        return chain.proceed(builder.build());
    }
}
