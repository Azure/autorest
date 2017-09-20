// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The Resource model definition.
    /// </summary>
    public partial class ResourceUpdate
    {
        /// <summary>
        /// Initializes a new instance of the ResourceUpdate class.
        /// </summary>
        public ResourceUpdate()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the ResourceUpdate class.
        /// </summary>
        /// <param name="tags">Resource tags</param>
        public ResourceUpdate(IDictionary<string, string> tags = default(IDictionary<string, string>), DiskSku sku = default(DiskSku))
        {
            Tags = tags;
            Sku = sku;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets resource tags
        /// </summary>
        [JsonProperty(PropertyName = "tags")]
        public IDictionary<string, string> Tags { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "sku")]
        public DiskSku Sku { get; set; }

    }
}
