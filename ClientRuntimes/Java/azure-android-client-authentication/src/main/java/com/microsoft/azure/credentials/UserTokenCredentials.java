/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure.credentials;

import android.app.Activity;

import com.microsoft.aad.adal.AuthenticationCallback;
import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.aad.adal.DefaultTokenCacheStore;
import com.microsoft.aad.adal.PromptBehavior;
import com.microsoft.rest.credentials.TokenCredentials;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.concurrent.CountDownLatch;

import javax.crypto.NoSuchPaddingException;

/**
 * Token based credentials for use with a REST Service Client.
 */
public class UserTokenCredentials extends TokenCredentials {
    /** The Active Directory application client id. */
    private String clientId;
    /** The domain or tenant id containing this application. */
    private String domain;
    /** The Uri where the user will be redirected after authenticating with AD. */
    private String clientRedirectUri;
    /** The Azure environment to authenticate with. */
    private AzureEnvironment environment;
    /** The caller activity. */
    private Activity activity;
    /** The count down latch to synchronize token acquisition. */
    private CountDownLatch signal = new CountDownLatch(1);
    /** The static token cache. */
    private static DefaultTokenCacheStore tokenCacheStore;
    /** The behavior of when to prompt a login. */
    private PromptBehavior promptBehavior;

    /**
     * Initializes a new instance of the UserTokenCredentials.
     *
     * @param activity The caller activity.
     * @param clientId the active directory application client id.
     * @param domain the domain or tenant id containing this application.
     * @param clientRedirectUri the Uri where the user will be redirected after authenticating with AD.
     */
    public UserTokenCredentials(
            Activity activity,
            String clientId,
            String domain,
            String clientRedirectUri) {
        this(activity, clientId, domain, clientRedirectUri, PromptBehavior.Auto, AzureEnvironment.AZURE);
    }

    /**
     * Initializes a new instance of the UserTokenCredentials.
     *
     * @param activity The caller activity.
     * @param clientId the active directory application client id.
     * @param domain the domain or tenant id containing this application.
     * @param clientRedirectUri the Uri where the user will be redirected after authenticating with AD.
     * @param promptBehavior the behavior of when to prompt a login.
     * @param environment the Azure environment to authenticate with.
     *                    If null is provided, AzureEnvironment.AZURE will be used.
     */
    public UserTokenCredentials(
            Activity activity,
            String clientId,
            String domain,
            String clientRedirectUri,
            PromptBehavior promptBehavior,
            AzureEnvironment environment) {
        super(null, null); // defer token acquisition
        this.clientId = clientId;
        this.domain = domain;
        this.clientRedirectUri = clientRedirectUri;
        this.activity = activity;
        this.promptBehavior = promptBehavior;
        this.environment = environment;
        if (tokenCacheStore == null) {
            try {
                tokenCacheStore = new DefaultTokenCacheStore(activity);
            } catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
                tokenCacheStore = null;
            }
        }
    }

    /**
     * Clear the items stored in token cache.
     */
    public static void clearTokenCache() {
        tokenCacheStore.removeAll();
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
     * Gets the tenant or domain containing the application.
     *
     * @return the tenant or domain containing the application.
     */
    public String getDomain() {
        return domain;
    }

    /**
     * Sets the tenant of domain containing the application.
     *
     * @param domain the tenant or domain containing the application.
     */
    public void setDomain(String domain) {
        this.domain = domain;
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

    @Override
    public String getToken() throws IOException {
        refreshToken();
        return token;
    }

    @Override
    public void refreshToken() throws IOException {
        acquireAccessToken();
    }

    private void acquireAccessToken() throws IOException {
        final String authorityUrl = this.getEnvironment().getAuthenticationEndpoint() + this.getDomain();
        AuthenticationContext context = new AuthenticationContext(activity, authorityUrl, true, tokenCacheStore);
        final UserTokenCredentials self = this;
        context.acquireToken(
                this.getEnvironment().getTokenAudience(),
                this.getClientId(),
                this.getClientRedirectUri(),
                null,
                promptBehavior,
                null,
                new AuthenticationCallback<AuthenticationResult>() {
                    @Override
                    public void onSuccess(AuthenticationResult authenticationResult) {
                        if (authenticationResult != null && authenticationResult.getAccessToken() != null) {
                            self.setToken(authenticationResult.getAccessToken());
                            signal.countDown();
                        } else {
                            onError(new IOException("Failed to acquire access token"));
                        }
                    }

                    @Override
                    public void onError(Exception e) {
                        signal.countDown();
                    }
                });
        try {
            signal.await();
        } catch (InterruptedException e) { /* Ignore */ }
    }
}
