// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AdditionalProperties.Models
{
    using Fixtures.AdditionalProperties;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    public partial class WithTypedDictionary
    {

        /// <summary>
        /// Initializes a new instance of the WithTypedDictionary class.
        /// </summary>
        /// <param name="additionalProperties">Unmatched properties from the
        /// message are deserialized this collection</param>
        public WithTypedDictionary(IDictionary<string, Feature> additionalProperties = default(IDictionary<string, Feature>), string abc = default(string))
        {
            AdditionalProperties = additionalProperties;
            Abc = abc;
        }

        /// <summary>
        /// Gets or sets unmatched properties from the message are deserialized
        /// this collection
        /// </summary>
        [JsonExtensionData]
        public IDictionary<string, Feature> AdditionalProperties { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "abc")]
        public string Abc { get; set; }

    }
}
