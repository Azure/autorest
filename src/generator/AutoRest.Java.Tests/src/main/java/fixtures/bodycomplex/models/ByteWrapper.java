/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.bodycomplex.models;


/**
 * The ByteWrapper model.
 */
public class ByteWrapper {
    /**
     * The field property.
     */
    private byte[] field;

    /**
     * Get the field value.
     *
     * @return the field value
     */
    public byte[] field() {
        return this.field;
    }

    /**
     * Set the field value.
     *
     * @param field the field value to set
     * @return the ByteWrapper object itself.
     */
    public ByteWrapper withField(byte[] field) {
        this.field = field;
        return this;
    }

}
