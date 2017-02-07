
namespace Petstore.Models
{
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The parameters to update on the account.
    /// </summary>
    public partial class StorageAccountUpdateParameters : IResource
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccountUpdateParameters
        /// class.
        /// </summary>
        public StorageAccountUpdateParameters() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccountUpdateParameters
        /// class.
        /// </summary>
        /// <param name="tags">Resource tags</param>
        public StorageAccountUpdateParameters(IDictionary<string, string> tags = default(IDictionary<string, string>), StorageAccountPropertiesUpdateParameters properties = default(StorageAccountPropertiesUpdateParameters))
        {
            Tags = tags;
            Properties = properties;
        }

        /// <summary>
        /// Gets or sets resource tags
        /// </summary>
        [JsonProperty(PropertyName = "tags")]
        public IDictionary<string, string> Tags { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties")]
        public StorageAccountPropertiesUpdateParameters Properties { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Properties != null)
            {
                Properties.Validate();
            }
        }
    }
}

