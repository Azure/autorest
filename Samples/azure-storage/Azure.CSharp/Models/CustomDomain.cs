
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
    /// The custom domain assigned to this storage account. This can be set
    /// via Update.
    /// </summary>
    public partial class CustomDomain
    {
        /// <summary>
        /// Initializes a new instance of the CustomDomain class.
        /// </summary>
        public CustomDomain() { }

        /// <summary>
        /// Initializes a new instance of the CustomDomain class.
        /// </summary>
        public CustomDomain(string name, bool? useSubDomain = default(bool?))
        {
            Name = name;
            UseSubDomain = useSubDomain;
        }

        /// <summary>
        /// Gets or sets gets or sets the custom domain name. Name is the
        /// CNAME source.
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets indicates whether indirect CName validation is
        /// enabled. Default value is false. This should only be set on
        /// updates
        /// </summary>
        [JsonProperty(PropertyName = "useSubDomain")]
        public bool? UseSubDomain { get; set; }

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
