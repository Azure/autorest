// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Rest
{
    /// <summary>
    /// Credentials for use with a Azure Mobile Services.
    /// </summary>
    public class MobileServicesCredentials : ServiceClientCredentials
    {
        private const string ZumoAuthenticationHeader = "X-ZUMO-AUTH";
        /// <summary>
        /// Gets or sets secure token. 
        /// </summary>
        public string Token { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="MobileServicesCredentials"/>
        /// </summary>
        /// <param name="token">Valid token.</param>
        public MobileServicesCredentials(string token)
        {
            Token = token;
        }

        /// <summary>
        /// Apply Mobile Services token to the HTTP request.
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

            if (!request.Headers.Contains(ZumoAuthenticationHeader))
            {
                request.Headers.Add(ZumoAuthenticationHeader, Token);
            }
            return base.ProcessHttpRequestAsync(request, cancellationToken);
        }
    }
}
