/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure.credentials;

/**
 * An instance of this class describes an environment in Azure.
 */
public final class AzureEnvironment {
    /**
     * ActiveDirectory Endpoint for the Azure Environment.
     */
    private String authenticationEndpoint;
    /**
     * Token audience for an endpoint.
     */
    private String tokenAudience;
    /**
     * Determines whether the authentication endpoint should
     * be validated with Azure AD. Default value is true.
     */
    private boolean validateAuthority;

    /**
     * Initializes an instance of AzureEnvironment class.
     *
     * @param authenticationEndpoint ActiveDirectory Endpoint for the Azure Environment.
     * @param tokenAudience token audience for an endpoint.
     * @param validateAuthority whether the authentication endpoint should
     *                          be validated with Azure AD.
     */
    public AzureEnvironment(String authenticationEndpoint, String tokenAudience, boolean validateAuthority) {
        this.authenticationEndpoint = authenticationEndpoint;
        this.tokenAudience = tokenAudience;
        this.validateAuthority = validateAuthority;
    }

    /**
     * Provides the settings for authentication with Azure.
     */
    public static final AzureEnvironment AZURE = new AzureEnvironment(
            "https://login.windows.net/",
            "https://management.core.windows.net/",
            true);

    /**
     * Provides the settings for authentication with Azure China.
     */
    public static final AzureEnvironment AZURE_CHINA = new AzureEnvironment(
            "https://login.chinacloudapi.cn/",
            "https://management.core.chinacloudapi.cn/",
            true);

    /**
     * Gets the ActiveDirectory Endpoint for the Azure Environment.
     *
     * @return the ActiveDirectory Endpoint for the Azure Environment.
     */
    public String getAuthenticationEndpoint() {
        return authenticationEndpoint;
    }

    /**
     * Gets the token audience for an endpoint.
     *
     * @return the token audience for an endpoint.
     */
    public String getTokenAudience() {
        return tokenAudience;
    }

    /**
     * Gets whether the authentication endpoint should
     * be validated with Azure AD.
     *
     * @return true if the authentication endpoint should be validated with
     * Azure AD, false otherwise.
     */
    public boolean isValidateAuthority() {
        return validateAuthority;
    }
}
