/**
 * Code generated by Microsoft (R) AutoRest Code Generator 1.2.2.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package streamwithcontenttype.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Defines values for ImageType.
 */
public enum ImageType {
    /** Enum value image/gif. */
    IMAGEGIF("image/gif"),

    /** Enum value image/jpeg. */
    IMAGEJPEG("image/jpeg"),

    /** Enum value image/png. */
    IMAGEPNG("image/png"),

    /** Enum value image/bmp. */
    IMAGEBMP("image/bmp"),

    /** Enum value image/tiff. */
    IMAGETIFF("image/tiff");

    /** The actual serialized value for a ImageType instance. */
    private String value;

    ImageType(String value) {
        this.value = value;
    }

    /**
     * Parses a serialized value to a ImageType instance.
     *
     * @param value the serialized value to parse.
     * @return the parsed ImageType object, or null if unable to parse.
     */
    @JsonCreator
    public static ImageType fromString(String value) {
        ImageType[] items = ImageType.values();
        for (ImageType item : items) {
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
