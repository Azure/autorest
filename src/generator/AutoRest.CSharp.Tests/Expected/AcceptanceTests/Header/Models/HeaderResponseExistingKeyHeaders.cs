// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
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
    /// Defines headers for responseExistingKey operation.
    /// </summary>
    public partial class HeaderResponseExistingKeyHeaders
    {
        /// <summary>
        /// Initializes a new instance of the HeaderResponseExistingKeyHeaders
        /// class.
        /// </summary>
        public HeaderResponseExistingKeyHeaders() { }

        /// <summary>
        /// Initializes a new instance of the HeaderResponseExistingKeyHeaders
        /// class.
        /// </summary>
        /// <param name="userAgent">response with header value "User-Agent":
        /// "overwrite"</param>
        public HeaderResponseExistingKeyHeaders(string userAgent = default(string))
        {
            UserAgent = userAgent;
        }

        /// <summary>
        /// Gets or sets response with header value "User-Agent": "overwrite"
        /// </summary>
        [JsonProperty(PropertyName = "User-Agent")]
        public string UserAgent { get; set; }

    }
}
