/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.lro.implementation.api;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines headers for delete202RetryInvalidHeader operation.
 */
public class LROSADsDelete202RetryInvalidHeaderHeadersInner {
    /**
     * Location to poll for result status: will be set to /foo.
     */
    @JsonProperty(value = "Location")
    private String location;

    /**
     * Number of milliseconds until the next poll should be sent, will be set
     * to /bar.
     */
    @JsonProperty(value = "Retry-After")
    private Integer retryAfter;

    /**
     * Get the location value.
     *
     * @return the location value
     */
    public String location() {
        return this.location;
    }

    /**
     * Set the location value.
     *
     * @param location the location value to set
     * @return the LROSADsDelete202RetryInvalidHeaderHeadersInner object itself.
     */
    public LROSADsDelete202RetryInvalidHeaderHeadersInner withLocation(String location) {
        this.location = location;
        return this;
    }

    /**
     * Get the retryAfter value.
     *
     * @return the retryAfter value
     */
    public Integer retryAfter() {
        return this.retryAfter;
    }

    /**
     * Set the retryAfter value.
     *
     * @param retryAfter the retryAfter value to set
     * @return the LROSADsDelete202RetryInvalidHeaderHeadersInner object itself.
     */
    public LROSADsDelete202RetryInvalidHeaderHeadersInner withRetryAfter(Integer retryAfter) {
        this.retryAfter = retryAfter;
        return this;
    }

}
