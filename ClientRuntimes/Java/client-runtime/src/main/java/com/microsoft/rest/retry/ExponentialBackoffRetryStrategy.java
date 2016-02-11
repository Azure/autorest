/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.retry;

import okhttp3.Response;

/**
 * A retry strategy with backoff parameters for calculating the exponential delay between retries.
 */
public class ExponentialBackoffRetryStrategy extends RetryStrategy {
    /**
     * Represents the default amount of time used when calculating a random delta in the exponential
     * delay between retries.
     */
    public static final int DEFAULT_CLIENT_BACKOFF = 1000 * 10;
    /**
     * Represents the default maximum amount of time used when calculating the exponential
     * delay between retries.
     */
    public static final int DEFAULT_MAX_BACKOFF = 1000 * 30;
    /**
     *Represents the default minimum amount of time used when calculating the exponential
     * delay between retries.
     */
    public static final int DEFAULT_MIN_BACKOFF = 1000;

    /**
     * The value that will be used to calculate a random delta in the exponential delay
     * between retries.
     */
    private final int deltaBackoff;
    /**
     * The maximum backoff time.
     */
    private final int maxBackoff;
    /**
     * The minimum backoff time.
     */
    private final int minBackoff;
    /**
     * The maximum number of retry attempts.
     */
    private final int retryCount;

    /**
     * Initializes a new instance of the {@link ExponentialBackoffRetryStrategy} class.
     */
    public ExponentialBackoffRetryStrategy() {
        this(DEFAULT_CLIENT_RETRY_COUNT, DEFAULT_MIN_BACKOFF, DEFAULT_MAX_BACKOFF, DEFAULT_CLIENT_BACKOFF);
    }

    /**
     * Initializes a new instance of the {@link ExponentialBackoffRetryStrategy} class.
     *
     * @param retryCount The maximum number of retry attempts.
     * @param minBackoff The minimum backoff time.
     * @param maxBackoff The maximum backoff time.
     * @param deltaBackoff The value that will be used to calculate a random delta in the exponential delay
     *                     between retries.
     */
    public ExponentialBackoffRetryStrategy(int retryCount, int minBackoff, int maxBackoff, int deltaBackoff) {
        this(null, retryCount, minBackoff, maxBackoff, deltaBackoff, DEFAULT_FIRST_FAST_RETRY);
    }

    /**
     * Initializes a new instance of the {@link ExponentialBackoffRetryStrategy} class.
     *
     * @param name The name of the retry strategy.
     * @param retryCount The maximum number of retry attempts.
     * @param minBackoff The minimum backoff time.
     * @param maxBackoff The maximum backoff time.
     * @param deltaBackoff The value that will be used to calculate a random delta in the exponential delay
     *                     between retries.
     * @param firstFastRetry true to immediately retry in the first attempt; otherwise, false. The subsequent
     *                       retries will remain subject to the configured retry interval.
     */
    public ExponentialBackoffRetryStrategy(String name, int retryCount, int minBackoff, int maxBackoff,
                                              int deltaBackoff, boolean firstFastRetry) {
        super(name, firstFastRetry);
        this.retryCount = retryCount;
        this.minBackoff = minBackoff;
        this.maxBackoff = maxBackoff;
        this.deltaBackoff = deltaBackoff;
    }

    /**
     * Returns if a request should be retried based on the retry count, current response,
     * and the current strategy.
     *
     * @param retryCount The current retry attempt count.
     * @param response The exception that caused the retry conditions to occur.
     * @return true if the request should be retried; false otherwise.
     */
    @Override
    public boolean shouldRetry(int retryCount, Response response) {
        int code = response.code();
        //CHECKSTYLE IGNORE MagicNumber FOR NEXT 2 LINES
        return retryCount < this.retryCount
                && (code == 408 || (code >= 500 && code != 501 && code != 505));
    }
}
