/**
 */

package petstore.models;

import java.util.Map;
import com.fasterxml.jackson.annotation.JsonProperty;
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
     * Gets or sets the account type. Note that StandardZRS and PremiumLRS
     * accounts cannot be changed to other account types, and other account
     * types cannot be changed to StandardZRS or PremiumLRS. Possible values
     * include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
     * 'Standard_RAGRS', 'Premium_LRS'.
     */
    @JsonProperty(value = "properties.accountType")
    private AccountType accountType;

    /**
     * User domain assigned to the storage account. Name is the CNAME source.
     * Only one custom domain is supported per storage account at this time.
     * To clear the existing custom domain, use an empty string for the
     * custom domain name property.
     */
    @JsonProperty(value = "properties.customDomain")
    private CustomDomain customDomain;

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

    /**
     * Get the customDomain value.
     *
     * @return the customDomain value
     */
    public CustomDomain getCustomDomain() {
        return this.customDomain;
    }

    /**
     * Set the customDomain value.
     *
     * @param customDomain the customDomain value to set
     */
    public void setCustomDomain(CustomDomain customDomain) {
        this.customDomain = customDomain;
    }

}
