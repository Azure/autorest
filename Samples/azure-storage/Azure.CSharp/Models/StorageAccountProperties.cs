
namespace Petstore.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Rest.Azure;

    public partial class StorageAccountProperties
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccountProperties class.
        /// </summary>
        public StorageAccountProperties() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccountProperties class.
        /// </summary>
        public StorageAccountProperties(ProvisioningState? provisioningState = default(ProvisioningState?), AccountType? accountType = default(AccountType?), Endpoints primaryEndpoints = default(Endpoints), string primaryLocation = default(string), AccountStatus? statusOfPrimary = default(AccountStatus?), DateTime? lastGeoFailoverTime = default(DateTime?), string secondaryLocation = default(string), AccountStatus? statusOfSecondary = default(AccountStatus?), DateTime? creationTime = default(DateTime?), CustomDomain customDomain = default(CustomDomain), Endpoints secondaryEndpoints = default(Endpoints))
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
        /// Gets or sets gets the status of the storage account at the time
        /// the operation was called. Possible values include: 'Creating',
        /// 'ResolvingDNS', 'Succeeded'
        /// </summary>
        [JsonProperty(PropertyName = "provisioningState")]
        public ProvisioningState? ProvisioningState { get; set; }

        /// <summary>
        /// Gets or sets gets the type of the storage account. Possible values
        /// include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
        /// 'Standard_RAGRS', 'Premium_LRS'
        /// </summary>
        [JsonProperty(PropertyName = "accountType")]
        public AccountType? AccountType { get; set; }

        /// <summary>
        /// Gets or sets gets the URLs that are used to perform a retrieval of
        /// a public blob, queue or table object.Note that StandardZRS and
        /// PremiumLRS accounts only return the blob endpoint.
        /// </summary>
        [JsonProperty(PropertyName = "primaryEndpoints")]
        public Endpoints PrimaryEndpoints { get; set; }

        /// <summary>
        /// Gets or sets gets the location of the primary for the storage
        /// account.
        /// </summary>
        [JsonProperty(PropertyName = "primaryLocation")]
        public string PrimaryLocation { get; set; }

        /// <summary>
        /// Gets or sets gets the status indicating whether the primary
        /// location of the storage account is available or unavailable.
        /// Possible values include: 'Available', 'Unavailable'
        /// </summary>
        [JsonProperty(PropertyName = "statusOfPrimary")]
        public AccountStatus? StatusOfPrimary { get; set; }

        /// <summary>
        /// Gets or sets gets the timestamp of the most recent instance of a
        /// failover to the secondary location. Only the most recent
        /// timestamp is retained. This element is not returned if there has
        /// never been a failover instance. Only available if the accountType
        /// is StandardGRS or StandardRAGRS.
        /// </summary>
        [JsonProperty(PropertyName = "lastGeoFailoverTime")]
        public DateTime? LastGeoFailoverTime { get; set; }

        /// <summary>
        /// Gets or sets gets the location of the geo replicated secondary for
        /// the storage account. Only available if the accountType is
        /// StandardGRS or StandardRAGRS.
        /// </summary>
        [JsonProperty(PropertyName = "secondaryLocation")]
        public string SecondaryLocation { get; set; }

        /// <summary>
        /// Gets or sets gets the status indicating whether the secondary
        /// location of the storage account is available or unavailable. Only
        /// available if the accountType is StandardGRS or StandardRAGRS.
        /// Possible values include: 'Available', 'Unavailable'
        /// </summary>
        [JsonProperty(PropertyName = "statusOfSecondary")]
        public AccountStatus? StatusOfSecondary { get; set; }

        /// <summary>
        /// Gets or sets gets the creation date and time of the storage
        /// account in UTC.
        /// </summary>
        [JsonProperty(PropertyName = "creationTime")]
        public DateTime? CreationTime { get; set; }

        /// <summary>
        /// Gets or sets gets the user assigned custom domain assigned to this
        /// storage account.
        /// </summary>
        [JsonProperty(PropertyName = "customDomain")]
        public CustomDomain CustomDomain { get; set; }

        /// <summary>
        /// Gets or sets gets the URLs that are used to perform a retrieval of
        /// a public blob, queue or table object from the secondary location
        /// of the storage account. Only available if the accountType is
        /// StandardRAGRS.
        /// </summary>
        [JsonProperty(PropertyName = "secondaryEndpoints")]
        public Endpoints SecondaryEndpoints { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
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
