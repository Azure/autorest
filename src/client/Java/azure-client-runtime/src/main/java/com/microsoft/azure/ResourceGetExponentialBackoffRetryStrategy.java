/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import com.microsoft.rest.retry.RetryStrategy;
import okhttp3.Response;

/**
 * A retry strategy with backoff parameters for calculating the exponential
 * delay between retries for 404s from GET calls.
 */
public class ResourceGetExponentialBackoffRetryStrategy extends RetryStrategy {
    /**
     * Represents the default number of retries.
     */
    private static final int DEFAULT_NUMBER_OF_ATTEMPTS = 3;

    /**
     * Creates an instance of the retry strategy.
     */
    public ResourceGetExponentialBackoffRetryStrategy() {
        this(null, DEFAULT_FIRST_FAST_RETRY);
    }

    /**
     * Initializes a new instance of the {@link RetryStrategy} class.
     *
     * @param name           The name of the retry strategy.
     * @param firstFastRetry true to immediately retry in the first attempt; otherwise, false.
     */
    private ResourceGetExponentialBackoffRetryStrategy(String name, boolean firstFastRetry) {
        super(name, firstFastRetry);
    }

    @Override
    public boolean shouldRetry(int retryCount, Response response) {
        int code = response.code();
        //CHECKSTYLE IGNORE MagicNumber FOR NEXT 2 LINES
        return retryCount < DEFAULT_NUMBER_OF_ATTEMPTS
                && code == 404
                && response.request().method().equalsIgnoreCase("GET");
    }
}
