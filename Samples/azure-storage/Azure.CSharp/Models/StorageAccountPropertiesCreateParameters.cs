
namespace Petstore.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Rest.Azure;

    public partial class StorageAccountPropertiesCreateParameters
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountPropertiesCreateParameters class.
        /// </summary>
        public StorageAccountPropertiesCreateParameters() { }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountPropertiesCreateParameters class.
        /// </summary>
        public StorageAccountPropertiesCreateParameters(AccountType accountType)
        {
            AccountType = accountType;
        }

        /// <summary>
        /// Gets or sets gets or sets the account type. Possible values
        /// include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
        /// 'Standard_RAGRS', 'Premium_LRS'
        /// </summary>
        [JsonProperty(PropertyName = "accountType")]
        public AccountType AccountType { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
        }
    }
}
