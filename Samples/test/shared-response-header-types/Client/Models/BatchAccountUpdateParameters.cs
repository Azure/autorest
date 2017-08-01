// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace SharedHeaders.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Parameters for updating an Azure Batch account.
    /// </summary>
    public partial class BatchAccountUpdateParameters
    {
        /// <summary>
        /// Initializes a new instance of the BatchAccountUpdateParameters
        /// class.
        /// </summary>
        public BatchAccountUpdateParameters()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the BatchAccountUpdateParameters
        /// class.
        /// </summary>
        /// <param name="tags">The user-specified tags associated with the
        /// account.</param>
        public BatchAccountUpdateParameters(IDictionary<string, string> tags = default(IDictionary<string, string>))
        {
            Tags = tags;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the user-specified tags associated with the account.
        /// </summary>
        [JsonProperty(PropertyName = "tags")]
        public IDictionary<string, string> Tags { get; set; }

    }
}
