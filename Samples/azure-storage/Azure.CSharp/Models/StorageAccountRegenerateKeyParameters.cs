
namespace Petstore.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		
    using Microsoft.Rest.Azure;		

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
        [Newtonsoft.Json.JsonProperty(PropertyName = "keyName")]
        public string KeyName { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (KeyName == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "KeyName");
            }
        }
    }
}
