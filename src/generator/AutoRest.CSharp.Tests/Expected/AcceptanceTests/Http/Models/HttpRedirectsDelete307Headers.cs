// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsHttp.Models
{
    using AcceptanceTestsHttp;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Defines headers for delete307 operation.
    /// </summary>
    public partial class HttpRedirectsDelete307Headers
    {
        /// <summary>
        /// Initializes a new instance of the HttpRedirectsDelete307Headers
        /// class.
        /// </summary>
        public HttpRedirectsDelete307Headers() { }

        /// <summary>
        /// Initializes a new instance of the HttpRedirectsDelete307Headers
        /// class.
        /// </summary>
        /// <param name="location">The redirect location for this request.
        /// Possible values include: '/http/success/delete/200'</param>
        public HttpRedirectsDelete307Headers(string location = default(string))
        {
            Location = location;
        }

        /// <summary>
        /// Gets or sets the redirect location for this request. Possible
        /// values include: '/http/success/delete/200'
        /// </summary>
        [JsonProperty(PropertyName = "Location")]
        public string Location { get; set; }

    }
}
