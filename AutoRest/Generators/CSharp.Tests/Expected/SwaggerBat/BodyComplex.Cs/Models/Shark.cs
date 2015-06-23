namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    [JsonObject("shark")]    
    public partial class Shark : Fish
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "age")]
        public int? Age { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "birthday")]
        public DateTime? Birthday { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public override void Validate()
        {
            base.Validate();
            if (Birthday == null)
            {
                throw new ArgumentNullException("Birthday");
            }
        }
    }
}
