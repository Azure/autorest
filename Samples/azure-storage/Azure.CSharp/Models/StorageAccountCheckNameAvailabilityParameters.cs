
namespace Petstore.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class StorageAccountCheckNameAvailabilityParameters
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountCheckNameAvailabilityParameters class.
        /// </summary>
        public StorageAccountCheckNameAvailabilityParameters() { }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountCheckNameAvailabilityParameters class.
        /// </summary>
        public StorageAccountCheckNameAvailabilityParameters(string name, string type = default(string))
        {
            Name = name;
            Type = type;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "type")]
        public string Type { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Name == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Name");
            }
        }
    }
}

