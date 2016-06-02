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


/**
 * Defines headers for putNoHeaderInRetry operation.
 */
public class LROsPutNoHeaderInRetryHeadersInner {
    /**
     * Location to poll for result status: will be set to
     * /lro/putasync/noheader/202/200/operationResults.
     */
    private String location;

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
     * @return the LROsPutNoHeaderInRetryHeadersInner object itself.
     */
    public LROsPutNoHeaderInRetryHeadersInner withLocation(String location) {
        this.location = location;
        return this;
    }

}
