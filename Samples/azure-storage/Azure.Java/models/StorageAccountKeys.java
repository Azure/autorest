/**
 */

package petstore.models;


/**
 * The access keys for the storage account.
 */
public class StorageAccountKeys {
    /**
     * Gets the value of key 1.
     */
    private String key1;

    /**
     * Gets the value of key 2.
     */
    private String key2;

    /**
     * Get the key1 value.
     *
     * @return the key1 value
     */
    public String getKey1() {
        return this.key1;
    }

    /**
     * Set the key1 value.
     *
     * @param key1 the key1 value to set
     */
    public void setKey1(String key1) {
        this.key1 = key1;
    }

    /**
     * Get the key2 value.
     *
     * @return the key2 value
     */
    public String getKey2() {
        return this.key2;
    }

    /**
     * Set the key2 value.
     *
     * @param key2 the key2 value to set
     */
    public void setKey2(String key2) {
        this.key2 = key2;
    }

}
