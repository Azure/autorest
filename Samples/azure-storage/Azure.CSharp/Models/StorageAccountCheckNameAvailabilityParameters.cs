
namespace Petstore.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Rest.Azure;

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
