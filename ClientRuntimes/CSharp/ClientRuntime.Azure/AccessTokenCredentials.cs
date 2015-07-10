// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Azure.Properties;
using Microsoft.Rest;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Azure
{
    /// <summary>
    /// Class for token based credentials.
    /// </summary>
    public class AccessTokenCredentials : ServiceClientCredentials
    {
        /// <summary>
        /// Gets or sets secure token used to authenticate against Microsoft Azure API. 
        /// No anonymous requests are allowed.
        /// </summary>
        private ITokenProvider TokenProvider { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="TokenCredentials"/>
        /// class with subscription ID.
        /// </summary>
        /// <param name="token">Valid JSON Web Token (JWT).</param>
        public AccessTokenCredentials(string token) : this(new StringTokenProvider(token))
        {
            if (string.IsNullOrEmpty(token))
            {
                throw new ArgumentNullException("token");
            }
        }

        /// <summary>
        /// Create an access token credentials object.
        /// </summary>
        /// <param name="tokenProvider">The access token provider to use</param>
        public AccessTokenCredentials(ITokenProvider tokenProvider)
        {
            if (tokenProvider == null)
            {
                throw new ArgumentNullException("tokenProvider");
            }

            this.TokenProvider = tokenProvider;
        }

        /// <summary>
        /// Apply the credentials to the HTTP request.
        /// </summary>
        /// <param name="request">The HTTP request.</param>
        /// <param name="cancellationToken">Cancellation token.</param>
        /// <returns>
        /// Task that will complete when processing has completed.
        /// </returns>
        public async override Task ProcessHttpRequestAsync(HttpRequestMessage request, 
            CancellationToken cancellationToken)
        {
            if (request == null)
            {
                throw new ArgumentNullException("request");
            }

            if (TokenProvider == null)
            {
                throw new InvalidOperationException(Resources.TokenProviderCannotBeNull);
            }

            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", await TokenProvider.GetAccessTokenAsync(cancellationToken).ConfigureAwait(false));
            await Task.Run(() => base.ProcessHttpRequestAsync(request, cancellationToken), cancellationToken);
        }
    }
}
