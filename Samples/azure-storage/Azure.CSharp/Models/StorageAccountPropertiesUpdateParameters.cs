
namespace Petstore.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Rest.Azure;

    public partial class StorageAccountPropertiesUpdateParameters
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountPropertiesUpdateParameters class.
        /// </summary>
        public StorageAccountPropertiesUpdateParameters() { }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountPropertiesUpdateParameters class.
        /// </summary>
        public StorageAccountPropertiesUpdateParameters(AccountType? accountType = default(AccountType?), CustomDomain customDomain = default(CustomDomain))
        {
            AccountType = accountType;
            CustomDomain = customDomain;
        }

        /// <summary>
        /// Gets or sets gets or sets the account type. Note that StandardZRS
        /// and PremiumLRS accounts cannot be changed to other account types,
        /// and other account types cannot be changed to StandardZRS or
        /// PremiumLRS. Possible values include: 'Standard_LRS',
        /// 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
        /// </summary>
        [JsonProperty(PropertyName = "accountType")]
        public AccountType? AccountType { get; set; }

        /// <summary>
        /// Gets or sets user domain assigned to the storage account. Name is
        /// the CNAME source. Only one custom domain is supported per storage
        /// account at this time. To clear the existing custom domain, use an
        /// empty string for the custom domain name property.
        /// </summary>
        [JsonProperty(PropertyName = "customDomain")]
        public CustomDomain CustomDomain { get; set; }

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
