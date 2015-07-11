// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json;

namespace Microsoft.Azure
{
    /// <summary>
    /// Information for resource.
    /// </summary>
    public partial class SampleResource : Resource
    {
        /// <summary>
        /// Optional. Gets or sets the size of the resource.
        /// </summary>
        [JsonProperty("properties.size")]
        public string Size { get; set; }

        /// <summary>
        /// Optional. Gets or sets the child resource.
        /// </summary>
        [JsonProperty("properties.child")]
        public SampleResourceChild Child { get; set; }

        /// <summary>
        /// Optional. Gets or sets the details.
        /// </summary>
        [JsonProperty("properties.name")]
        public dynamic Details { get; set; }

        /// <summary>
        /// Optional. Gets or sets the plan.
        /// </summary>
        [JsonProperty("plan")]
        public string Plan { get; set; }
    }

    /// <summary>
    /// Information for resource.
    /// </summary>
    public abstract class SampleResourceChild : SubResource
    {
    }

    /// <summary>
    /// Information for resource.
    /// </summary>
    public partial class SampleResourceChild1 : SampleResourceChild
    {
        /// <summary>
        /// Optional. Gets or sets the Id of the resource.
        /// </summary>
        [JsonProperty("properties.name1")]
        public string ChildName1 { get; set; }
    }

    /// <summary>
    /// Information for resource.
    /// </summary>
    public partial class SampleResourceChild2 : SampleResourceChild
    {
        /// <summary>
        /// Optional. Gets or sets the Id of the resource.
        /// </summary>
        [JsonProperty("properties.name2")]
        public string ChildName2 { get; set; }
    }

    /// <summary>
    /// Information for resource.
    /// </summary>
    public partial class SampleResourceWithConflict : Resource
    {
        /// <summary>
        /// Optional. Gets or sets the special location of the resource.
        /// </summary>
        [JsonProperty("properties.location")]
        public string SampleResourceWithConflictLocation { get; set; }

        /// <summary>
        /// Optional. Gets or sets the special id resource.
        /// </summary>
        [JsonProperty("properties.id")]
        public string SampleResourceWithConflictId { get; set; }
    }
}
