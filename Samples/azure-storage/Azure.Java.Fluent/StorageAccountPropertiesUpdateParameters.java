/**
 */

package petstore;


/**
 * The StorageAccountPropertiesUpdateParameters model.
 */
public class StorageAccountPropertiesUpdateParameters {
    /**
     * Gets or sets the account type. Note that StandardZRS and PremiumLRS
     * accounts cannot be changed to other account types, and other account
     * types cannot be changed to StandardZRS or PremiumLRS. Possible values
     * include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
     * 'Standard_RAGRS', 'Premium_LRS'.
     */
    private AccountType accountType;

    /**
     * User domain assigned to the storage account. Name is the CNAME source.
     * Only one custom domain is supported per storage account at this time.
     * To clear the existing custom domain, use an empty string for the
     * custom domain name property.
     */
    private CustomDomain customDomain;

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
     * @return the StorageAccountPropertiesUpdateParameters object itself.
     */
    public StorageAccountPropertiesUpdateParameters withAccountType(AccountType accountType) {
        this.accountType = accountType;
        return this;
    }

    /**
     * Get the customDomain value.
     *
     * @return the customDomain value
     */
    public CustomDomain customDomain() {
        return this.customDomain;
    }

    /**
     * Set the customDomain value.
     *
     * @param customDomain the customDomain value to set
     * @return the StorageAccountPropertiesUpdateParameters object itself.
     */
    public StorageAccountPropertiesUpdateParameters withCustomDomain(CustomDomain customDomain) {
        this.customDomain = customDomain;
        return this;
    }

}
