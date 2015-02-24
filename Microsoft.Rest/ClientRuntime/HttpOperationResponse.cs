// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Net;

namespace Microsoft.Rest
{
    /// <summary>
    /// Represents the base return type of all ServiceClient REST operations.
    /// </summary>
    public class HttpOperationResponse<T>
    {
        /// <summary>
        /// Initializes a new instance of HttpOperationResponse.
        /// </summary>
        public HttpOperationResponse()
        {
            Headers = new Dictionary<string, string>();
        }

        /// <summary>
        /// Gets the collection of HTTP response headers.
        /// </summary>
        public IDictionary<string, string> Headers { get; private set; }

        /// <summary>
        /// Gets or sets the response object.
        /// </summary>
        public T Body { get; set; }

        /// <summary>
        /// Gets or sets the status code of the HTTP response.
        /// </summary>
        public HttpStatusCode StatusCode { get; set; }
    }
}