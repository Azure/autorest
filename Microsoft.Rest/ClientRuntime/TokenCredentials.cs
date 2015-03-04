// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest;

namespace Microsoft.Azure
{
    /// <summary>
    /// Token based credentials for use with a REST Service Client.
    /// </summary>
    public class TokenCredentials : ServiceClientCredentials
    {
        /// <summary>
        /// Gets or sets secure token. 
        /// </summary>
        public string Token { get; set; }

        /// <summary>
        /// Gets or sets authentication scheme. 
        /// Default is Bearer.
        /// </summary>
        public string Scheme { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="TokenCredentials"/>
        /// class with scheme.
        /// </summary>
        /// <param name="scheme">Scheme to use. If null, defaults to Bearer.</param>
        /// <param name="token">Valid token.</param>
        public TokenCredentials(string scheme, string token)
        {
            if (string.IsNullOrEmpty(scheme))
            {
                scheme = "Bearer";
            }

            Scheme = scheme;
            Token = token;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="TokenCredentials"/>
        /// and defaults to Bearer scheme.
        /// </summary>
        /// <param name="token">Valid token.</param>
        public TokenCredentials(string token) : this(null, token)
        { }

        /// <summary>
        /// Apply the credentials to the HTTP request.
        /// </summary>
        /// <param name="request">The HTTP request.</param>
        /// <param name="cancellationToken">Cancellation token.</param>
        /// <returns>
        /// Task that will complete when processing has completed.
        /// </returns>
        public override Task ProcessHttpRequestAsync(HttpRequestMessage request, 
            CancellationToken cancellationToken)
        {
            if (request == null)
            {
                throw new ArgumentNullException("request");
            }

            request.Headers.Authorization = new AuthenticationHeaderValue(Scheme, Token);
            return base.ProcessHttpRequestAsync(request, cancellationToken);
        }
    }
}
