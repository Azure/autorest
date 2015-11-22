// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
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
    public partial class DateWrapper
    {
        /// <summary>
        /// Initializes a new instance of the DateWrapper class.
        /// </summary>
        public DateWrapper() { }

        /// <summary>
        /// Initializes a new instance of the DateWrapper class.
        /// </summary>
        public DateWrapper(DateTime? field = default(DateTime?), DateTime? leap = default(DateTime?))
        {
            Field = field;
            Leap = leap;
        }

        /// <summary>
        /// </summary>
        [JsonConverter(typeof(DateJsonConverter))]
        [JsonProperty(PropertyName = "field")]
        public DateTime? Field { get; set; }

        /// <summary>
        /// </summary>
        [JsonConverter(typeof(DateJsonConverter))]
        [JsonProperty(PropertyName = "leap")]
        public DateTime? Leap { get; set; }

    }
}
