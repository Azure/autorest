/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;
import java.util.UUID;

/**
 * An instance of this class puts an UUID in the request header. Azure uses
 * the request id as the unique identifier for
 */
public class RequestIdHeaderInterceptor implements Interceptor {
    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request().newBuilder()
                .header("x-ms-client-request-id", UUID.randomUUID().toString())
                .build();
        return chain.proceed(request);
    }
}
