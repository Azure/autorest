/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.retry;

import javax.ws.rs.client.ClientResponseContext;
import java.io.IOException;

public abstract class RetryStrategy {
    public static final int DEFAULT_CLIENT_RETRY_COUNT = 10;
    public static final int DEFAULT_RETRY_INTERVAL = 1000;
    public static final boolean DEFAULT_FIRST_FAST_RETRY = true;

    public String name;
    public boolean fastFirstRetry;

    protected RetryStrategy(String name, boolean firstFastRetry) {
        this.name = name;
        this.fastFirstRetry = firstFastRetry;
    }

    public abstract boolean shouldRetry(int retryCount, IOException exception);
}
