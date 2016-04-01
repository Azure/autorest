/**
 */

package petstore.models;

import java.util.Map;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The parameters to provide for the account.
 */
public class StorageAccountCreateParameters {
    /**
     * Resource location.
     */
    @JsonProperty(required = true)
    private String location;

    /**
     * Resource tags.
     */
    private Map<String, String> tags;

    /**
     * The properties property.
     */
    private StorageAccountPropertiesCreateParameters properties;

    /**
     * Get the location value.
     *
     * @return the location value
     */
    public String getLocation() {
        return this.location;
    }

    /**
     * Set the location value.
     *
     * @param location the location value to set
     */
    public void setLocation(String location) {
        this.location = location;
    }

    /**
     * Get the tags value.
     *
     * @return the tags value
     */
    public Map<String, String> getTags() {
        return this.tags;
    }

    /**
     * Set the tags value.
     *
     * @param tags the tags value to set
     */
    public void setTags(Map<String, String> tags) {
        this.tags = tags;
    }

    /**
     * Get the properties value.
     *
     * @return the properties value
     */
    public StorageAccountPropertiesCreateParameters getProperties() {
        return this.properties;
    }

    /**
     * Set the properties value.
     *
     * @param properties the properties value to set
     */
    public void setProperties(StorageAccountPropertiesCreateParameters properties) {
        this.properties = properties;
    }

}
