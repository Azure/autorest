namespace Fixtures.Azure.SwaggerBatResourceFlattening.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Azure;

    /// <summary>
    /// </summary>
    public partial class FlattenedProduct : Resource
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "pname")]
        public string Pname { get; set; }

        /// <summary>
        /// Possible values for this property include: &apos;Succeeded&apos;,
        /// &apos;Failed&apos;, &apos;canceled&apos;, &apos;Accepted&apos;,
        /// &apos;Creating&apos;, &apos;Created&apos;, &apos;Updating&apos;,
        /// &apos;Updated&apos;, &apos;Deleting&apos;, &apos;Deleted&apos;,
        /// &apos;OK&apos;
        /// </summary>
        [JsonProperty(PropertyName = "provisioningStateValues")]
        public string ProvisioningStateValues { get; private set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public override void Validate()
        {
            base.Validate();
        }
    }
}
