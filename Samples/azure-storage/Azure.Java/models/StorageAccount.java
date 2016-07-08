/**
 */

package petstore.models;

import com.microsoft.azure.Resource;

/**
 * The storage account.
 */
public class StorageAccount extends Resource {
    /**
     * The properties property.
     */
    private StorageAccountProperties properties;

    /**
     * Get the properties value.
     *
     * @return the properties value
     */
    public StorageAccountProperties properties() {
        return this.properties;
    }

    /**
     * Set the properties value.
     *
     * @param properties the properties value to set
     * @return the StorageAccount object itself.
     */
    public StorageAccount withProperties(StorageAccountProperties properties) {
        this.properties = properties;
        return this;
    }

}
