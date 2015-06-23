using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Microsoft.Rest;
using Microsoft.Rest.Serialization;
using Microsoft.Azure;

namespace Fixtures.Azure.SwaggerBatPaging.Models
{
    /// <summary>
    /// </summary>
    public partial class OperationResultError
    {
        /// <summary>
        /// The error code for an operation failure
        /// </summary>
        [JsonProperty(PropertyName = "code")]
        public int? Code { get; set; }

        /// <summary>
        /// The detailed arror message
        /// </summary>
        [JsonProperty(PropertyName = "message")]
        public string Message { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            //Nothing to validate
        }
    }
}
