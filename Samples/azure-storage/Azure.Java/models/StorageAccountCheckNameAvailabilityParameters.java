/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The StorageAccountCheckNameAvailabilityParameters model.
 */
public class StorageAccountCheckNameAvailabilityParameters {
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
    public String getName() {
        return this.name;
    }

    /**
     * Set the name value.
     *
     * @param name the name value to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Get the type value.
     *
     * @return the type value
     */
    public String getType() {
        return this.type;
    }

    /**
     * Set the type value.
     *
     * @param type the type value to set
     */
    public void setType(String type) {
        this.type = type;
    }

}
