// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsHttp.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// Defines headers for post303 operation.
    /// </summary>
    public partial class HttpRedirectsPost303Headers
    {
        /// <summary>
        /// Initializes a new instance of the HttpRedirectsPost303Headers
        /// class.
        /// </summary>
        public HttpRedirectsPost303Headers() { }

        /// <summary>
        /// Initializes a new instance of the HttpRedirectsPost303Headers
        /// class.
        /// </summary>
        public HttpRedirectsPost303Headers(string location = default(string))
        {
            Location = location;
        }

        /// <summary>
        /// Gets or sets the redirect location for this request
        /// </summary>
        [JsonProperty(PropertyName = "Location")]
        public string Location { get; set; }

    }
}
