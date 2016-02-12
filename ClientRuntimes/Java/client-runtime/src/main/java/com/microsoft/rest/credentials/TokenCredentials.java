/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import okhttp3.OkHttpClient;

import java.io.IOException;

/**
 * Token based credentials for use with a REST Service Client.
 */
public class TokenCredentials implements ServiceClientCredentials {
    /** The authentication scheme. */
    protected String scheme;

    /** The secure token. */
    protected String token;

    /**
     * Initializes a new instance of the TokenCredentials.
     *
     * @param scheme scheme to use. If null, defaults to Bearer
     * @param token  valid token
     */
    public TokenCredentials(String scheme, String token) {
        if (scheme == null) {
            scheme = "Bearer";
        }
        this.scheme = scheme;
        this.token = token;
    }

    /**
     * Get the secure token.
     *
     * @return the secure token.
     * @throws IOException exception thrown from token acquisition operations.
     */
    public String getToken() throws IOException {
        return token;
    }

    /**
     * Refresh the secure token.
     * @throws IOException exception thrown from token acquisition operations.
     */
    public void refreshToken() throws IOException {
        // do nothing
    }

    /**
     * Set the secure token.
     *
     * @param token the token string
     */
    public void setToken(String token) {
        this.token = token;
    }

    /**
     * Get the authentication scheme.
     *
     * @return the authentication scheme
     */
    public String getScheme() {
        return scheme;
    }

    @Override
    public void applyCredentialsFilter(OkHttpClient.Builder clientBuilder) {
        clientBuilder.interceptors().add(new TokenCredentialsInterceptor(this));
    }
}
