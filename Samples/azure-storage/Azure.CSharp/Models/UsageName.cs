
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
    /// The Usage Names.
    /// </summary>
    public partial class UsageName
    {
        /// <summary>
        /// Initializes a new instance of the UsageName class.
        /// </summary>
        public UsageName() { }

        /// <summary>
        /// Initializes a new instance of the UsageName class.
        /// </summary>
        /// <param name="value">Gets a string describing the resource
        /// name.</param>
        /// <param name="localizedValue">Gets a localized string describing
        /// the resource name.</param>
        public UsageName(string value = default(string), string localizedValue = default(string))
        {
            Value = value;
            LocalizedValue = localizedValue;
        }

        /// <summary>
        /// Gets a string describing the resource name.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "value")]
        public string Value { get; set; }

        /// <summary>
        /// Gets a localized string describing the resource name.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "localizedValue")]
        public string LocalizedValue { get; set; }

    }
}
