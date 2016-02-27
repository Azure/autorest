
namespace Petstore.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Rest.Azure;

    /// <summary>
    /// The parameters to provide for the account.
    /// </summary>
    public partial class StorageAccountCreateParameters : IResource
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccountCreateParameters
        /// class.
        /// </summary>
        public StorageAccountCreateParameters() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccountCreateParameters
        /// class.
        /// </summary>
        public StorageAccountCreateParameters(string location, AccountType accountType, IDictionary<string, string> tags = default(IDictionary<string, string>))
        {
            Location = location;
            Tags = tags;
            AccountType = accountType;
        }

        /// <summary>
        /// Resource location
        /// </summary>
        [JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

        /// <summary>
        /// Resource tags
        /// </summary>
        [JsonProperty(PropertyName = "tags")]
        public IDictionary<string, string> Tags { get; set; }

        /// <summary>
        /// Gets or sets the account type. Possible values include:
        /// 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS',
        /// 'Premium_LRS'
        /// </summary>
        [JsonProperty(PropertyName = "properties.accountType")]
        public AccountType AccountType { get; set; }

        /// <summary>
        /// Validate the object. Throws ValidationException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            if (Location == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Location");
            }
        }
    }
}
