// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsAzureCompositeModelClient.Models
{
    using Fixtures.AcceptanceTestsAzureCompositeModelClient;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class Datetimerfc1123Wrapper
    {

        /// <summary>
        /// Initializes a new instance of the Datetimerfc1123Wrapper class.
        /// </summary>
        public Datetimerfc1123Wrapper(System.DateTime? field = default(System.DateTime?), System.DateTime? now = default(System.DateTime?))
        {
            Field = field;
            Now = now;
        }

        /// <summary>
        /// </summary>
        [JsonConverter(typeof(DateTimeRfc1123JsonConverter))]
        [JsonProperty(PropertyName = "field")]
        public System.DateTime? Field { get; set; }

        /// <summary>
        /// </summary>
        [JsonConverter(typeof(DateTimeRfc1123JsonConverter))]
        [JsonProperty(PropertyName = "now")]
        public System.DateTime? Now { get; set; }

    }
}
