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

/**
 * An instance of class handles dynamic base URLs in the HTTP pipeline.
 */
public class BaseUrlHandler implements Interceptor {
    /** The URL template for the dynamic URL. */
    private final String rawUrl;
    /** The base URL after applying the variable replacements. */
    private String baseUrl;

    /**
     * Creates an instance of this class with a URL template.
     *
     * @param rawUrl the URL template with variables wrapped in "{" and "}".
     */
    public BaseUrlHandler(String rawUrl) {
        this.rawUrl = rawUrl;
        this.baseUrl = null;
    }

    /**
     * Gets the base URL.
     *
     * @return the URL template if it's not a dynamic URL or variables in a
     * dynamic URL haven't been set. The compiled URL otherwise.
     */
    public String baseUrl() {
        if (this.baseUrl == null) {
            return rawUrl;
        }
        return this.baseUrl;
    }

    /**
     * Handles dynamic replacements on base URL. The arguments must be in pairs
     * with the string in raw URL to replace as replacements[i] and the dynamic
     * part as replacements[i+1]. E.g. {subdomain}.microsoft.com can be set
     * dynamically by calling setBaseUrl("{subdomain}", "azure").
     *
     * @param replacements the string replacements in pairs.
     */
    public void setBaseUrl(String... replacements) {
        if (replacements.length % 2 != 0) {
            throw new IllegalArgumentException("Must provide a replacement value for each pattern");
        }
        baseUrl = rawUrl;
        for (int i = 0; i < replacements.length; i += 2) {
            baseUrl = baseUrl.replace(replacements[i], replacements[i + 1]);
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
