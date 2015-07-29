// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest.Azure.Authentication.Properties;
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
        private UserIdentifier _userId;
        private ActiveDirectoryEnvironment _environment;
        private AuthenticationContext _authenticationContext;
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
            : this(clientId, domain, ActiveDirectoryEnvironment.Azure, clientRedirectUri, null, null)
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
        /// <param name="ownerWindow">The ADAL dialog owner window.</param>
        /// <param name="cache">The ADAL token cache to use during authentication.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain,
            ActiveDirectoryEnvironment environment, Uri clientRedirectUri, object ownerWindow, TokenCache cache)
            : this(clientId, domain, environment, clientRedirectUri, ownerWindow, PromptBehavior.Always, cache)
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
        /// <param name="ownerWindow">The ADAL dialog owner window.</param>
        /// <param name="promptBehavior">Specifies the desired prompt behavior = 'Always' to always prompt the 
        /// user, 'Auto' to use cached tokens and cookies as appropriate, 'Never' to never prompt</param>
        /// <param name="cache">The ADAL token cache to use during authentication.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain,
             ActiveDirectoryEnvironment environment, Uri clientRedirectUri, object ownerWindow, PromptBehavior promptBehavior, TokenCache cache)
        {
            Initialize(clientId,
                username: null,
                password: null,
                domain: domain,
                environment: environment,
                cache: cache,
                clientRedirectUri: clientRedirectUri,
                ownerWindow: ownerWindow,
                promptBehavior: promptBehavior);
        }

        /// <summary>
        /// Initializes a token provider for the provided user.  It is assumed that the user has previously logged in and 
        /// credentials are stored in the given token cache. If the token is not available or has expired, the login attempt will fail.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="environment">The azure environment to manage resources in.</param>
        /// <param name="username">The email or user principal name (UPN) for this user.</param>
        /// <param name="cache">The token cache to target - it is expected that the user will have previously logged in to the machine.</param>
        public ActiveDirectoryUserTokenProvider(string clientId, string domain,
           ActiveDirectoryEnvironment environment, string username, TokenCache cache)
        {
            Initialize(clientId,
                username: username,
                password: null,
                domain: domain,
                environment: environment,
                cache: cache,
                clientRedirectUri: null,
                ownerWindow: null,
                promptBehavior: PromptBehavior.Never);
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
                cache: cache,
                clientRedirectUri: null,
                ownerWindow: null,
                promptBehavior: PromptBehavior.Never);
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
            ActiveDirectoryEnvironment environment, TokenCache cache,
            Uri clientRedirectUri, object ownerWindow, PromptBehavior promptBehavior)
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

            this._clientId = clientId;
            this._environment = environment;
            this._authenticationContext = GetAuthenticationContext(domain, environment, cache, ownerWindow);
            AuthenticationResult authenticationResult = null;
            if (username != null && password != null)
            {
                authenticationResult = Authenticate(new UserCredential(username, password));
            }
            else if (username != null)
            {
                authenticationResult = Authenticate(username);
            }
            else
            {
                authenticationResult = Authenticate(clientRedirectUri, promptBehavior);
            }

            this._userId = new UserIdentifier(authenticationResult.UserInfo.DisplayableId, UserIdentifierType.RequiredDisplayableId);
        }


        private AuthenticationResult Authenticate(UserCredential credential)
        {
            try
            {
                return this._authenticationContext.AcquireToken(this._environment.TokenAudience.ToString(), this._clientId, credential);
            }
            catch (AdalException ex)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, ex);
            }
        }

        private AuthenticationResult Authenticate(string username)
        {
            return this._authenticationContext.AcquireTokenSilent(this._environment.TokenAudience.ToString(), this._clientId,
                new UserIdentifier(username, UserIdentifierType.RequiredDisplayableId));
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private AuthenticationResult Authenticate(Uri clientRedirectUri, PromptBehavior promptBehavior)
        {
            Exception exception = null;
            AuthenticationResult result = null;
            var thread = new Thread(() =>
            {
                try
                {
                    result = this._authenticationContext.AcquireToken(
                        this._environment.TokenAudience.ToString(),
                        this._clientId,
                        clientRedirectUri,
                        promptBehavior,
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
