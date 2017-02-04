// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsLro.Models
{
    using Azure;
    using AcceptanceTestsLro;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Defines headers for putNoHeaderInRetry operation.
    /// </summary>
    public partial class LROsPutNoHeaderInRetryHeadersInner
    {
        /// <summary>
        /// Initializes a new instance of the
        /// LROsPutNoHeaderInRetryHeadersInner class.
        /// </summary>
        public LROsPutNoHeaderInRetryHeadersInner() { }

        /// <summary>
        /// Initializes a new instance of the
        /// LROsPutNoHeaderInRetryHeadersInner class.
        /// </summary>
        /// <param name="location">Location to poll for result status: will be
        /// set to /lro/putasync/noheader/202/200/operationResults</param>
        public LROsPutNoHeaderInRetryHeadersInner(string location = default(string))
        {
            Location = location;
        }

        /// <summary>
        /// Gets or sets location to poll for result status: will be set to
        /// /lro/putasync/noheader/202/200/operationResults
        /// </summary>
        [JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

    }
}
