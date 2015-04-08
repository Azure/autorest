/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.rest.core.pipeline.ServiceRequestContext;
import com.microsoft.rest.core.pipeline.ServiceRequestFilter;
import com.microsoft.rest.core.utils.Base64;

import java.util.concurrent.ExecutorService;

public class BasicAuthenticationCredentialsFilter implements ServiceRequestFilter {
    private BasicAuthenticationCredentials credentials;

    public BasicAuthenticationCredentialsFilter(BasicAuthenticationCredentials credentials) {
        this.credentials = credentials;
    }

    @Override
    public void filter(ServiceRequestContext request) {
        ExecutorService service = null;

        try {
            String auth = credentials.getUserName() + ":" + credentials.getPassword();
            auth = new String(Base64.encode(auth.getBytes("UTF8")));
            request.setHeader("Authorization", "Basic " + auth);
        } catch (Exception e) {
            // silently fail
        } finally {
            if (service != null) {
                service.shutdown();
            }
        }
    }
}
