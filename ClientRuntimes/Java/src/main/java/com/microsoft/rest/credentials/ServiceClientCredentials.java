/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.rest.ServiceClient;

/**
 * ServiceClientCredentials is the abstraction for credentials used by ServiceClients accessing REST services.
 */
public abstract class ServiceClientCredentials {

    /**
     * Apply the credentials to the HTTP client builder.
     * @param client The ServiceClient.
     */
    public void applyCredentialsFilter(ServiceClient client) {
        return;
    }
}
