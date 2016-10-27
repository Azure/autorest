
namespace Petstore.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		
    using Microsoft.Rest.Azure;		

    /// <summary>
    /// The storage account.
    /// </summary>
    public partial class StorageAccountInner : Microsoft.Rest.Azure.Resource
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccountInner class.
        /// </summary>
        public StorageAccountInner() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccountInner class.
        /// </summary>
        public StorageAccountInner(string location = default(string), string id = default(string), string name = default(string), string type = default(string), System.Collections.Generic.IDictionary<string, string> tags = default(System.Collections.Generic.IDictionary<string, string>), StorageAccountProperties properties = default(StorageAccountProperties))
            : base(location, id, name, type, tags)
        {
            Properties = properties;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties")]
        public StorageAccountProperties Properties { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (this.Properties != null)
            {
                this.Properties.Validate();
            }
        }
    }
}
