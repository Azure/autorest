// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest.Azure.Properties;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest;

namespace Microsoft.Rest.Azure.Authentication
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
        private string _password;
        private AzureEnvironment _environment;
        private AuthenticationContext _authenticationContext;
        private IPlatformParameters _platformParameters;
        private Uri _clientRedirectUri;
        private string _clientId;

        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// This token provider will prompt the user for username and password.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain, Uri clientRedirectUri)
            : this(clientId, domain, AzureEnvironment.Azure, clientRedirectUri, null, null)
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
        /// <param name="platformParameters">The ADAL platform parameter.</param>
        /// <param name="cache">The ADAL token cache to use during authentication.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain,
            AzureEnvironment environment, Uri clientRedirectUri, 
            IPlatformParameters platformParameters, TokenCache cache)
        {
            Initialize(clientId:clientId, 
                username:null, 
                password:null, 
                domain:domain, 
                environment:environment,
                cache:cache,
                platformParameters: platformParameters,
                clientRedirectUri:clientRedirectUri);
        }


        /// <summary>
        /// Create a token provider using Active Directory user credentials (UPN). 
        /// Authentication occurs using the given username and password, with no user prompt.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="username">The username to use for authentication.</param>
        /// <param name="password">The secret password associated with this user.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain, string username, string password)
            : this(clientId, domain, username, password, environment: AzureEnvironment.Azure, cache: null)
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
        /// <param name="cache">The ADAL token cache to use during authentication.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain, string username, string password,
            AzureEnvironment environment, TokenCache cache)
        {
            Initialize(clientId: clientId,
                username: username,
                password: password,
                domain: domain,
                environment: environment,
                cache: cache,
                platformParameters: null,
                clientRedirectUri: null);
        }

        /// <summary>
        /// Gets an access token from the token cache or from AD authentication endpoint.  Will attempt to 
        /// refresh the access token if it has expired.
        /// </summary>
        public virtual async Task<AuthenticationHeaderValue> GetAuthenticationHeaderAsync(CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();
            try
            {
                AuthenticationResult result;
                if (_userId == null)
                {
                    result = await Authenticate(_environment, _platformParameters, _clientRedirectUri);
                }
                else
                {
                    result = await Authenticate(_userId, _password, _environment);
                }
                this._userId = result.UserInfo.DisplayableId;
                return new AuthenticationHeaderValue(result.AccessTokenType, result.AccessToken);
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorRenewingToken, authenticationException);
            }
        }

        private void Initialize(string clientId, string domain, string username, string password,
            AzureEnvironment environment, TokenCache cache, IPlatformParameters platformParameters, 
            Uri clientRedirectUri)
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

            this._userId = username;
            this._password = password;
            this._clientId = clientId;
            this._environment = environment;
            this._authenticationContext = GetAuthenticationContext(domain, environment, cache);
            if (platformParameters == null)
            {
#if !PORTABLE
                platformParameters = new PlatformParameters(PromptBehavior.Always, null);
#else
                throw new ArgumentNullException("platformParameters");
#endif
            }
            this._platformParameters = platformParameters;

            this._clientRedirectUri = clientRedirectUri;
        }

        private async Task<AuthenticationResult> Authenticate(string username, string password, AzureEnvironment environment)
        {
            return await this._authenticationContext.AcquireTokenAsync(
                environment.TokenAudience.ToString(), 
                this._clientId,
                new UserCredential(username, password));
        }

        private async Task<AuthenticationResult> Authenticate(AzureEnvironment environment,  
            IPlatformParameters platformParameters, Uri clientRedirectUri)
        {
            return await this._authenticationContext.AcquireTokenAsync(
                    environment.TokenAudience.ToString(), 
                    this._clientId, 
                    clientRedirectUri,
                    platformParameters, 
                    UserIdentifier.AnyUser,
                    EnableEbdMagicCookie);
        }

        private static AuthenticationContext GetAuthenticationContext(string domain, AzureEnvironment environment, TokenCache cache)
        {
            return cache == null
                ? new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                    environment.ValidateAuthority)
                : new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                    environment.ValidateAuthority, cache);

        }
    }
}
