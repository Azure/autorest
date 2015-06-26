namespace Fixtures.Azure.SwaggerBatSubscriptionIdApiVersion.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Azure;

    /// <summary>
    /// </summary>
    public partial class SampleResourceGroup
    {
        /// <summary>
        /// resource group name
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// resource group location
        /// </summary>
        [JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            //Nothing to validate
        }
    }
}
