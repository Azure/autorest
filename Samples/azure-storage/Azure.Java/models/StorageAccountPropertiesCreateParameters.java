/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The StorageAccountPropertiesCreateParameters model.
 */
public class StorageAccountPropertiesCreateParameters {
    /**
     * Gets or sets the account type. Possible values include: 'Standard_LRS',
     * 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'.
     */
    @JsonProperty(required = true)
    private AccountType accountType;

    /**
     * Get the accountType value.
     *
     * @return the accountType value
     */
    public AccountType accountType() {
        return this.accountType;
    }

    /**
     * Set the accountType value.
     *
     * @param accountType the accountType value to set
     * @return the StorageAccountPropertiesCreateParameters object itself.
     */
    public StorageAccountPropertiesCreateParameters withAccountType(AccountType accountType) {
        this.accountType = accountType;
        return this;
    }

}
