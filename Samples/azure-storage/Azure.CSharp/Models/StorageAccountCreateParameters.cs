
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// The parameters to provide for the account.
    /// </summary>
    public partial class StorageAccountCreateParameters : Microsoft.Rest.Azure.IResource
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
        /// <param name="location">Resource location</param>
        /// <param name="tags">Resource tags</param>
        public StorageAccountCreateParameters(string location, System.Collections.Generic.IDictionary<string, string> tags = default(System.Collections.Generic.IDictionary<string, string>), StorageAccountPropertiesCreateParameters properties = default(StorageAccountPropertiesCreateParameters))
        {
            Location = location;
            Tags = tags;
            Properties = properties;
        }

        /// <summary>
        /// Gets or sets resource location
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

        /// <summary>
        /// Gets or sets resource tags
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "tags")]
        public System.Collections.Generic.IDictionary<string, string> Tags { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties")]
        public StorageAccountPropertiesCreateParameters Properties { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Location == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "Location");
            }
            if (this.Properties != null)
            {
                this.Properties.Validate();
            }
        }
    }
}
