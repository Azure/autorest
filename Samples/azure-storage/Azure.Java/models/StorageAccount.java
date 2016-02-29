/**
 */

package petstore.models;


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
    public StorageAccountProperties getProperties() {
        return this.properties;
    }

    /**
     * Set the properties value.
     *
     * @param properties the properties value to set
     */
    public void setProperties(StorageAccountProperties properties) {
        this.properties = properties;
    }

}
