/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Defines values for AccountStatus.
 */
public enum AccountStatus {
    /** Enum value Available. */
    AVAILABLE("Available"),

    /** Enum value Unavailable. */
    UNAVAILABLE("Unavailable");

    /** The actual serialized value for a AccountStatus instance. */
    private String value;

    AccountStatus(String value) {
        this.value = value;
    }

    /**
     * Gets the serialized value for a AccountStatus instance.
     *
     * @return the serialized value.
     */
    @JsonValue
    public String toValue() {
        return this.value;
    }

    /**
     * Parses a serialized value to a AccountStatus instance.
     *
     * @param value the serialized value to parse.
     * @return the parsed AccountStatus object, or null if unable to parse.
     */
    @JsonCreator
    public static AccountStatus fromValue(String value) {
        AccountStatus[] items = AccountStatus.values();
        for (AccountStatus item : items) {
            if (item.toValue().equals(value)) {
                return item;
            }
        }
        return null;
    }

    @Override
    public String toString() {
        return toValue();
    }
}
