/**
 */

package petstore.implementation;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The StorageAccountRegenerateKeyParametersInner model.
 */
public class StorageAccountRegenerateKeyParametersInner {
    /**
     * The keyName property.
     */
    @JsonProperty(required = true)
    private String keyName;

    /**
     * Get the keyName value.
     *
     * @return the keyName value
     */
    public String keyName() {
        return this.keyName;
    }

    /**
     * Set the keyName value.
     *
     * @param keyName the keyName value to set
     * @return the StorageAccountRegenerateKeyParametersInner object itself.
     */
    public StorageAccountRegenerateKeyParametersInner withKeyName(String keyName) {
        this.keyName = keyName;
        return this;
    }

}
