// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest;
using Microsoft.Rest.Azure.Authentication.Properties;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// Provides tokens for Azure Active Directory applications. 
    /// </summary>
    public class ActiveDirectoryApplicationTokenProvider : ITokenProvider
    {
        private AuthenticationContext _authenticationContext;
        private string _tokenAudience;
        private ClientCredential _credential;

        /// <summary>
        /// Initializes a token provider for application credentials.
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> 
        /// for detailed instructions on creating an Azure Active Directory application.
        /// </summary>
        /// <param name="clientId">The client Id of the application in Active Directory.</param>
        /// <param name="domain">The domain or tenant id for the application.</param>
        /// <param name="secret">The application secret, used for authentication.</param>
        /// <param name="environment">The Azure environment to manage resources in.</param>
        public ActiveDirectoryApplicationTokenProvider(string clientId, string domain, string secret, ActiveDirectoryEnvironment environment)
            : this(clientId, domain, secret, environment, cache: null)
        {
        }

        /// <summary>
        /// Initializes a token provider for application credentials.
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> 
        /// for detailed instructions on creating an Azure Active Directory application.
        /// </summary>
        /// <param name="clientId">The client Id of the application in Active Directory.</param>
        /// <param name="domain">The domain or tenant id for the application.</param>
        /// <param name="secret">The application secret, used for authentication.</param>
        /// <param name="environment">The Azure environment to manage resources in.</param>
        /// <param name="cache">The ADAL token cache to use during authentication.</param>
        public ActiveDirectoryApplicationTokenProvider(string clientId, string domain, string secret, ActiveDirectoryEnvironment environment, TokenCache cache) 
        {
            Initialize(clientId, domain, secret, environment, cache);
        }

        /// <summary>
        /// Returns the token type of the returned token.
        /// </summary>
        public string TokenType { get; private set; }

        /// <summary>
        /// Gets an access token from the token cache or from AD authentication endpoint. 
        /// Attempts to refresh the access token if it has expired.
        /// </summary>
        public virtual async Task<AuthenticationHeaderValue> GetAuthenticationHeaderAsync(CancellationToken cancellationToken)
        {
            try
            {
                var result = await this._authenticationContext.AcquireTokenAsync(this._tokenAudience, this._credential).ConfigureAwait(false);
                this.TokenType = result.AccessTokenType;
                return new AuthenticationHeaderValue(result.AccessTokenType, result.AccessToken);
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, authenticationException);
            }            
        }

        private void Initialize(string clientId, string domain, string secret, ActiveDirectoryEnvironment environment, 
            TokenCache cache)
        {
            if (string.IsNullOrWhiteSpace(secret))
            {
                throw new ArgumentOutOfRangeException("secret");
            }
            if (string.IsNullOrWhiteSpace(clientId))
            {
                throw new ArgumentOutOfRangeException("clientId");
            }
            if (string.IsNullOrWhiteSpace(domain))
            {
                throw new ArgumentOutOfRangeException("domain");
            }
            if (environment == null || environment.AuthenticationEndpoint == null || environment.TokenAudience == null)
            {
                throw new ArgumentOutOfRangeException("environment");
            }

            this._tokenAudience = environment.TokenAudience.ToString();
            this._authenticationContext = (cache == null)
                    ? new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                        environment.ValidateAuthority)
                    : new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                        environment.ValidateAuthority,
                        cache);
            this._credential = new ClientCredential(clientId, secret);
        }
    }
}
