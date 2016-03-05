/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

/**
 * Token credentials filter for placing a token credential into request headers.
 */
public class TokenCredentialsInterceptor implements Interceptor {
    /**
     * The credentials instance to apply to the HTTP client pipeline.
     */
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
        Response response = sendRequestWithAuthorization(chain);
        if (response == null || response.code() == 401) {
            credentials.refreshToken();
            response = sendRequestWithAuthorization(chain);
        }
        return response;
    }

    private Response sendRequestWithAuthorization(Chain chain) throws IOException {
        Request newRequest = chain.request().newBuilder()
                .header("Authorization", credentials.getScheme() + " " + credentials.getToken())
                .build();
        return chain.proceed(newRequest);
    }
}
