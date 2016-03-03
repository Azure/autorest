/**
 */

package petstore.models;

import java.util.Map;
import com.microsoft.azure.BaseResource;

/**
 * The parameters to update on the account.
 */
public class StorageAccountUpdateParameters extends BaseResource {
    /**
     * Resource tags.
     */
    private Map<String, String> tags;

    /**
     * The properties property.
     */
    private StorageAccountPropertiesUpdateParameters properties;

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
    public StorageAccountPropertiesUpdateParameters getProperties() {
        return this.properties;
    }

    /**
     * Set the properties value.
     *
     * @param properties the properties value to set
     */
    public void setProperties(StorageAccountPropertiesUpdateParameters properties) {
        this.properties = properties;
    }

}
