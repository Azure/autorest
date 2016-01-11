/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.aad.adal4j.AuthenticationContext;
import com.microsoft.aad.adal4j.AuthenticationResult;
import com.microsoft.aad.adal4j.ClientCredential;

import java.io.IOException;
import java.util.concurrent.Executors;

/**
 * Token based credentials for use with a REST Service Client.
 */
public class ApplicationTokenCredentials extends TokenCredentials {
    /** The active directory application client id. */
    private String clientId;
    /** The tenant or domain the containing the application. */
    private String domain;
    /** The authentication secret for the application. */
    private String secret;
    /** The Azure environment to authenticate with. */
    private AzureEnvironment environment;

    /**
     * Initializes a new instance of the UserTokenCredentials.
     *
     * @param clientId the active directory application client id.
     * @param domain the domain or tenant id containing this application.
     * @param secret the authentication secret for the application.
     * @param environment the Azure environment to authenticate with.
     *                    If null is provided, AzureEnvironment.AZURE will be used.
     */
    public ApplicationTokenCredentials(String clientId, String domain, String secret, AzureEnvironment environment) {
        super(null, null); // defer token acquisition
        this.clientId = clientId;
        this.domain = domain;
        this.secret = secret;
        if (environment == null) {
            this.environment = AzureEnvironment.AZURE;
        } else {
            this.environment = environment;
        }
    }

    /**
     * Gets the active directory application client id.
     *
     * @return the active directory application client id.
     */
    public String getClientId() {
        return clientId;
    }

    /**
     * Gets the tenant or domain the containing the application.
     *
     * @return the tenant or domain the containing the application.
     */
    public String getDomain() {
        return domain;
    }

    /**
     * Gets the authentication secret for the application.
     *
     * @return the authentication secret for the application.
     */
    public String getSecret() {
        return secret;
    }

    /**
     * Gets the Azure environment to authenticate with.
     *
     * @return the Azure environment to authenticate with.
     */
    public AzureEnvironment getEnvironment() {
        return environment;
    }

    @Override
    public String getToken() throws IOException {
        if (token == null) {
            token = acquireAccessToken();
        }
        return token;
    }

    @Override
    public void refreshToken() throws IOException {
        token = acquireAccessToken();
    }

    private String acquireAccessToken() throws IOException {
        String authorityUrl = this.getEnvironment().getAuthenticationEndpoint() + this.getDomain();
        AuthenticationContext context = new AuthenticationContext(authorityUrl, this.getEnvironment().isValidateAuthority(), Executors.newSingleThreadExecutor());
        AuthenticationResult result;
        try {
            result = context.acquireToken(
                    this.getEnvironment().getTokenAudience(),
                    new ClientCredential(this.getClientId(), this.getSecret()),
                    null).get();
        } catch (Exception e) {
            throw new IOException(e.getMessage(), e);
        }
        if (result != null && result.getAccessToken() != null) {
            return result.getAccessToken();
        } else {
            throw new IOException("Failed to acquire access token");
        }
    }
}
