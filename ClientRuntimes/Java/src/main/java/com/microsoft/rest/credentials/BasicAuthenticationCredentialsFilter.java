/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import org.apache.commons.codec.binary.Base64;

import javax.ws.rs.client.ClientRequestContext;
import javax.ws.rs.client.ClientRequestFilter;
import java.io.UnsupportedEncodingException;

/**
 * Basic Auth credentials filter for placing a basic auth credentials into Apache pipeline.
 */
public class BasicAuthenticationCredentialsFilter implements ClientRequestFilter {
    private BasicAuthenticationCredentials credentials;

    /**
     * Initialize a BasicAuthenticationCredentialsFilter class with a
     * BasicAuthenticationCredentials credential.
     *
     * @param credentials a BasicAuthenticationCredentials instance
     */
    public BasicAuthenticationCredentialsFilter(BasicAuthenticationCredentials credentials) {
        this.credentials = credentials;
    }

    /* (non-Javadoc)
     * @see com.microsoft.rest.pipeline.ServiceRequestFilter#filter(org.apache.http.HttpRequest)
     */
    @Override
    public void filter(ClientRequestContext clientRequestContext) {
        try {
            String auth = credentials.getUserName() + ":" + credentials.getPassword();
            auth = Base64.encodeBase64String(auth.getBytes("UTF8"));
            clientRequestContext.getHeaders().add("Authorization", "Basic " + auth);
        } catch (UnsupportedEncodingException e) {
            // silently fail
        }
    }
}
