/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import okhttp3.OkHttpClient;

/**
 * ServiceClientCredentials is the abstraction for credentials used by
 * ServiceClients accessing REST services.
 */
public interface ServiceClientCredentials {
    /**
     * Apply the credentials to the HTTP client builder.
     *
     * @param clientBuilder the builder for building up an {@link OkHttpClient}
     */
    void applyCredentialsFilter(OkHttpClient.Builder clientBuilder);
}
