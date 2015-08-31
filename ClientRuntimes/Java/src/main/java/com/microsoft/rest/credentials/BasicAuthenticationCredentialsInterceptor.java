/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.credentials;

import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;
import org.apache.commons.codec.binary.Base64;

import java.io.IOException;

/**
 * Basic Auth credentials interceptor for placing a basic auth credential into request headers.
 */
public class BasicAuthenticationCredentialsInterceptor implements Interceptor {
    private BasicAuthenticationCredentials credentials;

    /**
     * Initialize a BasicAuthenticationCredentialsFilter class with a
     * BasicAuthenticationCredentials credential.
     *
     * @param credentials a BasicAuthenticationCredentials instance
     */
    public BasicAuthenticationCredentialsInterceptor(BasicAuthenticationCredentials credentials) {
        this.credentials = credentials;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        String auth = credentials.getUserName() + ":" + credentials.getPassword();
        auth = Base64.encodeBase64String(auth.getBytes("UTF8"));
        Request newRequest = chain.request().newBuilder()
                .header("Authorization", "Basic " + auth)
                .build();
        return chain.proceed(newRequest);
    }
}
