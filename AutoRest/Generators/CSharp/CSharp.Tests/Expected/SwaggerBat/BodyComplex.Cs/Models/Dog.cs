namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class Dog : Pet
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "food")]
        public string Food { get; set; }

    }
}
