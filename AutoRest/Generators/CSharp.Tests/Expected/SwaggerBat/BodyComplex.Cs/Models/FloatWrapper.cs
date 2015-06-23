namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class FloatWrapper
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "field1")]
        public double? Field1 { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "field2")]
        public double? Field2 { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            //Nothing to validate
        }
    }
}
