// Code generated by Microsoft (R) AutoRest Code Generator 1.1.0.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace advisor.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The details of the snoozed or dismissed rule; for example, the
    /// duration, name, and GUID associated with the rule.
    /// </summary>
    public partial class SuppressionContract : Resource
    {
        /// <summary>
        /// Initializes a new instance of the SuppressionContract class.
        /// </summary>
        public SuppressionContract()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the SuppressionContract class.
        /// </summary>
        /// <param name="id">The resource ID.</param>
        /// <param name="name">The name of the resource.</param>
        /// <param name="type">The type of the resource.</param>
        /// <param name="location">The location of the resource. This cannot be
        /// changed after the resource is created.</param>
        /// <param name="tags">The tags of the resource.</param>
        /// <param name="suppressionId">The GUID of the suppression.</param>
        /// <param name="ttl">The duration for which the suppression is
        /// valid.</param>
        public SuppressionContract(string id = default(string), string name = default(string), string type = default(string), string location = default(string), IDictionary<string, string> tags = default(IDictionary<string, string>), string suppressionId = default(string), string ttl = default(string))
            : base(id, name, type, location, tags)
        {
            SuppressionId = suppressionId;
            Ttl = ttl;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the GUID of the suppression.
        /// </summary>
        [JsonProperty(PropertyName = "suppressionId")]
        public string SuppressionId { get; set; }

        /// <summary>
        /// Gets or sets the duration for which the suppression is valid.
        /// </summary>
        [JsonProperty(PropertyName = "ttl")]
        public string Ttl { get; set; }

    }
}
