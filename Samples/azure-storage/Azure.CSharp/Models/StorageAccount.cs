
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
    /// The storage account.
    /// </summary>
    public partial class StorageAccount : Resource
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccount class.
        /// </summary>
        public StorageAccount() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccount class.
        /// </summary>
        public StorageAccount(string id = default(string), string name = default(string), string type = default(string), string location = default(string), IDictionary<string, string> tags = default(IDictionary<string, string>), StorageAccountProperties properties = default(StorageAccountProperties))
            : base(id, name, type, location, tags)
        {
            Properties = properties;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties")]
        public StorageAccountProperties Properties { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (this.Properties != null)
            {
                this.Properties.Validate();
            }
        }
    }
}
