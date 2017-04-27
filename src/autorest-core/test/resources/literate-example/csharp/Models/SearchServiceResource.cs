// Code generated by Microsoft (R) AutoRest Code Generator 1.0.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Microsoft.Api.Mysample.Models
{
    using Microsoft.Api;
    using Microsoft.Api.Mysample;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Describes an Azure Search service and its current state.
    /// </summary>
    public partial class SearchServiceResource
    {
        /// <summary>
        /// Initializes a new instance of the SearchServiceResource class.
        /// </summary>
        public SearchServiceResource()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the SearchServiceResource class.
        /// </summary>
        /// <param name="id">The resource Id of the Azure Search
        /// service.</param>
        /// <param name="name">The name of the Search service.</param>
        /// <param name="location">The geographic location of the Search
        /// service.</param>
        /// <param name="tags">Tags to help categorize the Search service in
        /// the Azure Portal.</param>
        public SearchServiceResource(string id = default(string), string name = default(string), string location = default(string), IDictionary<string, string> tags = default(IDictionary<string, string>))
        {
            Id = id;
            Name = name;
            Location = location;
            Tags = tags;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets the resource Id of the Azure Search service.
        /// </summary>
        [JsonProperty(PropertyName = "id")]
        public string Id { get; private set; }

        /// <summary>
        /// Gets or sets the name of the Search service.
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the geographic location of the Search service.
        /// </summary>
        [JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

        /// <summary>
        /// Gets or sets tags to help categorize the Search service in the
        /// Azure Portal.
        /// </summary>
        [JsonProperty(PropertyName = "tags")]
        public IDictionary<string, string> Tags { get; set; }

    }
}
