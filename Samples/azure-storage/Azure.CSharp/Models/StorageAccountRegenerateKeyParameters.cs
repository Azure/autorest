
namespace Petstore.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class StorageAccountRegenerateKeyParameters
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountRegenerateKeyParameters class.
        /// </summary>
        public StorageAccountRegenerateKeyParameters() { }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountRegenerateKeyParameters class.
        /// </summary>
        public StorageAccountRegenerateKeyParameters(string keyName)
        {
            KeyName = keyName;
        }

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

