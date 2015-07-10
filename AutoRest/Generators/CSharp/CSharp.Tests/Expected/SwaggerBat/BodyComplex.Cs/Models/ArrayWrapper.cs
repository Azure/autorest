namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class ArrayWrapper
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "array")]
        public IList<string> Array { get; set; }

    }
}
