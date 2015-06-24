namespace Fixtures.SwaggerBatRequiredOptional.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class ClassOptionalWrapper
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public Product Value { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            if (this.Value != null)
            {
                this.Value.Validate();
            }
        }
    }
}
