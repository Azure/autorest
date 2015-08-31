/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import java.io.IOException;

/**
 * Token credentials filter for placing a token credential into request headers.
 */
public class TokenCredentialsInterceptor implements Interceptor {
    private TokenCredentials credentials;

    /**
     * Initialize a TokenCredentialsFilter class with a
     * TokenCredentials credential.
     *
     * @param credentials a TokenCredentials instance
     */
    public TokenCredentialsInterceptor(TokenCredentials credentials) {
        this.credentials = credentials;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request newRequest = chain.request().newBuilder()
                .header("Authorization", credentials.getScheme() + " " + credentials.getToken())
                .build();
        return chain.proceed(newRequest);
    }
}
