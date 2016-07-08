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
     * Parses a serialized value to a AccountStatus instance.
     *
     * @param value the serialized value to parse.
     * @return the parsed AccountStatus object, or null if unable to parse.
     */
    @JsonCreator
    public static AccountStatus fromString(String value) {
        AccountStatus[] items = AccountStatus.values();
        for (AccountStatus item : items) {
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
