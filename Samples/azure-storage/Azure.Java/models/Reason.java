/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Defines values for Reason.
 */
public enum Reason {
    /** Enum value AccountNameInvalid. */
    ACCOUNTNAMEINVALID("AccountNameInvalid"),

    /** Enum value AlreadyExists. */
    ALREADYEXISTS("AlreadyExists");

    /** The actual serialized value for a Reason instance. */
    private String value;

    Reason(String value) {
        this.value = value;
    }

    /**
     * Gets the serialized value for a Reason instance.
     *
     * @return the serialized value.
     */
    @JsonValue
    public String toValue() {
        return this.value;
    }

    /**
     * Parses a serialized value to a Reason instance.
     *
     * @param value the serialized value to parse.
     * @return the parsed Reason object, or null if unable to parse.
     */
    @JsonCreator
    public static Reason fromValue(String value) {
        Reason[] items = Reason.values();
        for (Reason item : items) {
            if (item.toValue().equals(value)) {
                return item;
            }
        }
        return null;
    }
}
