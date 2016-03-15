/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.requiredoptional.models;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The ClassWrapper model.
 */
public class ClassWrapper {
    /**
     * The value property.
     */
    @JsonProperty(required = true)
    private Product value;

    /**
     * Get the value value.
     *
     * @return the value value
     */
    public Product getValue() {
        return this.value;
    }

    /**
     * Set the value value.
     *
     * @param value the value value to set
     */
    public void setValue(Product value) {
        this.value = value;
    }

    /**
     * Set the value value.
     *
     * @param value the value value to set
     * @return the ClassWrapper object itself.
     */
    public ClassWrapper withValue(Product value) {
        this.value = value;
        return this;
    }

}
