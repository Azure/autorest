// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;

namespace Microsoft.Rest.Generator.Extensibility
{
    /// <summary>
    /// In-memory representation of AutoRest.json configuration.
    /// </summary>
    public class AutoRestConfiguration
    {
        /// <summary>
        /// Gets or sets collections of CodeGenerators.
        /// </summary>
        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "Required for JSON serialization.")]
        public IDictionary<string, AutoRestProviderConfiguration> CodeGenerators { get; set; }

        /// <summary>
        /// Gets or sets collections of Modelers.
        /// </summary>
        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "Required for JSON serialization.")]
        public IDictionary<string, AutoRestProviderConfiguration> Modelers { get; set; }
    }
}