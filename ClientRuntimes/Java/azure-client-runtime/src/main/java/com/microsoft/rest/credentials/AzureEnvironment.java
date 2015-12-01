/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

public final class AzureEnvironment {
    private String authenticationEndpoint;
    private String tokenAudience;
    private boolean validateAuthority;

    public AzureEnvironment(String authenticationEndpoint, String tokenAudience, boolean validateAuthority) {
        this.authenticationEndpoint = authenticationEndpoint;
        this.tokenAudience = tokenAudience;
        this.validateAuthority = validateAuthority;
    }

    public static final AzureEnvironment Azure = new AzureEnvironment(
            "https://login.windows.net/",
            "https://management.core.windows.net/",
            true);

    public static final AzureEnvironment AzureChina = new AzureEnvironment(
            "https://login.chinacloudapi.cn/",
            "https://management.core.chinacloudapi.cn/",
            true);

    public String getAuthenticationEndpoint() {
        return authenticationEndpoint;
    }

    public String getTokenAudience() {
        return tokenAudience;
    }

    public boolean isValidateAuthority() {
        return validateAuthority;
    }
}
