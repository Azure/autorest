/**
 */

package petstore.implementation;

import java.util.Map;
import petstore.StorageAccountPropertiesUpdateParameters;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The parameters to update on the account.
 */
public class StorageAccountUpdateParametersInner {
    /**
     * Resource tags.
     */
    @JsonProperty(value = "tags")
    private Map<String, String> tags;

    /**
     * The properties property.
     */
    @JsonProperty(value = "properties")
    private StorageAccountPropertiesUpdateParameters properties;

    /**
     * Get the tags value.
     *
     * @return the tags value
     */
    public Map<String, String> tags() {
        return this.tags;
    }

    /**
     * Set the tags value.
     *
     * @param tags the tags value to set
     * @return the StorageAccountUpdateParametersInner object itself.
     */
    public StorageAccountUpdateParametersInner withTags(Map<String, String> tags) {
        this.tags = tags;
        return this;
    }

    /**
     * Get the properties value.
     *
     * @return the properties value
     */
    public StorageAccountPropertiesUpdateParameters properties() {
        return this.properties;
    }

    /**
     * Set the properties value.
     *
     * @param properties the properties value to set
     * @return the StorageAccountUpdateParametersInner object itself.
     */
    public StorageAccountUpdateParametersInner withProperties(StorageAccountPropertiesUpdateParameters properties) {
        this.properties = properties;
        return this;
    }

}
