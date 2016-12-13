/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.validation.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Defines values for String.
 */
public enum String {
    /** Enum value constant_string_as_enum. */
    constant_string_as_enum("constant_string_as_enum");

    /** The actual serialized value for a String instance. */
    private String value;

    String(String value) {
        this.value = value;
    }

    /**
     * Parses a serialized value to a String instance.
     *
     * @param value the serialized value to parse.
     * @return the parsed String object, or null if unable to parse.
     */
    @JsonCreator
    public static String fromString(String value) {
        String[] items = String.values();
        for (String item : items) {
            if (item.toString().equalsIgnoreCase(value)) {
                return item;
            }
        }
        return null;
    }

    @JsonValue
    @Override
    public String toString() {
        return this.value;
    }
}
