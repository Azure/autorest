/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The StorageAccountRegenerateKeyParameters model.
 */
public class StorageAccountRegenerateKeyParameters {
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
    public String getKeyName() {
        return this.keyName;
    }

    /**
     * Set the keyName value.
     *
     * @param keyName the keyName value to set
     */
    public void setKeyName(String keyName) {
        this.keyName = keyName;
    }

}
