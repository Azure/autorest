/**
 */

package petstore.implementation;

import petstore.StorageAccountProperties;
import com.microsoft.azure.Resource;
import com.microsoft.azure.Resource;

/**
 * The storage account.
 */
public class StorageAccountInner extends Resource {
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
     * @return the StorageAccountInner object itself.
     */
    public StorageAccountInner withProperties(StorageAccountProperties properties) {
        this.properties = properties;
        return this;
    }

}
