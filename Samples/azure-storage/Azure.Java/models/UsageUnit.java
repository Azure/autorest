/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Defines values for UsageUnit.
 */
public enum UsageUnit {
    /** Enum value Count. */
    COUNT("Count"),

    /** Enum value Bytes. */
    BYTES("Bytes"),

    /** Enum value Seconds. */
    SECONDS("Seconds"),

    /** Enum value Percent. */
    PERCENT("Percent"),

    /** Enum value CountsPerSecond. */
    COUNTS_PER_SECOND("CountsPerSecond"),

    /** Enum value BytesPerSecond. */
    BYTES_PER_SECOND("BytesPerSecond");

    /** The actual serialized value for a UsageUnit instance. */
    private String value;

    UsageUnit(String value) {
        this.value = value;
    }

    /**
     * Parses a serialized value to a UsageUnit instance.
     *
     * @param value the serialized value to parse.
     * @return the parsed UsageUnit object, or null if unable to parse.
     */
    @JsonCreator
    public static UsageUnit fromString(String value) {
        UsageUnit[] items = UsageUnit.values();
        for (UsageUnit item : items) {
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
