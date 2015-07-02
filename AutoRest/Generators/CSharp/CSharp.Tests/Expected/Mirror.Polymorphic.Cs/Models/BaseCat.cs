namespace Fixtures.MirrorPolymorphic.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class BaseCat : Animal
    {
        /// <summary>
        /// cat color
        /// </summary>
        [JsonProperty(PropertyName = "color")]
        public string Color { get; set; }

    }
}
