/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import android.app.Activity;

import com.microsoft.aad.adal.AuthenticationCallback;
import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.aad.adal.PromptBehavior;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.NoSuchPaddingException;

/**
 * Token credentials filter for placing a token credential into request headers.
 */
public class UserTokenCredentialsInterceptor implements Interceptor {
    /**
     * The credentials instance to apply to the HTTP client pipeline.
     */
    private UserTokenCredentials credentials;

    private Activity activity;

    /**
     * Initialize a UserTokenCredentialsInterceptor class with a
     * UserTokenCredentials credential.
     *
     * @param credentials a TokenCredentials instance
     */
    public UserTokenCredentialsInterceptor(UserTokenCredentials credentials, Activity activity) {
        this.credentials = credentials;
        this.activity = activity;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        if (credentials.getToken() == null) {
            acquireAccessToken(chain.request());
        }
        Response response = sendRequestWithAuthorization(chain);
        if (response == null || response.code() == 401) {
            acquireAccessToken(chain.request());
            response = sendRequestWithAuthorization(chain);
        }

        return response;
    }

    private Response sendRequestWithAuthorization(Chain chain) throws IOException {
        Request newRequest = chain.request().newBuilder()
                .header("Authorization", credentials.getScheme() + " " + credentials.getToken())
                .build();
        return chain.proceed(newRequest);
    }

    private void acquireAccessToken(final Request request) throws IOException {
        String authorityUrl = credentials.getEnvironment().getAuthenticationEndpoint() + credentials.getDomain();
        AuthenticationContext context = null;
        try {
            context = new AuthenticationContext(activity, authorityUrl, false);
        } catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
            return;
        }
        context.acquireToken(activity,
                credentials.getEnvironment().getTokenAudience(),
                credentials.getClientId(),
                credentials.getClientRedirectUri(),
                PromptBehavior.Auto,
                new AuthenticationCallback<AuthenticationResult>() {
                    @Override
                    public void onSuccess(AuthenticationResult authenticationResult) {
                        if (authenticationResult != null && authenticationResult.getAccessToken() != null) {
                            credentials.setToken(authenticationResult.getAccessToken());
                            credentials.getCallback().onSuccess(authenticationResult);
                        } else {
                            onError(new IOException("Failed to acquire access token for request url " + request.urlString()));
                        }
                    }

                    @Override
                    public void onError(Exception e) {
                        credentials.getCallback().onError(e);
                    }
        });
    }
}
