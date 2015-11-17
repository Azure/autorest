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
public class UserTokenCredentials extends TokenCredentials {
    private String clientId;
    private String domain;
    private String username;
    private String password;
    private String clientRedirectUri;
    private AzureEnvironment environment;

    /**
     * Initializes a new instance of the UserTokenCredentials.
     *
     * @param clientId the active directory application client id.
     * @param domain the domain or tenant id containing this application.
     * @param username the user name for the Organization Id account.
     * @param password the password for the Organization Id account.
     * @param clientRedirectUri the Uri where the user will be redirected after authenticating with AD.
     */
    public UserTokenCredentials(String clientId, String domain, String username, String password, String clientRedirectUri, AzureEnvironment environment) {
        super(null, null); // defer token acquisition
        this.clientId = clientId;
        this.domain = domain;
        this.username = username;
        this.password = password;
        this.clientRedirectUri = clientRedirectUri;
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

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getClientRedirectUri() {
        return clientRedirectUri;
    }

    public AzureEnvironment getEnvironment() {
        return environment;
    }

    public void applyCredentialsFilter(OkHttpClient client) {
        client.interceptors().add(new UserTokenCredentialsInterceptor(this));
    }
}
