/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.aad.adal.ClientCredential;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import java.io.IOException;
import java.util.concurrent.Executors;

/**
 * Token credentials filter for placing a token credential into request headers.
 */
public class ApplicationTokenCredentialsInterceptor implements Interceptor {
    /**
     * The credentials instance to apply to the HTTP client pipeline.
     */
    private ApplicationTokenCredentials credentials;

    /**
     * Initialize an ApplicationTokenCredentialsInterceptor class with a
     * ApplicationTokenCredentials credential.
     *
     * @param credentials a TokenCredentials instance
     */
    public ApplicationTokenCredentialsInterceptor(ApplicationTokenCredentials credentials) {
        this.credentials = credentials;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        if (credentials.getToken() == null) {
            credentials.setToken(acquireAccessToken(chain.request()));
        }
        Response response = sendRequestWithAuthorization(chain);
        if (response == null || response.code() == 401) {
            credentials.setToken(acquireAccessToken(chain.request()));
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

    private String acquireAccessToken(Request request) throws IOException {
        String authorityUrl = credentials.getEnvironment().getAuthenticationEndpoint() + credentials.getDomain();
        AuthenticationContext context = new AuthenticationContext(authorityUrl, credentials.getEnvironment().isValidateAuthority(), Executors.newSingleThreadExecutor());
        AuthenticationResult result;
        try {
            result = context.acquireToken(
                    credentials.getEnvironment().getTokenAudience(),
                    new ClientCredential(credentials.getClientId(), credentials.getSecret()),
                    null).get();
        } catch (Exception e) {
            throw new IOException(e.getMessage(), e);
        }
        if (result != null && result.getAccessToken() != null) {
            return result.getAccessToken();
        } else {
            throw new IOException("Failed to acquire access token for request url " + request.urlString());
        }
    }
}
