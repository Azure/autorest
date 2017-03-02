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
    using System.Linq;

    public partial class Feature
    {
        /// <summary>
        /// Initializes a new instance of the Feature class.
        /// </summary>
        public Feature()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Feature class.
        /// </summary>
        public Feature(string foo = default(string), int? bar = default(int?))
        {
            Foo = foo;
            Bar = bar;
            CustomInit();
        }

        /// <summary>
        /// an Init method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "foo")]
        public string Foo { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "bar")]
        public int? Bar { get; set; }

    }
}
