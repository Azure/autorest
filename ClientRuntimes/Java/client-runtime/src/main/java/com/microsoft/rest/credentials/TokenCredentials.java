/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.squareup.okhttp.OkHttpClient;

/**
 * Token based credentials for use with a REST Service Client.
 */
public class TokenCredentials implements ServiceClientCredentials {
    /** The authentication scheme. */
    private String scheme;

    /** The secure token. */
    private String token;

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
     * @return the secure token
     */
    public String getToken() {
        return token;
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
    public void applyCredentialsFilter(OkHttpClient client) {
        client.interceptors().add(new TokenCredentialsInterceptor(this));
    }
}
