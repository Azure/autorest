/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.retry;

import com.squareup.okhttp.Response;

import java.io.IOException;

public class ExponentialBackoffRetryStrategy extends RetryStrategy {
    public static final int DEFAULT_CLIENT_BACKOFF = 1000 * 10;
    public static final int DEFAULT_MAX_BACKOFF = 1000 * 30;
    public static final int DEFAULT_MIN_BACKOFF = 1000;

    private final int deltaBackoff;
    private final int maxBackoff;
    private final int minBackoff;
    private final int retryCount;

    public ExponentialBackoffRetryStrategy() {
        this(DEFAULT_CLIENT_RETRY_COUNT, DEFAULT_MIN_BACKOFF, DEFAULT_MAX_BACKOFF, DEFAULT_CLIENT_BACKOFF);
    }

    public ExponentialBackoffRetryStrategy(int retryCount, int minBackoff, int maxBackoff, int deltaBackoff) {
        this(null, retryCount, minBackoff, maxBackoff, deltaBackoff, DEFAULT_FIRST_FAST_RETRY);
    }

    public ExponentialBackoffRetryStrategy(String name, int retryCount, int minBackoff, int maxBackoff,
                                              int deltaBackoff, boolean firstFastRetry) {
        super(name, firstFastRetry);
        this.retryCount = retryCount;
        this.minBackoff = minBackoff;
        this.maxBackoff = maxBackoff;
        this.deltaBackoff = deltaBackoff;
    }

    @Override
    public boolean shouldRetry(int retryCount, Response response) {
        return retryCount < this.retryCount;
    }
}
