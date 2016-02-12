/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import okhttp3.Headers;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * An instance of this class enables adding custom headers in client requests
 * when added to the {@link okhttp3.OkHttpClient} interceptors.
 */
public class CustomHeaderInterceptor implements Interceptor {
    /**
     * A mapping of custom headers.
     */
    private Map<String, List<String>> headers;

    /**
     * Initialize an instance of {@link CustomHeaderInterceptor} class.
     */
    public CustomHeaderInterceptor() {
        headers = new HashMap<String, List<String>>();
    }

    /**
     * Initialize an instance of {@link CustomHeaderInterceptor} class.
     *
     * @param key the key for the header
     * @param value the value of the header
     */
    public CustomHeaderInterceptor(String key, String value) {
        this();
        addHeader(key, value);
    }

    /**
     * Add a single header key-value pair. If one with the name already exists,
     * it gets replaced.
     *
     * @param name the name of the header.
     * @param value the value of the header.
     * @return the interceptor instance itself.
     */
    public CustomHeaderInterceptor replaceHeader(String name, String value) {
        this.headers.put(name, Collections.singletonList(value));
        return this;
    }

    /**
     * Add a single header key-value pair. If one with the name already exists,
     * both stay in the header map.
     *
     * @param name the name of the header.
     * @param value the value of the header.
     * @return the interceptor instance itself.
     */
    public CustomHeaderInterceptor addHeader(String name, String value) {
        if (this.headers.containsKey(name)) {
            this.headers.get(name).add(value);
        } else {
            this.headers.put(name, Collections.singletonList(value));
        }
        return this;
    }

    /**
     * Add all headers in a {@link Headers} object.
     *
     * @param headers an OkHttp {@link Headers} object.
     * @return the interceptor instance itself.
     */
    public CustomHeaderInterceptor addHeaders(Headers headers) {
        this.headers.putAll(headers.toMultimap());
        return this;
    }

    /**
     * Add all headers in a header map.
     *
     * @param headers a map of headers.
     * @return the interceptor instance itself.
     */
    public CustomHeaderInterceptor addHeaderMap(Map<String, String> headers) {
        for (Map.Entry<String, String> header : headers.entrySet()) {
            this.headers.put(header.getKey(), Collections.singletonList(header.getValue()));
        }
        return this;
    }

    /**
     * Add all headers in a header multimap.
     *
     * @param headers a multimap of headers.
     * @return the interceptor instance itself.
     */
    public CustomHeaderInterceptor addHeaderMultimap(Map<String, List<String>> headers) {
        this.headers.putAll(headers);
        return this;
    }

    /**
     * Remove a header.
     *
     * @param name the name of the header to remove.
     * @return the interceptor instance itself.
     */
    public CustomHeaderInterceptor removeHeader(String name) {
        this.headers.remove(name);
        return this;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request.Builder builder = chain.request().newBuilder();
        for (Map.Entry<String, List<String>> header : headers.entrySet()) {
            for (String value : header.getValue()) {
                builder = builder.header(header.getKey(), value);
            }
        }
        return chain.proceed(builder.build());
    }
}
