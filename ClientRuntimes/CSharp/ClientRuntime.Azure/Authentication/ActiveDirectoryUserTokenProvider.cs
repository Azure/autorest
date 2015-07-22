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

        //Use preprocessor below to expose the "IPlatformParameters" only on portable platform
#if !PORTABLE
        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// This token provider will prompt the user for username and password.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain,
            AzureEnvironment environment, Uri clientRedirectUri)
            : this(clientId, domain, environment, clientRedirectUri, cache: null)
        {
        }

        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// This token provider will prompt the user for username and password.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        /// <param name="cache">The token cache to use during authentication.</param>
        internal ActiveDirectoryUserTokenProvider(string clientId, string domain,
            AzureEnvironment environment, Uri clientRedirectUri, TokenCache cache)
        {
            var platformParameters = new PlatformParameters(PromptBehavior.Always, null);
            Initialize(clientId, domain, platformParameters, environment, clientRedirectUri, cache);
        }        
#else
        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// This token provider will prompt the user for username and password.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="platformParameters">platform specific parameters</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain, 
            IPlatformParameters platformParameters, AzureEnvironment environment, Uri clientRedirectUri)
            : this(clientId, domain, platformParameters, environment, clientRedirectUri, cache: null)
        {
        }

        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// This token provider will prompt the user for username and password.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="platformParameters">platform specific parameters</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        /// <param name="cache">The token cache to use during authentication.</param>
        internal ActiveDirectoryUserTokenProvider(string clientId, string domain,
            IPlatformParameters platformParameters, AzureEnvironment environment, 
            Uri clientRedirectUri, TokenCache cache)
        {
            Initialize(clientId, domain, platformParameters, environment, clientRedirectUri, cache);
        }
#endif


        /// <summary>
        /// Create a token provider using Active Directory user credentials (UPN). 
        /// Authentication occurs using the given username and password, with no user prompt.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="username">The username to use for authentication.</param>
        /// <param name="password">The secret password associated with this user.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain, string username, string password,
            AzureEnvironment environment)
            : this(clientId, domain, username, password, environment, store: null)
        {
        }

        /// <summary>
        /// Create a token provider using Active Directory user credentials (UPN). 
        /// Authentication occurs using the given username and password, with no user prompt.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="username">The username to use for authentication.</param>
        /// <param name="password">The secret password associated with this user.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="store">The token store to use during authentication.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain, string username, string password,
            AzureEnvironment environment, ActiveDirectoryTokenStore store)
        {
            TokenCache tokenCache = (store == null) ? null : store.TokenCache;

            Initialize(clientId, domain, username, password, environment, tokenCache);
        }

        /// <summary>
        /// Set the ActiveDirectory authentication properties for this user
        /// </summary>
        /// <param name="authenticationResult"></param>
        protected void ProcessAuthenticationResult(AuthenticationResult authenticationResult)
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
        /// The type of token this provider returns.  Options include Bearer and SAML tokens.
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

        private void Initialize(string clientId, string domain, IPlatformParameters platformParameters,
            AzureEnvironment environment, Uri clientRedirectUri, TokenCache cache)
        {
            if (clientRedirectUri == null)
            {
                throw new ArgumentNullException("clientRedirectUri");
            }

            Initialize(clientId, domain, environment, cache, 
                () => Authenticate(environment, platformParameters, clientRedirectUri));
        }

        private void Initialize(string clientId, string domain, string username, string password,
            AzureEnvironment environment, TokenCache cache)
        {
            if (string.IsNullOrWhiteSpace(username))
            {
                throw new ArgumentOutOfRangeException("username");
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                throw new ArgumentOutOfRangeException("password");
            }

            Initialize(clientId, domain, environment, cache, () => Authenticate(username, password, environment));
        }

        private void Initialize(string clientId, string domain, AzureEnvironment environment, TokenCache cache,
            Func<AuthenticationResult> authenticator)
        {
            ValidateCommonParameters(clientId, domain, environment);
            this._clientId = clientId;
            this._tokenAudience = environment.TokenAudience.ToString();
            try
            {
                this._authenticationContext = GetAuthenticationContext(domain, environment, cache);
                ProcessAuthenticationResult(authenticator());
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, authenticationException);
            }
        }

        private AuthenticationResult Authenticate(string username, string password, AzureEnvironment environment)
        {
            return this._authenticationContext.AcquireTokenAsync(environment.TokenAudience.ToString(), this._clientId,
                new UserCredential(username, password)).Result;
        }

        private AuthenticationResult Authenticate(AzureEnvironment environment,  
            IPlatformParameters platformParameters, Uri clientRedirectUri)
        {
            return this._authenticationContext.AcquireTokenAsync(
                    environment.TokenAudience.ToString(), this._clientId, clientRedirectUri,
                    platformParameters, UserIdentifier.AnyUser,
                    EnableEbdMagicCookie).Result;
        }

        private static AuthenticationContext GetAuthenticationContext(string domain, AzureEnvironment environment, TokenCache cache)
        {
            return cache == null
                ? new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                    environment.ValidateAuthority)
                : new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                    environment.ValidateAuthority, cache);

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
    }
}
