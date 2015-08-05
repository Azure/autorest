/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.retry;

import org.apache.http.protocol.HttpContext;

import javax.ws.rs.client.ClientRequestContext;
import javax.ws.rs.client.ClientRequestFilter;
import java.io.IOException;

public class RetryHandler implements ClientRequestFilter {
    private static final int DEFAULT_NUMBER_OF_ATTEMPTS = 3;
    private static final int DEFAULT_BACKOFF_DELTA = 1000 * 10;
    private static final int DEFAULT_MAX_BACKOFF = 1000 * 10;
    private static final int DEFAULT_MIN_BACKOFF = 1000;

    private RetryStrategy retryStrategy;

    public RetryHandler(RetryStrategy retryStrategy) {
        this.retryStrategy = retryStrategy;
    }

    @Override
    public void filter(ClientRequestContext requestContext) throws IOException {

    }
}
