// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest.Azure.Authentication.Properties;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

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
        private UserIdentifier _userId;
        private ActiveDirectoryEnvironment _environment;
        private AuthenticationContext _authenticationContext;
        private PromptBehavior _promptBehavior;
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
            : this(clientId, domain, ActiveDirectoryEnvironment.Azure, clientRedirectUri, null)
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
        /// <param name="adParameters">The ADAL parameters.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain,
            ActiveDirectoryEnvironment environment, Uri clientRedirectUri, ActiveDirectoryParameters adParameters)
        {
            Initialize(clientId,
                username: null,
                password: null,
                domain: domain,
                environment: environment,
                adParameters: adParameters,
                clientRedirectUri: clientRedirectUri);
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
            : this(clientId, domain, username, password, environment: ActiveDirectoryEnvironment.Azure, cache: null)
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
            ActiveDirectoryEnvironment environment, TokenCache cache)
        {
            Initialize(clientId,
                username: username,
                password: password,
                domain: domain,
                environment: environment,
                clientRedirectUri: null,
                adParameters: null);
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
                AuthenticationResult result = await this._authenticationContext.AcquireTokenSilentAsync(this._environment.TokenAudience.ToString(), 
                    this._clientId, this._userId).ConfigureAwait(false);
                return new AuthenticationHeaderValue(result.AccessTokenType, result.AccessToken);
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorRenewingToken, authenticationException);
            }
        }

        private void Initialize(string clientId, string domain, string username, string password,
            ActiveDirectoryEnvironment environment, Uri clientRedirectUri, ActiveDirectoryParameters adParameters)
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
            if (adParameters == null)
            {
                adParameters = new ActiveDirectoryParameters();
            }

            this._clientId = clientId;
            this._environment = environment;
            this._promptBehavior = adParameters.PromptBehavior;
            this._authenticationContext = GetAuthenticationContext(domain, environment, adParameters.TokenCache, 
                adParameters.OwnerWindow);
            AuthenticationResult authenticationResult = null;
            if (username != null && password != null)
            {
                authenticationResult = Authenticate(new UserCredential(username, password), this._environment);
            }
            else
            {
                authenticationResult = Authenticate(this._environment, clientRedirectUri);
            }
            this._userId = new UserIdentifier(authenticationResult.UserInfo.DisplayableId, UserIdentifierType.OptionalDisplayableId);
        }


        private AuthenticationResult Authenticate(UserCredential credential, ActiveDirectoryEnvironment environment)
        {
            try
            {
                return this._authenticationContext.AcquireToken(environment.TokenAudience.ToString(), this._clientId, credential);
            }
            catch (AdalException ex)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, ex);
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private AuthenticationResult Authenticate(ActiveDirectoryEnvironment environment, Uri clientRedirectUri)
        {
            Exception exception = null;
            AuthenticationResult result = null;
            var thread = new Thread(() =>
            {
                try
                {
                    result = this._authenticationContext.AcquireToken(
                        environment.TokenAudience.ToString(),
                        this._clientId,
                        clientRedirectUri,
                        this._promptBehavior,
                        UserIdentifier.AnyUser,
                        EnableEbdMagicCookie);
                }
                catch (Exception e)
                {
                    exception = e;
                }
            });
            thread.SetApartmentState(ApartmentState.STA);
            thread.Name = "AcquireTokenThread";
            thread.Start();
            thread.Join();
            if (exception != null)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, exception);
            }

            return result;
        }

        private static AuthenticationContext GetAuthenticationContext(string domain, ActiveDirectoryEnvironment environment, TokenCache cache, object ownerWindow)
        {
            var context = (cache == null
                ? new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                    environment.ValidateAuthority)
                : new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                    environment.ValidateAuthority, cache));
            context.OwnerWindow = ownerWindow;
            return context;
        }
    }
}
