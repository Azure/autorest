/**
 */

package petstore.implementation;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The StorageAccountCheckNameAvailabilityParametersInner model.
 */
public class StorageAccountCheckNameAvailabilityParametersInner {
    /**
     * The name property.
     */
    @JsonProperty(required = true)
    private String name;

    /**
     * The type property.
     */
    private String type;

    /**
     * Get the name value.
     *
     * @return the name value
     */
    public String name() {
        return this.name;
    }

    /**
     * Set the name value.
     *
     * @param name the name value to set
     * @return the StorageAccountCheckNameAvailabilityParametersInner object itself.
     */
    public StorageAccountCheckNameAvailabilityParametersInner withName(String name) {
        this.name = name;
        return this;
    }

    /**
     * Get the type value.
     *
     * @return the type value
     */
    public String type() {
        return this.type;
    }

    /**
     * Set the type value.
     *
     * @param type the type value to set
     * @return the StorageAccountCheckNameAvailabilityParametersInner object itself.
     */
    public StorageAccountCheckNameAvailabilityParametersInner withType(String type) {
        this.type = type;
        return this;
    }

}
