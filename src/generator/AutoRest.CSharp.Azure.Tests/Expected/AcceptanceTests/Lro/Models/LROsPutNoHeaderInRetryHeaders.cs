// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsLro.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		
    using Microsoft.Rest.Azure;		

    /// <summary>
    /// Defines headers for putNoHeaderInRetry operation.
    /// </summary>
    public partial class LROsPutNoHeaderInRetryHeaders
    {
        /// <summary>
        /// Initializes a new instance of the LROsPutNoHeaderInRetryHeaders
        /// class.
        /// </summary>
        public LROsPutNoHeaderInRetryHeaders() { }

        /// <summary>
        /// Initializes a new instance of the LROsPutNoHeaderInRetryHeaders
        /// class.
        /// </summary>
        /// <param name="location">Location to poll for result status: will be
        /// set to /lro/putasync/noheader/202/200/operationResults</param>
        public LROsPutNoHeaderInRetryHeaders(string location = default(string))
        {
            Location = location;
        }

        /// <summary>
        /// Gets or sets location to poll for result status: will be set to
        /// /lro/putasync/noheader/202/200/operationResults
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

    }
}
