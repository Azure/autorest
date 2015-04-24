/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.rest.pipeline.ServiceRequestFilter;
import org.apache.http.HttpRequest;

/**
 * Token credentials filter for placing a token credentials into Apache pipeline.
 */
public class TokenCredentialsFilter implements ServiceRequestFilter {
    private TokenCredentials credentials;

    /**
     * Initialize a TokenCredentialsFilter class with a
     * TokenCredentials credential.
     *
     * @param credentials a TokenCredentials instance
     */
    public TokenCredentialsFilter(TokenCredentials credentials) {
        this.credentials = credentials;
    }

    /* (non-Javadoc)
     * @see com.microsoft.rest.pipeline.ServiceRequestFilter#filter(org.apache.http.HttpRequest)
     */
    @Override
    public void filter(HttpRequest request) {
        request.setHeader("Authorization", credentials.getScheme() + " " + credentials.getToken());
    }
}
