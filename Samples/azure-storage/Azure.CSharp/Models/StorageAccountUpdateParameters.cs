
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// The parameters to update on the account.
    /// </summary>
    public partial class StorageAccountUpdateParameters : Microsoft.Rest.Azure.IResource
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
        public StorageAccountUpdateParameters(System.Collections.Generic.IDictionary<string, string> tags = default(System.Collections.Generic.IDictionary<string, string>), StorageAccountPropertiesUpdateParameters properties = default(StorageAccountPropertiesUpdateParameters))
        {
            Tags = tags;
            Properties = properties;
        }

        /// <summary>
        /// Gets or sets resource tags
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "tags")]
        public System.Collections.Generic.IDictionary<string, string> Tags { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties")]
        public StorageAccountPropertiesUpdateParameters Properties { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
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
