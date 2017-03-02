// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsPaging.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.AcceptanceTestsPaging;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Additional parameters for the Paging_GetMultiplePagesWithOffset
    /// operation.
    /// </summary>
    public partial class PagingGetMultiplePagesWithOffsetOptionsInner
    {
        /// <summary>
        /// Initializes a new instance of the
        /// PagingGetMultiplePagesWithOffsetOptionsInner class.
        /// </summary>
        public PagingGetMultiplePagesWithOffsetOptionsInner()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// PagingGetMultiplePagesWithOffsetOptionsInner class.
        /// </summary>
        /// <param name="offset">Offset of return value</param>
        /// <param name="maxresults">Sets the maximum number of items to return
        /// in the response.</param>
        /// <param name="timeout">Sets the maximum time that the server can
        /// spend processing the request, in seconds. The default is 30
        /// seconds.</param>
        public PagingGetMultiplePagesWithOffsetOptionsInner(int offset, int? maxresults = default(int?), int? timeout = default(int?))
        {
            Maxresults = maxresults;
            Offset = offset;
            Timeout = timeout;
            CustomInit();
        }

        /// <summary>
        /// an Init method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets sets the maximum number of items to return in the
        /// response.
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public int? Maxresults { get; set; }

        /// <summary>
        /// Gets or sets offset of return value
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public int Offset { get; set; }

        /// <summary>
        /// Gets or sets sets the maximum time that the server can spend
        /// processing the request, in seconds. The default is 30 seconds.
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public int? Timeout { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            //Nothing to validate
        }
    }
}
