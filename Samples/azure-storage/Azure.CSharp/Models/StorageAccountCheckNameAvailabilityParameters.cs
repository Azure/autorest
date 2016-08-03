
namespace Petstore.Models
{
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
        public StorageAccountCheckNameAvailabilityParameters(System.String name, System.String type = default(System.String))
        {
            Name = name;
            Type = type;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "name")]
        public System.String Name { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "type")]
        public System.String Type { get; set; }

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
