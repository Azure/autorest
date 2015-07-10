// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace Microsoft.Azure
{
    /// <summary>
    /// Provides tokens for Azure Active Directory Microsoft Id, Organization Id, and Service Principal users
    /// </summary>
    internal class ActiveDirectoryTokenProvider : ITokenProvider
    {
        private const string EnableEbdMagicCookie = "site_id=501358&display=popup";
        private string _userId;
        private AuthenticationContext _authenticationContext;
        private string _tokenAudience;
        private string _clientId;
        public ActiveDirectoryTokenProvider(string clientId, string domain, AzureEnvironment environment, Uri clientRedirectUri)
        {
            ValidateCommonParameters(clientId, domain, environment);
            if (clientRedirectUri == null)
            {
                throw new ArgumentNullException("clientRedirectUri");
            }

            this._clientId = clientId;
            this._tokenAudience = environment.TokenAudience.ToString();
            string authority = environment.AuthenticationEndpoint + domain;
            this._authenticationContext = new AuthenticationContext(authority, environment.ValidateAuthority);
            var authenticatioResult = this._authenticationContext.AcquireTokenAsync(environment.TokenAudience.ToString(),
                clientId, clientRedirectUri, new PlatformParameters(PromptBehavior.Always, null), UserIdentifier.AnyUser, EnableEbdMagicCookie).Result;
            Initialize(authenticatioResult);
        }

        private static void ValidateCommonParameters(string clientId, string domain, AzureEnvironment environment)
        {
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
        }

        public ActiveDirectoryTokenProvider(string clientId, string domain, string username, string password, AzureEnvironment environment)
        {
            ValidateCommonParameters(clientId, domain, environment);
            if (string.IsNullOrWhiteSpace(username))
            {
                throw new ArgumentOutOfRangeException("username");
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                throw new ArgumentOutOfRangeException("password");
            }

            this._clientId = clientId;
            this._tokenAudience = environment.TokenAudience.ToString();
            this._authenticationContext = new AuthenticationContext(environment.AuthenticationEndpoint + domain, environment.ValidateAuthority);
            var authenticationResult = this._authenticationContext.AcquireTokenAsync(environment.TokenAudience.ToString(), clientId,
                    new UserCredential(username, password)).Result;
            Initialize(authenticationResult);
        }

        internal ActiveDirectoryTokenProvider(string clientId, string domain, string username, string password, AzureEnvironment environment, TokenCache cache)
        {
            ValidateCommonParameters(clientId, domain, environment);
            if (string.IsNullOrWhiteSpace(username))
            {
                throw new ArgumentOutOfRangeException("username");
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                throw new ArgumentOutOfRangeException("password");
            }

            this._clientId = clientId;
            this._tokenAudience = environment.TokenAudience.ToString();
            this._authenticationContext = new AuthenticationContext(environment.AuthenticationEndpoint + domain, environment.ValidateAuthority, cache);
            var authenticationResult = this._authenticationContext.AcquireTokenAsync(environment.TokenAudience.ToString(), clientId,
                    new UserCredential(username, password)).Result;
            Initialize(authenticationResult);
        }

        /// <summary>
        /// Set the ActiveDirectory authentication properties for this user
        /// </summary>
        /// <param name="authenticationResult"></param>
        protected void Initialize(AuthenticationResult authenticationResult)
        {
            if (authenticationResult == null || authenticationResult.AccessToken == null || authenticationResult.UserInfo == null ||
                string.IsNullOrWhiteSpace(authenticationResult.UserInfo.DisplayableId))
            {
                throw new AuthenticationException(string.Format(CultureInfo.CurrentCulture,
                    "Authentication with Azure Active Directory Failed using clientId; {0}",
                    this._clientId));
            }

            this._userId = authenticationResult.UserInfo.DisplayableId;
        }

        /// <summary>
        /// Gets an access token from the token cache or from AD authentication endpoint.  Will attempt to 
        /// refresh the access token if it has expired.
        /// </summary>
        public virtual async Task<string> GetAccessTokenAsync(CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();
            var authenticationResult = await this._authenticationContext.AcquireTokenSilentAsync(this._tokenAudience,
                this._clientId,
                new UserIdentifier(this._userId,
                    UserIdentifierType.OptionalDisplayableId)).ConfigureAwait(false);
            return authenticationResult.AccessToken;
        }
    }
}
