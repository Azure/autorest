namespace Fixtures.MirrorPolymorphic.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class SiameseCat : BaseCat
    {
        /// <summary>
        /// cat length
        /// </summary>
        [JsonProperty(PropertyName = "length")]
        public int? Length { get; set; }

    }
}
