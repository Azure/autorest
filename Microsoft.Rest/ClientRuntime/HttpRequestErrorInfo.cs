// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Net.Http;

namespace Microsoft.Rest
{
    /// <summary>
    /// Describes HTTP requests associated with error conditions.
    /// </summary>
    public class HttpRequestErrorInfo
        : HttpErrorInfo
    {
        /// <summary>
        /// Initializes a new instance of the HttpRequestErrorInfo class.
        /// </summary>
        protected HttpRequestErrorInfo()
        {
            Properties = new Dictionary<string, object>();
        }

        /// <summary>
        /// Gets or sets the HTTP method used by the HTTP request message.
        /// </summary>
        public HttpMethod Method { get; protected set; }

        /// <summary>
        /// Gets or sets the Uri used for the HTTP request.
        /// </summary>
        public Uri RequestUri { get; protected set; }

        /// <summary>
        /// Gets a set of properties for the HTTP request.
        /// </summary>
        public IDictionary<string, object> Properties { get; private set; }

        /// <summary>
        /// Creates a new HttpRequestErrorInfo from a HttpRequestMessage.
        /// </summary>
        /// <param name="request">The request message.</param>
        /// <returns>A HttpRequestErrorInfo instance.</returns>
        public static HttpRequestErrorInfo Create(HttpRequestMessage request)
        {
            return Create(request, request.Content.AsString());
        }

        /// <summary>
        /// Creates a new HttpRequestErrorInfo from a HttpRequestMessage.
        /// </summary>
        /// <param name="request">The request message.</param>
        /// <param name="content">
        /// The request content, which may be passed separately if the request
        /// has already been disposed.
        /// </param>
        /// <returns>A HttpRequestErrorInfo instance.</returns>
        public static HttpRequestErrorInfo Create(HttpRequestMessage request, string content)
        {
            if (request == null)
            {
                throw new ArgumentNullException("request");
            }

            var errorInfo = new HttpRequestErrorInfo();

            // Copy HttpErrorInfo properties
            errorInfo.Content = content;
            errorInfo.CopyHeaders(request.Headers);
            errorInfo.CopyHeaders(request.GetContentHeaders());

            // Copy HttpRequestErrorInfo properties
            errorInfo.Method = request.Method;
            errorInfo.RequestUri = request.RequestUri;
            if (request.Properties != null)
            {
                foreach (KeyValuePair<string, object> pair in request.Properties)
                {
                    errorInfo.Properties[pair.Key] = pair.Value;
                }
            }

            return errorInfo;
        }
    }
}