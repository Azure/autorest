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
public class ApplicationTokenCredentials extends TokenCredentials {
    private String clientId;
    private String domain;
    private String secret;
    private AzureEnvironment environment;

    /**
     * Initializes a new instance of the UserTokenCredentials.
     *
     * @param clientId the active directory application client id.
     * @param domain the domain or tenant id containing this application.
     * @param secret the authentication secret for the application.
     */
    public ApplicationTokenCredentials(String clientId, String domain, String secret, AzureEnvironment environment) {
        super(null, null); // defer token acquisition
        this.clientId = clientId;
        this.domain = domain;
        this.secret = secret;
        if (environment == null) {
            this.environment = AzureEnvironment.Azure;
        } else {
            this.environment = environment;
        }
    }

    public String getClientId() {
        return clientId;
    }

    public String getDomain() {
        return domain;
    }

    public String getSecret() {
        return secret;
    }

    public AzureEnvironment getEnvironment() {
        return environment;
    }

    public void applyCredentialsFilter(OkHttpClient client) {
        client.interceptors().add(new ApplicationTokenCredentialsInterceptor(this));
    }
}
