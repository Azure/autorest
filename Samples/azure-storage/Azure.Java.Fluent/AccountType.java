/**
 */

package petstore;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Defines values for AccountType.
 */
public enum AccountType {
    /** Enum value Standard_LRS. */
    STANDARD_LRS("Standard_LRS"),

    /** Enum value Standard_ZRS. */
    STANDARD_ZRS("Standard_ZRS"),

    /** Enum value Standard_GRS. */
    STANDARD_GRS("Standard_GRS"),

    /** Enum value Standard_RAGRS. */
    STANDARD_RAGRS("Standard_RAGRS"),

    /** Enum value Premium_LRS. */
    PREMIUM_LRS("Premium_LRS");

    /** The actual serialized value for a AccountType instance. */
    private String value;

    AccountType(String value) {
        this.value = value;
    }

    /**
     * Parses a serialized value to a AccountType instance.
     *
     * @param value the serialized value to parse.
     * @return the parsed AccountType object, or null if unable to parse.
     */
    @JsonCreator
    public static AccountType fromString(String value) {
        AccountType[] items = AccountType.values();
        for (AccountType item : items) {
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
