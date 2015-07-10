namespace Fixtures.SwaggerBatHttp.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class B : A
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "textStatusCode")]
        public string TextStatusCode { get; set; }

    }
}
