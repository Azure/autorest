/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import android.app.Activity;

import com.microsoft.aad.adal.AuthenticationCallback;
import com.microsoft.aad.adal.AuthenticationResult;
import com.squareup.okhttp.OkHttpClient;

/**
 * Token based credentials for use with a REST Service Client.
 */
public class UserTokenCredentials extends TokenCredentials {
    /** The Active Directory application client id. */
    private String clientId;
    /** The domain or tenant id containing this application. */
    private String domain;
    /** The user name for the Organization Id account. */
    private String username;
    /** The password for the Organization Id account. */
    private String password;
    /** The Uri where the user will be redirected after authenticating with AD. */
    private String clientRedirectUri;
    /** The Azure environment to authenticate with. */
    private AzureEnvironment environment;
    /** The authentication callback. */
    private AuthenticationCallback<AuthenticationResult> callback;
    /** The caller activity. */
    private Activity activity;

    /**
     * Initializes a new instance of the UserTokenCredentials.
     *
     * @param clientId the active directory application client id.
     * @param domain the domain or tenant id containing this application.
     * @param username the user name for the Organization Id account.
     * @param password the password for the Organization Id account.
     * @param clientRedirectUri the Uri where the user will be redirected after authenticating with AD.
     * @param environment the Azure environment to authenticate with.
     *                    If null is provided, AzureEnvironment.AZURE will be used.
     */
    public UserTokenCredentials(Activity activity, String clientId, String domain, String username, String password, String clientRedirectUri,
                                AzureEnvironment environment, AuthenticationCallback<AuthenticationResult> callback) {
        super(null, null); // defer token acquisition
        this.clientId = clientId;
        this.domain = domain;
        this.username = username;
        this.password = password;
        this.clientRedirectUri = clientRedirectUri;
        if (environment == null) {
            this.environment = AzureEnvironment.AZURE;
        } else {
            this.environment = environment;
        }
        this.callback = callback;
        this.activity = activity;
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
     * Gets the user name for the Organization Id account.
     *
     * @return the user name.
     */
    public String getUsername() {
        return username;
    }

    /**
     * Gets the password for the Organization Id account.
     *
     * @return the password.
     */
    public String getPassword() {
        return password;
    }

    /**
     * Gets the Uri where the user will be redirected after authenticating with AD.
     *
     * @return the redirecting Uri.
     */
    public String getClientRedirectUri() {
        return clientRedirectUri;
    }

    /**
     * Gets the Azure environment to authenticate with.
     *
     * @return the Azure environment to authenticate with.
     */
    public AzureEnvironment getEnvironment() {
        return environment;
    }

    public AuthenticationCallback<AuthenticationResult> getCallback() {
        return callback;
    }

    public Activity getActivity() {
        return activity;
    }

    @Override
    public void applyCredentialsFilter(OkHttpClient client) {
        client.interceptors().add(new UserTokenCredentialsInterceptor(this, activity));
    }
}
