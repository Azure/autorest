// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsLro.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.AcceptanceTestsLro;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Defines headers for putNoHeaderInRetry operation.
    /// </summary>
    public partial class LROsPutNoHeaderInRetryHeaders
    {
        /// <summary>
        /// Initializes a new instance of the LROsPutNoHeaderInRetryHeaders
        /// class.
        /// </summary>
        public LROsPutNoHeaderInRetryHeaders()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the LROsPutNoHeaderInRetryHeaders
        /// class.
        /// </summary>
        /// <param name="location">Location to poll for result status: will be
        /// set to /lro/putasync/noheader/202/200/operationResults</param>
        public LROsPutNoHeaderInRetryHeaders(string location = default(string))
        {
            Location = location;
            CustomInit();
        }

        /// <summary>
        /// an Init method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets location to poll for result status: will be set to
        /// /lro/putasync/noheader/202/200/operationResults
        /// </summary>
        [JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

    }
}
