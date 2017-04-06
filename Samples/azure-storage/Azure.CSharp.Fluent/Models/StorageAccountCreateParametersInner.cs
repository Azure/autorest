
namespace Petstore.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The parameters to provide for the account.
    /// </summary>
    public partial class StorageAccountCreateParametersInner
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountCreateParametersInner class.
        /// </summary>
        public StorageAccountCreateParametersInner()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountCreateParametersInner class.
        /// </summary>
        /// <param name="location">Resource location</param>
        /// <param name="tags">Resource tags</param>
        public StorageAccountCreateParametersInner(string location, IDictionary<string, string> tags = default(IDictionary<string, string>), StorageAccountPropertiesCreateParameters properties = default(StorageAccountPropertiesCreateParameters))
        {
            Location = location;
            Tags = tags;
            Properties = properties;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets resource location
        /// </summary>
        [JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

        /// <summary>
        /// Gets or sets resource tags
        /// </summary>
        [JsonProperty(PropertyName = "tags")]
        public IDictionary<string, string> Tags { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties")]
        public StorageAccountPropertiesCreateParameters Properties { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Location == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Location");
            }
            if (Properties != null)
            {
                Properties.Validate();
            }
        }
    }
}
