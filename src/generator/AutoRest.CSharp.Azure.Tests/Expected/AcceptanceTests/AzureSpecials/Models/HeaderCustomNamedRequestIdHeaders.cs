// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsAzureSpecials.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.AcceptanceTestsAzureSpecials;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Defines headers for customNamedRequestId operation.
    /// </summary>
    public partial class HeaderCustomNamedRequestIdHeaders
    {

        /// <summary>
        /// Initializes a new instance of the HeaderCustomNamedRequestIdHeaders
        /// class.
        /// </summary>
        /// <param name="fooRequestId">Gets the foo-request-id.</param>
        public HeaderCustomNamedRequestIdHeaders(string fooRequestId = default(string))
        {
            FooRequestId = fooRequestId;
        }

        /// <summary>
        /// Gets the foo-request-id.
        /// </summary>
        [JsonProperty(PropertyName = "foo-request-id")]
        public string FooRequestId { get; set; }

    }
}
