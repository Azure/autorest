// Code generated by Microsoft (R) AutoRest Code Generator 1.2.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Swagger.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Response containing the query API keys for a given Azure Search
    /// service.
    /// </summary>
    public partial class ListQueryKeysResult
    {
        /// <summary>
        /// Initializes a new instance of the ListQueryKeysResult class.
        /// </summary>
        public ListQueryKeysResult()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the ListQueryKeysResult class.
        /// </summary>
        /// <param name="value">&gt; Again, shorthand for `@.properties.value`
        ///
        /// The query keys for the Azure Search service.</param>
        public ListQueryKeysResult(IList<QueryKey> value = default(IList<QueryKey>))
        {
            Value = value;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets &amp;gt; Again, shorthand for `@.properties.value`
        ///
        /// The query keys for the Azure Search service.
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<QueryKey> Value { get; private set; }

    }
}
