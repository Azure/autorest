// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Net;
using System.Net.Http;

namespace Microsoft.Rest
{
    /// <summary>
    /// Describes HTTP responses associated with error conditions.
    /// </summary>
    public class HttpResponseErrorInfo
        : HttpErrorInfo
    {
        /// <summary>
        /// Initializes a new instance of the HttpResponseErrorInfo class.
        /// </summary>
        protected HttpResponseErrorInfo()
        {
        }

        /// <summary>
        /// Gets or sets the status code of the HTTP response.
        /// </summary>
        public HttpStatusCode StatusCode { get; protected set; }

        /// <summary>
        /// Exposes the reason phrase, typically sent along with the status code. 
        /// </summary>
        public string ReasonPhrase { get; protected set; }

        /// <summary>
        /// Creates a new HttpResponseErrorInfo from an HttpResponseMessage.
        /// </summary>
        /// <param name="response">The response message.</param>
        /// <returns>A HttpResponseErrorInfo instance.</returns>
        public static HttpResponseErrorInfo Create(HttpResponseMessage response)
        {
            return Create(response, response.Content.AsString());
        }

        /// <summary>
        /// Creates a new HttpResponseErrorInfo from a HttpResponseMessage.
        /// </summary>
        /// <param name="response">The response message.</param>
        /// <param name="content">
        /// The response content, which may be passed separately if the
        /// response has already been disposed.
        /// </param>
        /// <returns>A HttpResponseErrorInfo instance.</returns>
        public static HttpResponseErrorInfo Create(HttpResponseMessage response, string content)
        {
            if (response == null)
            {
                throw new ArgumentNullException("response");
            }

            HttpResponseErrorInfo info = new HttpResponseErrorInfo();

            // Copy HttpErrorInfo properties.
            info.Content = content;
            info.CopyHeaders(response.Headers);
            info.CopyHeaders(response.GetContentHeaders());

            // Copy HttpResponseErrorInfo properties.
            info.StatusCode = response.StatusCode;
            info.ReasonPhrase = response.ReasonPhrase;

            return info;
        }
    }
}