
namespace Petstore.Models
{
    using System.Linq;

    public partial class StorageAccountProperties
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccountProperties class.
        /// </summary>
        public StorageAccountProperties() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccountProperties class.
        /// </summary>
        /// <param name="provisioningState">Gets the status of the storage
        /// account at the time the operation was called. Possible values
        /// include: 'Creating', 'ResolvingDNS', 'Succeeded'</param>
        /// <param name="accountType">Gets the type of the storage account.
        /// Possible values include: 'Standard_LRS', 'Standard_ZRS',
        /// 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'</param>
        /// <param name="primaryEndpoints">Gets the URLs that are used to
        /// perform a retrieval of a public blob, queue or table object.Note
        /// that StandardZRS and PremiumLRS accounts only return the blob
        /// endpoint.</param>
        /// <param name="primaryLocation">Gets the location of the primary for
        /// the storage account.</param>
        /// <param name="statusOfPrimary">Gets the status indicating whether
        /// the primary location of the storage account is available or
        /// unavailable. Possible values include: 'Available',
        /// 'Unavailable'</param>
        /// <param name="lastGeoFailoverTime">Gets the timestamp of the most
        /// recent instance of a failover to the secondary location. Only the
        /// most recent timestamp is retained. This element is not returned
        /// if there has never been a failover instance. Only available if
        /// the accountType is StandardGRS or StandardRAGRS.</param>
        /// <param name="secondaryLocation">Gets the location of the geo
        /// replicated secondary for the storage account. Only available if
        /// the accountType is StandardGRS or StandardRAGRS.</param>
        /// <param name="statusOfSecondary">Gets the status indicating whether
        /// the secondary location of the storage account is available or
        /// unavailable. Only available if the accountType is StandardGRS or
        /// StandardRAGRS. Possible values include: 'Available',
        /// 'Unavailable'</param>
        /// <param name="creationTime">Gets the creation date and time of the
        /// storage account in UTC.</param>
        /// <param name="customDomain">Gets the user assigned custom domain
        /// assigned to this storage account.</param>
        /// <param name="secondaryEndpoints">Gets the URLs that are used to
        /// perform a retrieval of a public blob, queue or table object from
        /// the secondary location of the storage account. Only available if
        /// the accountType is StandardRAGRS.</param>
        public StorageAccountProperties(ProvisioningState? provisioningState = default(ProvisioningState?), AccountType? accountType = default(AccountType?), Endpoints primaryEndpoints = default(Endpoints), string primaryLocation = default(string), AccountStatus? statusOfPrimary = default(AccountStatus?), System.DateTime? lastGeoFailoverTime = default(System.DateTime?), string secondaryLocation = default(string), AccountStatus? statusOfSecondary = default(AccountStatus?), System.DateTime? creationTime = default(System.DateTime?), CustomDomain customDomain = default(CustomDomain), Endpoints secondaryEndpoints = default(Endpoints))
        {
            ProvisioningState = provisioningState;
            AccountType = accountType;
            PrimaryEndpoints = primaryEndpoints;
            PrimaryLocation = primaryLocation;
            StatusOfPrimary = statusOfPrimary;
            LastGeoFailoverTime = lastGeoFailoverTime;
            SecondaryLocation = secondaryLocation;
            StatusOfSecondary = statusOfSecondary;
            CreationTime = creationTime;
            CustomDomain = customDomain;
            SecondaryEndpoints = secondaryEndpoints;
        }

        /// <summary>
        /// Gets the status of the storage account at the time the operation
        /// was called. Possible values include: 'Creating', 'ResolvingDNS',
        /// 'Succeeded'
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "provisioningState")]
        public ProvisioningState? ProvisioningState { get; set; }

        /// <summary>
        /// Gets the type of the storage account. Possible values include:
        /// 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS',
        /// 'Premium_LRS'
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "accountType")]
        public AccountType? AccountType { get; set; }

        /// <summary>
        /// Gets the URLs that are used to perform a retrieval of a public
        /// blob, queue or table object.Note that StandardZRS and PremiumLRS
        /// accounts only return the blob endpoint.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "primaryEndpoints")]
        public Endpoints PrimaryEndpoints { get; set; }

        /// <summary>
        /// Gets the location of the primary for the storage account.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "primaryLocation")]
        public string PrimaryLocation { get; set; }

        /// <summary>
        /// Gets the status indicating whether the primary location of the
        /// storage account is available or unavailable. Possible values
        /// include: 'Available', 'Unavailable'
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "statusOfPrimary")]
        public AccountStatus? StatusOfPrimary { get; set; }

        /// <summary>
        /// Gets the timestamp of the most recent instance of a failover to
        /// the secondary location. Only the most recent timestamp is
        /// retained. This element is not returned if there has never been a
        /// failover instance. Only available if the accountType is
        /// StandardGRS or StandardRAGRS.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "lastGeoFailoverTime")]
        public System.DateTime? LastGeoFailoverTime { get; set; }

        /// <summary>
        /// Gets the location of the geo replicated secondary for the storage
        /// account. Only available if the accountType is StandardGRS or
        /// StandardRAGRS.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "secondaryLocation")]
        public string SecondaryLocation { get; set; }

        /// <summary>
        /// Gets the status indicating whether the secondary location of the
        /// storage account is available or unavailable. Only available if
        /// the accountType is StandardGRS or StandardRAGRS. Possible values
        /// include: 'Available', 'Unavailable'
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "statusOfSecondary")]
        public AccountStatus? StatusOfSecondary { get; set; }

        /// <summary>
        /// Gets the creation date and time of the storage account in UTC.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "creationTime")]
        public System.DateTime? CreationTime { get; set; }

        /// <summary>
        /// Gets the user assigned custom domain assigned to this storage
        /// account.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "customDomain")]
        public CustomDomain CustomDomain { get; set; }

        /// <summary>
        /// Gets the URLs that are used to perform a retrieval of a public
        /// blob, queue or table object from the secondary location of the
        /// storage account. Only available if the accountType is
        /// StandardRAGRS.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "secondaryEndpoints")]
        public Endpoints SecondaryEndpoints { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (this.CustomDomain != null)
            {
                this.CustomDomain.Validate();
            }
        }
    }
}
