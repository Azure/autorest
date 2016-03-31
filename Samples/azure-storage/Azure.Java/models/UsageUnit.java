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
    COUNTSPERSECOND("CountsPerSecond"),

    /** Enum value BytesPerSecond. */
    BYTESPERSECOND("BytesPerSecond");

    /** The actual serialized value for a UsageUnit instance. */
    private String value;

    UsageUnit(String value) {
        this.value = value;
    }

    /**
     * Gets the serialized value for a UsageUnit instance.
     *
     * @return the serialized value.
     */
    @JsonValue
    public String toValue() {
        return this.value;
    }

    /**
     * Parses a serialized value to a UsageUnit instance.
     *
     * @param value the serialized value to parse.
     * @return the parsed UsageUnit object, or null if unable to parse.
     */
    @JsonCreator
    public static UsageUnit fromValue(String value) {
        UsageUnit[] items = UsageUnit.values();
        for (UsageUnit item : items) {
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
