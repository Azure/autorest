namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class Cat : Pet
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "color")]
        public string Color { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "hates")]
        public IList<Dog> Hates { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public override void Validate()
        {
            base.Validate();
            if (this.Hates != null)
            {
                foreach ( var element in this.Hates)
            {
                if (element != null)
            {
                element.Validate();
            }
            }
            }
        }
    }
}
