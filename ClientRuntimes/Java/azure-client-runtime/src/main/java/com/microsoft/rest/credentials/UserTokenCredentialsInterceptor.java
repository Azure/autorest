/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.aad.adal4j.AuthenticationContext;
import com.microsoft.aad.adal4j.AuthenticationResult;
import com.microsoft.rest.ServiceException;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import java.io.IOException;
import java.util.concurrent.Executors;

/**
 * Token credentials filter for placing a token credential into request headers.
 */
public class UserTokenCredentialsInterceptor implements Interceptor {
    private UserTokenCredentials credentials;

    /**
     * Initialize a TokenCredentialsFilter class with a
     * TokenCredentials credential.
     *
     * @param credentials a TokenCredentials instance
     */
    public UserTokenCredentialsInterceptor(UserTokenCredentials credentials) {
        this.credentials = credentials;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        String authorityUrl = credentials.getEnvironment().getAuthenticationEndpoint() + credentials.getDomain();
        try {
            AuthenticationContext context = new AuthenticationContext(authorityUrl, credentials.getEnvironment().isValidateAuthority(), Executors.newSingleThreadExecutor());
            AuthenticationResult result = context.acquireToken(
                    credentials.getEnvironment().getTokenAudience(),
                    credentials.getClientId(),
                    credentials.getUsername(),
                    credentials.getPassword(),
                    null).get();
            if (result != null && result.getAccessToken() != null) {
                credentials.setToken(result.getAccessToken());
            }
        } catch (Exception e) {
            throw new IOException(e.getMessage(), e);
        }

        Request newRequest = chain.request().newBuilder()
                .header("Authorization", credentials.getScheme() + " " + credentials.getToken())
                .build();
        return chain.proceed(newRequest);
    }
}
