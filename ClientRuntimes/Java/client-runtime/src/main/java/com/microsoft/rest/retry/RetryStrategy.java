/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.retry;

import okhttp3.Response;

/**
 * Represents a retry strategy that determines the number of retry attempts and the interval
 * between retries.
 */
public abstract class RetryStrategy {
    /**
     * Represents the default number of retry attempts.
     */
    public static final int DEFAULT_CLIENT_RETRY_COUNT = 10;

    /**
     * Represents the default interval between retries.
     */
    public static final int DEFAULT_RETRY_INTERVAL = 1000;
    /**
     * Represents the default flag indicating whether the first retry attempt will be made immediately,
     * whereas subsequent retries will remain subject to the retry interval.
     */
    public static final boolean DEFAULT_FIRST_FAST_RETRY = true;

    /**
     * The name of the retry strategy.
     */
    private String name;

    /**
     * The value indicating whether the first retry attempt will be made immediately,
     * whereas subsequent retries will remain subject to the retry interval.
     */
    private boolean fastFirstRetry;

    /**
     * Initializes a new instance of the {@link RetryStrategy} class.
     *
     * @param name The name of the retry strategy.
     * @param firstFastRetry true to immediately retry in the first attempt; otherwise, false.
     */
    protected RetryStrategy(String name, boolean firstFastRetry) {
        this.name = name;
        this.fastFirstRetry = firstFastRetry;
    }

    /**
     * Returns if a request should be retried based on the retry count, current response,
     * and the current strategy.
     *
     * @param retryCount The current retry attempt count.
     * @param response The exception that caused the retry conditions to occur.
     * @return true if the request should be retried; false otherwise.
     */
    public abstract boolean shouldRetry(int retryCount, Response response);

    /**
     * Gets the name of the retry strategy.
     *
     * @return the name of the retry strategy.
     */
    public String getName() {
        return name;
    }

    /**
     * Gets whether the first retry attempt will be made immediately.
     *
     * @return true if the first retry attempt will be made immediately.
     *         false otherwise.
     */
    public boolean isFastFirstRetry() {
        return fastFirstRetry;
    }
}
