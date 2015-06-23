namespace Fixtures.Azure.SwaggerBatPaging.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Azure;

    /// <summary>
    /// </summary>
    public partial class ProductResult
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "values")]
        public IList<Product> Values { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "nextLink")]
        public string NextLink { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            if (this.Values != null)
            {
                foreach ( var element in this.Values)
            {
                if (element != null)
            {
                element.Validate();
            }
            }
            }
        }
    }
}
