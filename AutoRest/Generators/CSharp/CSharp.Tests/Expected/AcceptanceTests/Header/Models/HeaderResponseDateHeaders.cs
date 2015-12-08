// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsHeader.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// Defines headers for responseDate operation.
    /// </summary>
    public partial class HeaderResponseDateHeaders
    {
        /// <summary>
        /// Initializes a new instance of the HeaderResponseDateHeaders class.
        /// </summary>
        public HeaderResponseDateHeaders() { }

        /// <summary>
        /// Initializes a new instance of the HeaderResponseDateHeaders class.
        /// </summary>
        public HeaderResponseDateHeaders(DateTime? value = default(DateTime?))
        {
            Value = value;
        }

        /// <summary>
        /// response with header values "2010-01-01" or "0001-01-01"
        /// </summary>
        [JsonConverter(typeof(DateJsonConverter))]
        [JsonProperty(PropertyName = "value")]
        public DateTime? Value { get; set; }

    }
}
