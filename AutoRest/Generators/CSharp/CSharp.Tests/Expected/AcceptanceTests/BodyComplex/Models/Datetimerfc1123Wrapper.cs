// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator 0.12.0.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsBodyComplex.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class Datetimerfc1123Wrapper
    {
        /// <summary>
        /// Initializes a new instance of the Datetimerfc1123Wrapper class.
        /// </summary>
        public Datetimerfc1123Wrapper() { }

        /// <summary>
        /// Initializes a new instance of the Datetimerfc1123Wrapper class.
        /// </summary>
        public Datetimerfc1123Wrapper(DateTime? field = default(DateTime?), DateTime? now = default(DateTime?))
        {
            Field = field;
            Now = now;
        }

        /// <summary>
        /// </summary>
        [JsonConverter(typeof(DateTimeRfc1123JsonConverter))]
        [JsonProperty(PropertyName = "field")]
        public DateTime? Field { get; set; }

        /// <summary>
        /// </summary>
        [JsonConverter(typeof(DateTimeRfc1123JsonConverter))]
        [JsonProperty(PropertyName = "now")]
        public DateTime? Now { get; set; }

    }
}
