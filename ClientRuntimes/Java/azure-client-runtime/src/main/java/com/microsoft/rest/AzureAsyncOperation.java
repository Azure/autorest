/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import java.util.Arrays;
import java.util.List;

/**
 * The response body contains the status of the specified
 * asynchronous operation, indicating whether it has succeeded, is in
 * progress, or has failed. Note that this status is distinct from the
 * HTTP status code returned for the Get Operation Status operation
 * itself.  If the asynchronous operation succeeded, the response body
 * includes the HTTP status code for the successful request.  If the
 * asynchronous operation failed, the response body includes the HTTP
 * status code for the failed request, and also includes error
 * information regarding the failure.
 */
public class AzureAsyncOperation {
    /**
     * Default delay in seconds for long running operations.
     */
    static final int defaultDelay = 30;

    /**
     * Successful status for long running operations.
     */
    static final String successStatus = "Succeeded";

    /**
     * In progress status for long running operations.
     */
    static final String inProgressStatus = "InProgress";

    /**
     * Failed status for long running operations.
     */
    static final String failedStatus = "Failed";

    /**
     * Canceled status for long running operations.
     */
    static final String canceledStatus = "Canceled";

    /**
     * Gets failed terminal statuses for long running operations.
     *
     * @return a list of statuses indicating a failed operation.
     */
    public static List<String> getFailedStatuses() {
        return Arrays.asList(failedStatus, canceledStatus);
    }

    /**
     * Gets terminal statuses for long running operations.
     *
     * @return a list of terminal statuses.
     */
    public static List<String> getTerminalStatuses() {
        return Arrays.asList(failedStatus, canceledStatus, successStatus);
    }

    /**
     * The status of the asynchronous request.
     */
    private String status;

    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * If the asynchronous operation failed, the response body includes
     * the HTTP status code for the failed request, and also includes
     * error information regarding the failure.
     */
    private CloudError error;

    public CloudError getError() {
        return this.error;
    }

    public void setError(CloudError error) {
        this.error = error;
    }

    /**
     * Gets or sets the delay in seconds that should be used when checking
     * for the status of the operation.
     */
    private int retryAfter;

    public int getRetryAfter() {
        return this.retryAfter;
    }

    public void setRetryAfter(int retryAfter) {
        this.retryAfter = retryAfter;
    }
}
