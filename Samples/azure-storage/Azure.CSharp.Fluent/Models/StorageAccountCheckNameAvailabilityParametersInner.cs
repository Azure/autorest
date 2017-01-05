
namespace Petstore.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class StorageAccountCheckNameAvailabilityParametersInner
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountCheckNameAvailabilityParametersInner class.
        /// </summary>
        public StorageAccountCheckNameAvailabilityParametersInner() { }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountCheckNameAvailabilityParametersInner class.
        /// </summary>
        public StorageAccountCheckNameAvailabilityParametersInner(string name, string type = default(string))
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
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Name == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "Name");
            }
        }
    }
}

