// This is my custom license header. I am a nice person so please don't steal
// my code.
//
// Cheers.

namespace AwesomeNamespace.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// The parameters used to regenerate the storage account key.
    /// </summary>
    public partial class StorageAccountRegenerateKeyParameters
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountRegenerateKeyParameters class.
        /// </summary>
        public StorageAccountRegenerateKeyParameters()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountRegenerateKeyParameters class.
        /// </summary>
        public StorageAccountRegenerateKeyParameters(string keyName)
        {
            KeyName = keyName;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "keyName")]
        public string KeyName { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (KeyName == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "KeyName");
            }
        }
    }
}
