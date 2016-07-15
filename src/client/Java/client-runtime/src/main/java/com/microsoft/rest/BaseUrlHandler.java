/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import okhttp3.HttpUrl;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

/**
 * Handles dynamic replacements on base URL. The arguments must be in pairs
 * with the string in raw URL to replace as replacements[i] and the dynamic
 * part as replacements[i+1]. E.g. {subdomain}.microsoft.com can be set
 * dynamically by setting header x-ms-parameterized-host: "{subdomain}, azure"
 */
public class BaseUrlHandler implements Interceptor {
    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();
        String parameters = request.header("x-ms-parameterized-host");
        if (parameters != null && !parameters.isEmpty()) {
            String[] replacements = parameters.split(", ");
            if (replacements.length % 2 != 0) {
                throw new IllegalArgumentException("Must provide a replacement value for each pattern");
            }
            String baseUrl = request.url().toString();
            for (int i = 0; i < replacements.length; i += 2) {
                baseUrl = baseUrl.replaceAll("(?i)\\Q" + replacements[i] + "\\E", replacements[i + 1]);
            }
            baseUrl = removeRedundantProtocol(baseUrl);
            HttpUrl baseHttpUrl = HttpUrl.parse(baseUrl);
            request = request.newBuilder()
                    .url(baseHttpUrl)
                    .removeHeader("x-ms-parameterized-host")
                    .build();
        }
        return chain.proceed(request);
    }

    private String removeRedundantProtocol(String url) {
        int last = url.lastIndexOf("://") - 1;
        while (last >= 0 && Character.isLetter(url.charAt(last))) {
            --last;
        }
        return url.substring(last + 1);
    }
}
