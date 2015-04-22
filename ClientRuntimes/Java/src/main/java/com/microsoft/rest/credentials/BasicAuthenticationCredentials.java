/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.microsoft.rest.ServiceClient;
import org.apache.http.impl.client.HttpClientBuilder;

/**
 * Basic Auth credentials for use with a REST Service Client.
 */
public class BasicAuthenticationCredentials extends ServiceClientCredentials {
    private String userName;

    private String password;

    /**
     * Instantiates a new basic authentication credential.
     *
     * @param userName Basic auth UserName.
     * @param password Basic auth password.
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

    /* (non-Javadoc)
     * @see com.microsoft.rest.credentials.ServiceClientCredentials#applyCredentialsFilter(org.apache.http.impl.client.HttpClientBuilder)
     */
    @Override
    public void applyCredentialsFilter(ServiceClient client) {
        client.addRequestFilterFirst(new BasicAuthenticationCredentialsFilter(this));
    }
}
