namespace Fixtures.MirrorPolymorphic.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class HimalayanCat : SiameseCat
    {
        /// <summary>
        /// cat hair length
        /// </summary>
        [JsonProperty(PropertyName = "hairLength")]
        public int? HairLength { get; set; }

    }
}
