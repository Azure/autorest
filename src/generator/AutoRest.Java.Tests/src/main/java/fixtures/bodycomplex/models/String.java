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

import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Defines values for String.
 */
public final class String {
    /** Static value cyan for String. */
    public static final String cyan = new String("cyan");

    /** Static value Magenta for String. */
    public static final String Magenta = new String("Magenta");

    /** Static value YELLOW for String. */
    public static final String YELLOW = new String("YELLOW");

    /** Static value blacK for String. */
    public static final String blacK = new String("blacK");

    private String value;

    /**
     * Creates a custom value for String.
     * @param value the custom value
     */
    public String(String value) {
        this.value = value;
    }

    @JsonValue
    @Override
    public String toString() {
        return value;
    }

    @Override
    public int hashCode() {
        return value.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof String)) {
            return false;
        }
        if (obj == this) {
            return true;
        }
        String rhs = (String) obj;
        if (value == null) {
            return rhs.value == null;
        } else {
            return value.equals(rhs.value);
        }
    }
}
