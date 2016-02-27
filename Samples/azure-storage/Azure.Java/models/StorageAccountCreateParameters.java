/**
 */

package petstore.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Map;
import com.microsoft.azure.BaseResource;

/**
 * The parameters to provide for the account.
 */
public class StorageAccountCreateParameters extends BaseResource {
    /**
     * Resource location.
     */
    @JsonProperty(required = true)
    private String location;

    /**
     * Resource tags.
     */
    private Map<String, String> tags;

    /**
     * Gets or sets the account type. Possible values include: 'Standard_LRS',
     * 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'.
     */
    @JsonProperty(value = "properties.accountType", required = true)
    private AccountType accountType;

    /**
     * Get the location value.
     *
     * @return the location value
     */
    public String getLocation() {
        return this.location;
    }

    /**
     * Set the location value.
     *
     * @param location the location value to set
     */
    public void setLocation(String location) {
        this.location = location;
    }

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
     * Get the accountType value.
     *
     * @return the accountType value
     */
    public AccountType getAccountType() {
        return this.accountType;
    }

    /**
     * Set the accountType value.
     *
     * @param accountType the accountType value to set
     */
    public void setAccountType(AccountType accountType) {
        this.accountType = accountType;
    }

}
