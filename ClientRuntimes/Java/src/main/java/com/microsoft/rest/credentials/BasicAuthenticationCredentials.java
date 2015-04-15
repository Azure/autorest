/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

/**
 * The Class CertificateCloudCredentials.
 */
public class BasicAuthenticationCredentials extends ServiceClientCredentials {
    private String userName;

    private String password;

    /**
     * Instantiates a new basic authentication credential.
     */
    public BasicAuthenticationCredentials() {
    }

    /**
     * Instantiates a new basic authentication credential.
     *
     * @param userName the uri
     * @param password the subscription id
     */
    public BasicAuthenticationCredentials(String userName, String password) {
        this.userName = userName;
        this.password = password;
    }

    /**
     * Get the username of the credential.
     */
    public String getUserName() {
        return userName;
    }

    /**
     * Get the password of the credential.
     */
    public String getPassword() {
        return password;
    }
}
