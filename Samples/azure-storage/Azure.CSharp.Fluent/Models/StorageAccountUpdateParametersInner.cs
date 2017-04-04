
namespace Petstore.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The parameters to update on the account.
    /// </summary>
    public partial class StorageAccountUpdateParametersInner
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountUpdateParametersInner class.
        /// </summary>
        public StorageAccountUpdateParametersInner()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountUpdateParametersInner class.
        /// </summary>
        /// <param name="tags">Resource tags</param>
        public StorageAccountUpdateParametersInner(IDictionary<string, string> tags = default(IDictionary<string, string>), StorageAccountPropertiesUpdateParameters properties = default(StorageAccountPropertiesUpdateParameters))
        {
            Tags = tags;
            Properties = properties;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

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
        /// <exception cref="Microsoft.Rest.ValidationException">
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
