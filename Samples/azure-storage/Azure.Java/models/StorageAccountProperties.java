/**
 */

package petstore.models;

import org.joda.time.DateTime;

/**
 * The StorageAccountProperties model.
 */
public class StorageAccountProperties {
    /**
     * Gets the status of the storage account at the time the operation was
     * called. Possible values include: 'Creating', 'ResolvingDNS',
     * 'Succeeded'.
     */
    private ProvisioningState provisioningState;

    /**
     * Gets the type of the storage account. Possible values include:
     * 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS',
     * 'Premium_LRS'.
     */
    private AccountType accountType;

    /**
     * Gets the URLs that are used to perform a retrieval of a public blob,
     * queue or table object.Note that StandardZRS and PremiumLRS accounts
     * only return the blob endpoint.
     */
    private Endpoints primaryEndpoints;

    /**
     * Gets the location of the primary for the storage account.
     */
    private String primaryLocation;

    /**
     * Gets the status indicating whether the primary location of the storage
     * account is available or unavailable. Possible values include:
     * 'Available', 'Unavailable'.
     */
    private AccountStatus statusOfPrimary;

    /**
     * Gets the timestamp of the most recent instance of a failover to the
     * secondary location. Only the most recent timestamp is retained. This
     * element is not returned if there has never been a failover instance.
     * Only available if the accountType is StandardGRS or StandardRAGRS.
     */
    private DateTime lastGeoFailoverTime;

    /**
     * Gets the location of the geo replicated secondary for the storage
     * account. Only available if the accountType is StandardGRS or
     * StandardRAGRS.
     */
    private String secondaryLocation;

    /**
     * Gets the status indicating whether the secondary location of the
     * storage account is available or unavailable. Only available if the
     * accountType is StandardGRS or StandardRAGRS. Possible values include:
     * 'Available', 'Unavailable'.
     */
    private AccountStatus statusOfSecondary;

    /**
     * Gets the creation date and time of the storage account in UTC.
     */
    private DateTime creationTime;

    /**
     * Gets the user assigned custom domain assigned to this storage account.
     */
    private CustomDomain customDomain;

    /**
     * Gets the URLs that are used to perform a retrieval of a public blob,
     * queue or table object from the secondary location of the storage
     * account. Only available if the accountType is StandardRAGRS.
     */
    private Endpoints secondaryEndpoints;

    /**
     * Get the provisioningState value.
     *
     * @return the provisioningState value
     */
    public ProvisioningState provisioningState() {
        return this.provisioningState;
    }

    /**
     * Set the provisioningState value.
     *
     * @param provisioningState the provisioningState value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withProvisioningState(ProvisioningState provisioningState) {
        this.provisioningState = provisioningState;
        return this;
    }

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
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withAccountType(AccountType accountType) {
        this.accountType = accountType;
        return this;
    }

    /**
     * Get the primaryEndpoints value.
     *
     * @return the primaryEndpoints value
     */
    public Endpoints primaryEndpoints() {
        return this.primaryEndpoints;
    }

    /**
     * Set the primaryEndpoints value.
     *
     * @param primaryEndpoints the primaryEndpoints value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withPrimaryEndpoints(Endpoints primaryEndpoints) {
        this.primaryEndpoints = primaryEndpoints;
        return this;
    }

    /**
     * Get the primaryLocation value.
     *
     * @return the primaryLocation value
     */
    public String primaryLocation() {
        return this.primaryLocation;
    }

    /**
     * Set the primaryLocation value.
     *
     * @param primaryLocation the primaryLocation value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withPrimaryLocation(String primaryLocation) {
        this.primaryLocation = primaryLocation;
        return this;
    }

    /**
     * Get the statusOfPrimary value.
     *
     * @return the statusOfPrimary value
     */
    public AccountStatus statusOfPrimary() {
        return this.statusOfPrimary;
    }

    /**
     * Set the statusOfPrimary value.
     *
     * @param statusOfPrimary the statusOfPrimary value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withStatusOfPrimary(AccountStatus statusOfPrimary) {
        this.statusOfPrimary = statusOfPrimary;
        return this;
    }

    /**
     * Get the lastGeoFailoverTime value.
     *
     * @return the lastGeoFailoverTime value
     */
    public DateTime lastGeoFailoverTime() {
        return this.lastGeoFailoverTime;
    }

    /**
     * Set the lastGeoFailoverTime value.
     *
     * @param lastGeoFailoverTime the lastGeoFailoverTime value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withLastGeoFailoverTime(DateTime lastGeoFailoverTime) {
        this.lastGeoFailoverTime = lastGeoFailoverTime;
        return this;
    }

    /**
     * Get the secondaryLocation value.
     *
     * @return the secondaryLocation value
     */
    public String secondaryLocation() {
        return this.secondaryLocation;
    }

    /**
     * Set the secondaryLocation value.
     *
     * @param secondaryLocation the secondaryLocation value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withSecondaryLocation(String secondaryLocation) {
        this.secondaryLocation = secondaryLocation;
        return this;
    }

    /**
     * Get the statusOfSecondary value.
     *
     * @return the statusOfSecondary value
     */
    public AccountStatus statusOfSecondary() {
        return this.statusOfSecondary;
    }

    /**
     * Set the statusOfSecondary value.
     *
     * @param statusOfSecondary the statusOfSecondary value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withStatusOfSecondary(AccountStatus statusOfSecondary) {
        this.statusOfSecondary = statusOfSecondary;
        return this;
    }

    /**
     * Get the creationTime value.
     *
     * @return the creationTime value
     */
    public DateTime creationTime() {
        return this.creationTime;
    }

    /**
     * Set the creationTime value.
     *
     * @param creationTime the creationTime value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withCreationTime(DateTime creationTime) {
        this.creationTime = creationTime;
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
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withCustomDomain(CustomDomain customDomain) {
        this.customDomain = customDomain;
        return this;
    }

    /**
     * Get the secondaryEndpoints value.
     *
     * @return the secondaryEndpoints value
     */
    public Endpoints secondaryEndpoints() {
        return this.secondaryEndpoints;
    }

    /**
     * Set the secondaryEndpoints value.
     *
     * @param secondaryEndpoints the secondaryEndpoints value to set
     * @return the StorageAccountProperties object itself.
     */
    public StorageAccountProperties withSecondaryEndpoints(Endpoints secondaryEndpoints) {
        this.secondaryEndpoints = secondaryEndpoints;
        return this;
    }

}
