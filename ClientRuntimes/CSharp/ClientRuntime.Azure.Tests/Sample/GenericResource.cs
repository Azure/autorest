// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json;

namespace Microsoft.Azure
{
    /// <summary>
    /// Information for resource.
    /// </summary>
    public partial class GenericResource : Resource
    {
        /// <summary>
        /// Optional. Gets or sets the resource properties.
        /// </summary>
        [JsonProperty("properties")]
        public object Properties { get; set; }
    }
}
