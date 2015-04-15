/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import java.util.ArrayList;
import java.util.Map;

/**
 * The Class CertificateCloudCredentials.
 */
public class TokenCredentials extends ServiceClientCredentials {
    /** The scheme. */
    private String scheme;
    
    /** The token */
    private String token;

    /**
     * Instantiates a new certificate cloud credentials.
     */
    public TokenCredentials() {
    }

    /**
     * Instantiates a new certificate cloud credentials.
     *
     * @param scheme the scheme in the authorization header
     * @param token the access token
     */
    public TokenCredentials(String scheme, String token) {
        if (scheme == null)
        {
            scheme = "Bearer";
        }
        this.scheme = scheme;
        this.token = token;
    }

    /**
     * Get the authentication token.
     *
     * @return the ADAL authentication token
     */
    public String getToken() {
        return token;
    }

    /**
     * Get the authentication scheme.
     *
     */
    public String getScheme() {
        return scheme;
    }
}
