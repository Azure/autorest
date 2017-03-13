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
    /// Defines headers for post202RetryInvalidHeader operation.
    /// </summary>
    public partial class LROSADsPost202RetryInvalidHeaderHeadersInner
    {
        /// <summary>
        /// Initializes a new instance of the
        /// LROSADsPost202RetryInvalidHeaderHeadersInner class.
        /// </summary>
        public LROSADsPost202RetryInvalidHeaderHeadersInner()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// LROSADsPost202RetryInvalidHeaderHeadersInner class.
        /// </summary>
        /// <param name="location">Location to poll for result status: will be
        /// set to /foo</param>
        /// <param name="retryAfter">Number of milliseconds until the next poll
        /// should be sent, will be set to /bar</param>
        public LROSADsPost202RetryInvalidHeaderHeadersInner(string location = default(string), int? retryAfter = default(int?))
        {
            Location = location;
            RetryAfter = retryAfter;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets location to poll for result status: will be set to
        /// /foo
        /// </summary>
        [JsonProperty(PropertyName = "Location")]
        public string Location { get; set; }

        /// <summary>
        /// Gets or sets number of milliseconds until the next poll should be
        /// sent, will be set to /bar
        /// </summary>
        [JsonProperty(PropertyName = "Retry-After")]
        public int? RetryAfter { get; set; }

    }
}
