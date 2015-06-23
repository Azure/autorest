namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class StringWrapper
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "field")]
        public string Field { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "empty")]
        public string Empty { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "null")]
        public string NullProperty { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            //Nothing to validate
        }
    }
}
