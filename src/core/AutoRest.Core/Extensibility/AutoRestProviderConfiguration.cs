// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using Newtonsoft.Json;
using YamlDotNet.Serialization;

namespace AutoRest.Core.Extensibility
{
    /// <summary>
    /// In-memory representation of provider configuration.
    /// </summary>
    public class AutoRestProviderConfiguration
    {
        /// <summary>
        /// Gets of sets provider name in 'type, assembly name' format.
        /// </summary>
        [YamlMember(Alias = "type")]
        [JsonProperty("type")]
        public string TypeName { get; set; }

        /// <summary>
        /// Gets of sets provider specific settings.
        /// </summary>
        [YamlMember(Alias = "settings")]
        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "Required for JSON serialization.")]
        public IDictionary<string, string> Settings { get; set; }
    }
}