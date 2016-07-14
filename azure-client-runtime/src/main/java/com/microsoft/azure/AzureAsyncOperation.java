/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

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
    static final int DEFAULT_DELAY = 30;

    /**
     * Successful status for long running operations.
     */
    static final String SUCCESS_STATUS = "Succeeded";

    /**
     * In progress status for long running operations.
     */
    static final String IN_PROGRESS_STATUS = "InProgress";

    /**
     * Failed status for long running operations.
     */
    static final String FAILED_STATUS = "Failed";

    /**
     * Canceled status for long running operations.
     */
    static final String CANCELED_STATUS = "Canceled";

    /**
     * Gets failed terminal statuses for long running operations.
     *
     * @return a list of statuses indicating a failed operation.
     */
    public static List<String> getFailedStatuses() {
        return Arrays.asList(FAILED_STATUS, CANCELED_STATUS);
    }

    /**
     * Gets terminal statuses for long running operations.
     *
     * @return a list of terminal statuses.
     */
    public static List<String> getTerminalStatuses() {
        return Arrays.asList(FAILED_STATUS, CANCELED_STATUS, SUCCESS_STATUS);
    }

    /**
     * The status of the asynchronous request.
     */
    private String status;

    /**
     * Gets the status of the asynchronous request.
     *
     * @return the status of the asynchronous request.
     */
    public String getStatus() {
        return this.status;
    }

    /**
     * Sets the status of the asynchronous request.
     *
     * @param status the status of the asynchronous request.
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * If the asynchronous operation failed, the response body includes
     * the HTTP status code for the failed request, and also includes
     * error information regarding the failure.
     */
    private CloudError error;

    /**
     * Gets the cloud error.
     *
     * @return the cloud error.
     */
    public CloudError getError() {
        return this.error;
    }

    /**
     * Sets the cloud error.
     *
     * @param error the cloud error.
     */
    public void setError(CloudError error) {
        this.error = error;
    }

    /**
     * The delay in seconds that should be used when checking
     * for the status of the operation.
     */
    private int retryAfter;

    /**
     * Gets the delay in seconds.
     *
     * @return the delay in seconds.
     */
    public int getRetryAfter() {
        return this.retryAfter;
    }

    /**
     * Sets the delay in seconds.
     *
     * @param retryAfter the delay in seconds.
     */
    public void setRetryAfter(int retryAfter) {
        this.retryAfter = retryAfter;
    }
}
