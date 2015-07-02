namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    [JsonObject("fish")]    
    public partial class Fish
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "species")]
        public string Species { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "length")]
        public double? Length { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "siblings")]
        public IList<Fish> Siblings { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            if (Length == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Length");
            }
            if (this.Siblings != null)
            {
                foreach ( var element in this.Siblings)
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
