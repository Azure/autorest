namespace Fixtures.SwaggerBatHttp.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class D
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "httpStatusCode")]
        public string HttpStatusCode { get; set; }

    }
}
