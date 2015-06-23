namespace Fixtures.MirrorRecursiveTypes.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class Product
    {
        /// <summary>
        /// Unique identifier representing a specific product for a given
        /// latitude & longitude. For example, uberX in San Francisco will
        /// have a different product_id than uberX in Los Angeles.
        /// </summary>
        [JsonProperty(PropertyName = "product_id")]
        public string ProductId { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "parentProduct")]
        public Product ParentProduct { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "innerProducts")]
        public IList<Product> InnerProducts { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            if (this.ParentProduct != null)
            {
                this.ParentProduct.Validate();
            }
            if (this.InnerProducts != null)
            {
                foreach ( var element in this.InnerProducts)
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
