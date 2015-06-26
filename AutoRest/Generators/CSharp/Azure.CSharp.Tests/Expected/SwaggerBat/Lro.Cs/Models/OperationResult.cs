namespace Fixtures.Azure.SwaggerBatLro.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Azure;

    /// <summary>
    /// </summary>
    public partial class OperationResult
    {
        /// <summary>
        /// The status of the request. Possible values for this property
        /// include: &apos;Succeeded&apos;, &apos;Failed&apos;,
        /// &apos;canceled&apos;, &apos;Accepted&apos;, &apos;Creating&apos;,
        /// &apos;Created&apos;, &apos;Updating&apos;, &apos;Updated&apos;,
        /// &apos;Deleting&apos;, &apos;Deleted&apos;, &apos;OK&apos;
        /// </summary>
        [JsonProperty(PropertyName = "status")]
        public string Status { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "error")]
        public OperationResultError Error { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            if (this.Error != null)
            {
                this.Error.Validate();
            }
        }
    }
}
