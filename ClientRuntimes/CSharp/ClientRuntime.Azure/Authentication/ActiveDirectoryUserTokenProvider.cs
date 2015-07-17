// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Properties;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest;

namespace Microsoft.Azure.Authentication
{
    /// <summary>
    /// Provides tokens for Azure Active Directory Microsoft Id and Organization Id users.
    /// </summary>
    public class ActiveDirectoryUserTokenProvider : ITokenProvider
    {
        /// <summary>
        /// Uri parameters used in the credential prompt.  Allows recalling previous 
        /// logins in the login dialog.
        /// </summary>
        private const string EnableEbdMagicCookie = "site_id=501358&display=popup";
        private string _userId;
        private AuthenticationContext _authenticationContext;
        private string _tokenAudience;
        private string _clientId;
        private string _type;

        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// This token provider will prompt the user for username and password.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id contianing the resources to manage.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain,
            AzureEnvironment environment, Uri clientRedirectUri) 
            : this(clientId, domain, environment, clientRedirectUri, null)
        {
        }

        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// This token provider will prompt the user for username and password.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id contianing the resources to manage.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        /// <param name="cache">The token cache to use during authentication.</param>
        internal ActiveDirectoryUserTokenProvider(string clientId, string domain,
            AzureEnvironment environment, Uri clientRedirectUri, TokenCache cache)
        {
            ValidateCommonParameters(clientId, domain, environment);
            if (clientRedirectUri == null)
            {
                throw new ArgumentNullException("clientRedirectUri");
            }

            this._clientId = clientId;
            this._tokenAudience = environment.TokenAudience.ToString();
            string authority = environment.AuthenticationEndpoint + domain;
            try
            {
                this._authenticationContext = cache == null
                    ? new AuthenticationContext(authority, environment.ValidateAuthority)
                    : new AuthenticationContext(authority, environment.ValidateAuthority, cache);
                var authenticatioResult = this._authenticationContext.AcquireTokenAsync(
                    environment.TokenAudience.ToString(), clientId, clientRedirectUri,
                    GetPlatformParameters(), UserIdentifier.AnyUser,
                    EnableEbdMagicCookie).Result;
                Initialize(authenticatioResult);
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, authenticationException);
            }
        }
        /// <summary>
        /// Create a token provider using Active Directory user credentials (UPN). 
        /// Authentication occurs using the given username and password, with no user prompt.
        /// </summary>
        /// <param name="clientId">The client id for thsi application.</param>
        /// <param name="domain">The domain or tenant id contianing the resources to manage.</param>
        /// <param name="username">The username to use for authentication.</param>
        /// <param name="password">The secret password associated with thsi user.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain, string username, string password, AzureEnvironment environment) 
            : this(clientId, domain, username, password, environment, null)
        {
        }

        /// <summary>
        /// Create a token provider using Active Directory user credentials (UPN). 
        /// Authentication occurs using the given username and password, with no user prompt.
        /// </summary>
        /// <param name="clientId">The client id for thsi application.</param>
        /// <param name="domain">The domain or tenant id contianing the resources to manage.</param>
        /// <param name="username">The username to use for authentication.</param>
        /// <param name="password">The secret password associated with thsi user.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="cache">The token cache to use during authentication.</param>
        internal ActiveDirectoryUserTokenProvider(string clientId, string domain, string username, string password, AzureEnvironment environment, TokenCache cache)
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
            try
            {
                this._authenticationContext = cache == null ? 
                    new AuthenticationContext(environment.AuthenticationEndpoint + domain, environment.ValidateAuthority) :
                    new AuthenticationContext(environment.AuthenticationEndpoint + domain, environment.ValidateAuthority, cache);
                var authenticationResult = this._authenticationContext.AcquireTokenAsync(environment.TokenAudience.ToString(), clientId,
                        new UserCredential(username, password)).Result;
                Initialize(authenticationResult);
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, authenticationException);
            }

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
                    Resources.AuthenticationValidationFailed,
                    this._clientId));
            }

            this._userId = authenticationResult.UserInfo.DisplayableId;
            this._type = authenticationResult.AccessTokenType;
        }

        /// <summary>
        /// The type of token this provider returns.  Options include Beaere and SAML tokens.
        /// </summary>
        public string TokenType
        {
            get { return _type; }
        }
        /// <summary>
        /// Gets an access token from the token cache or from AD authentication endpoint.  Will attempt to 
        /// refresh the access token if it has expired.
        /// </summary>
        public virtual async Task<string> GetAccessTokenAsync(CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();
            try
            {
                var authenticationResult =
                    await this._authenticationContext.AcquireTokenSilentAsync(this._tokenAudience,
                        this._clientId,
                        new UserIdentifier(this._userId,
                            UserIdentifierType.OptionalDisplayableId)).ConfigureAwait(false);
                return authenticationResult.AccessToken;
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorRenewingToken, authenticationException);
            }

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

        private static PlatformParameters GetPlatformParameters()
        {
#if PORTABLE
            return new PlatformParameters();
#else
            return new PlatformParameters(PromptBehavior.Always, null);
#endif
        }
    }
}
