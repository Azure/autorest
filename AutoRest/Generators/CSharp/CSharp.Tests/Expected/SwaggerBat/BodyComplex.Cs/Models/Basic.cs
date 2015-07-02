namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class Basic
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "id")]
        public int? Id { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Possible values for this property include: 'cyan', 'Magenta',
        /// 'YELLOW', 'blacK'
        /// </summary>
        [JsonProperty(PropertyName = "color")]
        public CMYKColors? Color { get; set; }

    }
}
