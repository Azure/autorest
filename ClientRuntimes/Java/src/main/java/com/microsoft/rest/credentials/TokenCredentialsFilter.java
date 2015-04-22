/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.rest.pipeline.ServiceRequestFilter;
import org.apache.http.HttpRequest;

public class TokenCredentialsFilter implements ServiceRequestFilter {
    private TokenCredentials credentials;

    public TokenCredentialsFilter(TokenCredentials credentials) {
        this.credentials = credentials;
    }

    @Override
    public void filter(HttpRequest request) {
        request.setHeader("Authorization", credentials.getScheme() + " " + credentials.getToken());
    }
}
