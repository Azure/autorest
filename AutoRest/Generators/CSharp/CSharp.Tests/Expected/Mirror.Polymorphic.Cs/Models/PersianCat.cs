namespace Fixtures.MirrorPolymorphic.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class PersianCat : BaseCat
    {
        /// <summary>
        /// cat size
        /// </summary>
        [JsonProperty(PropertyName = "size")]
        public int? Size { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public override void Validate()
        {
            base.Validate();
        }
    }
}
