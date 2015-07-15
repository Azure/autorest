namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class DictionaryWrapper
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "defaultProgram")]
        public IDictionary<string, string> DefaultProgram { get; set; }

    }
}
