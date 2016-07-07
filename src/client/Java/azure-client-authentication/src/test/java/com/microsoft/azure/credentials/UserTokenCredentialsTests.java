/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure.credentials;

import com.microsoft.aad.adal4j.AuthenticationResult;
import com.microsoft.azure.AzureEnvironment;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;
import java.util.Date;

public class UserTokenCredentialsTests {
    private static MockUserTokenCredentials credentials = new MockUserTokenCredentials(
            "clientId",
            "domain",
            "username",
            "password",
            "redirect",
            AzureEnvironment.AZURE
    );

    @Test
    public void testAcquireToken() throws Exception {
        credentials.refreshToken();
        Assert.assertEquals("token1", credentials.getToken());
        Thread.sleep(1500);
        Assert.assertEquals("token2", credentials.getToken());
    }

    public static class MockUserTokenCredentials extends UserTokenCredentials {
        private AuthenticationResult authenticationResult;

        public MockUserTokenCredentials(String clientId, String domain, String username, String password, String clientRedirectUri, AzureEnvironment environment) {
            super(clientId, domain, username, password, clientRedirectUri, environment);
        }

        @Override
        public String getToken() throws IOException {
            if (authenticationResult != null
                && authenticationResult.getExpiresOnDate().before(new Date())) {
                acquireAccessTokenFromRefreshToken();
            } else {
                acquireAccessToken();
            }
            return authenticationResult.getAccessToken();
        }

        @Override
        public void refreshToken() throws IOException {
            acquireAccessToken();
        }

        private void acquireAccessToken() throws IOException {
            this.authenticationResult = new AuthenticationResult(
                    null,
                    "token1",
                    "refresh",
                    1,
                    null,
                    null,
                    false);
        }

        private void acquireAccessTokenFromRefreshToken() throws IOException {
            this.authenticationResult = new AuthenticationResult(
                    null,
                    "token2",
                    "refresh",
                    1,
                    null,
                    null,
                    false);
        }
    }
}
