/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.header.models;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines headers for responseProtectedKey operation.
 */
public class HeaderResponseProtectedKeyHeaders {
    /**
     * response with header value "Content-Type": "text/html".
     */
    @JsonProperty(value = "Content-Type")
    private String contentType;

    /**
     * Get the contentType value.
     *
     * @return the contentType value
     */
    public String contentType() {
        return this.contentType;
    }

    /**
     * Set the contentType value.
     *
     * @param contentType the contentType value to set
     * @return the HeaderResponseProtectedKeyHeaders object itself.
     */
    public HeaderResponseProtectedKeyHeaders withContentType(String contentType) {
        this.contentType = contentType;
        return this;
    }

}
