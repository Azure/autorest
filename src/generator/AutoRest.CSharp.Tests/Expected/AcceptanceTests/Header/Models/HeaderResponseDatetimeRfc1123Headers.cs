// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsHeader.Models
{
    using Fixtures.AcceptanceTestsHeader;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Defines headers for responseDatetimeRfc1123 operation.
    /// </summary>
    public partial class HeaderResponseDatetimeRfc1123Headers
    {

        /// <summary>
        /// Initializes a new instance of the
        /// HeaderResponseDatetimeRfc1123Headers class.
        /// </summary>
        /// <param name="value">response with header values "Wed, 01 Jan 2010
        /// 12:34:56 GMT" or "Mon, 01 Jan 0001 00:00:00 GMT"</param>
        public HeaderResponseDatetimeRfc1123Headers(System.DateTime? value = default(System.DateTime?))
        {
            Value = value;
        }

        /// <summary>
        /// Gets or sets response with header values "Wed, 01 Jan 2010 12:34:56
        /// GMT" or "Mon, 01 Jan 0001 00:00:00 GMT"
        /// </summary>
        [JsonConverter(typeof(DateTimeRfc1123JsonConverter))]
        [JsonProperty(PropertyName = "value")]
        public System.DateTime? Value { get; set; }

    }
}
