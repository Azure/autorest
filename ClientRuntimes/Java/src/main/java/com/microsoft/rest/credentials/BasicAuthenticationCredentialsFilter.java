/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.rest.pipeline.ServiceRequestFilter;
import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpRequest;

import java.io.UnsupportedEncodingException;

public class BasicAuthenticationCredentialsFilter implements ServiceRequestFilter {
    private BasicAuthenticationCredentials credentials;

    public BasicAuthenticationCredentialsFilter(BasicAuthenticationCredentials credentials) {
        this.credentials = credentials;
    }

    @Override
    public void filter(HttpRequest request) {
        try {
            String auth = credentials.getUserName() + ":" + credentials.getPassword();
            auth = Base64.encodeBase64String(auth.getBytes("UTF8"));
            request.setHeader("Authorization", "Basic " + auth);
        } catch (UnsupportedEncodingException e) {
            // silently fail
        }
    }
}
