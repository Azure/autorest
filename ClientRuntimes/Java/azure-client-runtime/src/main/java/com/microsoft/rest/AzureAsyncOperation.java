/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.Arrays;
import java.util.List;

public class AzureAsyncOperation {
    static final int defaultDelay = 30;

    static final String successStatus = "Succeeded";

    static final String inProgressStatus = "InProgress";

    static final String failedStatus = "Failed";

    static final String canceledStatus = "Canceled";

    public static List<String> getFailedStatuses() {
        return Arrays.asList(failedStatus, canceledStatus);
    }

    public static List<String> getTerminalStatuses() {
        return Arrays.asList(failedStatus, canceledStatus, successStatus);
    }

    private String status;

    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    private CloudError error;

    public CloudError getError() {
        return this.error;
    }

    public void setError(CloudError error) {
        this.error = error;
    }

    private int retryAfter;

    public int getRetryAfter() {
        return this.retryAfter;
    }

    public void setRetryAfter(int retryAfter) {
        this.retryAfter = retryAfter;
    }
}
