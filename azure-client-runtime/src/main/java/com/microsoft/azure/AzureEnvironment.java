/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.microsoft.rest.RestClient;

/**
 * An instance of this class describes an environment in Azure.
 */
public final class AzureEnvironment {
    /**
     * Base URL for calls to Azure management API.
     */
    private final String baseURL;

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
     * @param baseUrl the base URL for the current environment.
     */
    public AzureEnvironment(
            String authenticationEndpoint,
            String tokenAudience,
            boolean validateAuthority,
            String baseUrl) {
        this.authenticationEndpoint = authenticationEndpoint;
        this.tokenAudience = tokenAudience;
        this.validateAuthority = validateAuthority;
        this.baseURL = baseUrl;
    }

    /**
     * Provides the settings for authentication with Azure.
     */
    public static final AzureEnvironment AZURE = new AzureEnvironment(
            "https://login.windows.net/",
            "https://management.core.windows.net/",
            true,
            "https://management.azure.com/");

    /**
     * Provides the settings for authentication with Azure China.
     */
    public static final AzureEnvironment AZURE_CHINA = new AzureEnvironment(
            "https://login.chinacloudapi.cn/",
            "https://management.core.chinacloudapi.cn/",
            true,
            "https://management.chinacloudapi.cn");

    /**
     * Gets the base URL of the management service.
     *
     * @return the Base URL for the management service.
     */
    public String getBaseUrl() {
        return this.baseURL;
    }

    /**
     * Gets a builder for {@link RestClient}.
     *
     * @return a builder for the rest client.
     */
    public RestClient.Builder newRestClientBuilder() {
        return new RestClient.Builder(baseURL)
                .withInterceptor(new RequestIdHeaderInterceptor())
                .withMapperAdapter(new AzureJacksonMapperAdapter());
    }

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
