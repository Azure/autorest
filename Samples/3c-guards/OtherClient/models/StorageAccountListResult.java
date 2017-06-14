/**
 * Code generated by Microsoft (R) AutoRest Code Generator 1.1.0.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package storage.models;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The list storage accounts operation response.
 */
public class StorageAccountListResult {
    /**
     * Gets the list of storage accounts and their properties.
     */
    @JsonProperty(value = "value")
    private List<StorageAccount> value;

    /**
     * Get the value value.
     *
     * @return the value value
     */
    public List<StorageAccount> value() {
        return this.value;
    }

    /**
     * Set the value value.
     *
     * @param value the value value to set
     * @return the StorageAccountListResult object itself.
     */
    public StorageAccountListResult withValue(List<StorageAccount> value) {
        this.value = value;
        return this;
    }

}
