// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Diagnostics.CodeAnalysis;
using Newtonsoft.Json;

namespace Microsoft.Rest.Azure
{
    /// <summary>
    /// Defines Azure sub-resource.
    /// </summary>
    public class SubResource
    {
        /// <summary>
        /// Gets the ID of the sub-resource.
        /// </summary>
        [JsonProperty("id")]
        public string Id { get; set; }
    }
}
