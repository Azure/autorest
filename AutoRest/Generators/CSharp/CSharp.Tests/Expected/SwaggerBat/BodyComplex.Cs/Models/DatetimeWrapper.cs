namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class DatetimeWrapper
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "field")]
        public DateTime? Field { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "now")]
        public DateTime? Now { get; set; }

    }
}
