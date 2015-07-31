// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
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
    public class UserTokenProvider : ITokenProvider
    {
        /// <summary>
        /// Uri parameters used in the credential prompt.  Allows recalling previous 
        /// logins in the login dialog.
        /// </summary>
        private ActiveDirectorySettings _settings;
        private AuthenticationContext _authenticationContext;
        private string _clientId;
        private Uri _clientRedirectUri;

        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// Use Login or LoginSilent methods to log in using the token provider before using the tokens.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        public UserTokenProvider(string clientId, string domain, Uri clientRedirectUri)
            : this(clientId, domain, ActiveDirectorySettings.Azure, clientRedirectUri)
        {
        }

        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// Use Login or LoginSilent methods to log in using the token provider before using the tokens.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="settings">The azure active directory settings to use for authentication.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        public UserTokenProvider(string clientId, string domain,
            ActiveDirectorySettings settings, Uri clientRedirectUri)
            : this(clientId, domain, settings, clientRedirectUri, null)
        {
        }

        /// <summary>
        /// Initializes a token provider using Active Directory user credentials (UPN). 
        /// Use Login or LoginSilent methods to log in using the token provider before using the tokens.
        /// </summary>
        /// <param name="clientId">The client id for this application.</param>
        /// <param name="domain">The domain or tenant id containing the resources to manage.</param>
        /// <param name="settings">The azure active directory settings to use for authentication.</param>
        /// <param name="clientRedirectUri">The redirect URI for authentication requests for 
        /// this client application.</param>
        /// <param name="cache">The token cache to target during authentication.</param>
        public UserTokenProvider(string clientId, string domain,
            ActiveDirectorySettings settings, Uri clientRedirectUri,TokenCache cache)
        {
            if (string.IsNullOrWhiteSpace(clientId))
            {
                throw new ArgumentOutOfRangeException("clientId");
            }
            if (string.IsNullOrWhiteSpace(domain))
            {
                throw new ArgumentOutOfRangeException("domain");
            }
            if (settings == null || settings.AuthenticationEndpoint == null || settings.TokenAudience == null)
            {
                throw new ArgumentOutOfRangeException("settings");
            }

            this._clientId = clientId;
            this._settings = settings;
            this._clientRedirectUri = clientRedirectUri;
            this._authenticationContext = GetAuthenticationContext(domain, settings, cache,
                settings.OwnerWindow);
        }

        /// <summary>
        /// Log in to Azure active directory using a background thread.  This call may  display a user log in 
        /// dialog, depending on the settings in ActiveDirectoryDialogParameters.
        /// </summary>
        public async Task LogOnAsync()
        {
            var completion = new TaskCompletionSource<AuthenticationResult>();
            await Task.Run(() =>
            {
                try
                {
                    var result = this._authenticationContext.AcquireToken(
                        this._settings.TokenAudience.ToString(),
                        this._clientId,
                        this._clientRedirectUri,
                        this._settings.PromptBehavior,
                        this._settings.UserIdentifier,
                        this._settings.AdditionalQueryParameters);
                    this._settings.UserIdentifier = new UserIdentifier(result.UserInfo.DisplayableId,
                        UserIdentifierType.RequiredDisplayableId);
                    completion.SetResult(result);
                }
                catch (Exception e)
                {
                    completion.SetException(new AuthenticationException(
                        string.Format(CultureInfo.CurrentCulture,Resources.ErrorAcquiringToken, 
                        e.Message), e));
                }
            });
            await completion.Task.ConfigureAwait(false);
        }

        /// <summary>
        /// Log in to Azure Active Directory using the given username and password credential. 
        /// No user log in dialog will be displayed.  This method requires the use of Organization credentials.
        /// </summary>
        /// <param name="username">The organization id user name.</param>
        /// <param name="password">The password associated with this organization id.</param>
        /// <returns>A task which completes when the authentication terminates.</returns>
        public async Task LogOnSilentAsync(string username, string password)
        {
            var credentials = new UserCredential(username, password);
            try
            {
                await this._authenticationContext.AcquireTokenAsync(this._settings.TokenAudience.ToString(),
                      this._clientId, credentials).ConfigureAwait(false);
                this._settings.UserIdentifier = new UserIdentifier(username, UserIdentifierType.RequiredDisplayableId);
            }
            catch (AdalException ex)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, ex);
            }
        }

        /// <summary>
        /// Log in to Azure Active Directory using the given username and password credential. 
        /// No user log in dialog will be displayed.  This method requires a previous log in with credentials stored
        /// in the token cache.
        /// </summary>
        /// <param name="username">The user name of the previously logged in user.</param>
        /// <returns>A task which completes when the authentication terminates.</returns>
        public async Task LogOnSilentAsync(string username)
        {
            this._settings.UserIdentifier  = new UserIdentifier(username, UserIdentifierType.RequiredDisplayableId);
            try
            {
                await this._authenticationContext.AcquireTokenSilentAsync(this._settings.TokenAudience.ToString(), 
                    this._clientId, this._settings.UserIdentifier ).ConfigureAwait(false);
            }
            catch (AdalException ex)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, ex);
            }
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
                AuthenticationResult result = await this._authenticationContext.AcquireTokenSilentAsync(this._settings.TokenAudience.ToString(),
                    this._clientId, this._settings.UserIdentifier).ConfigureAwait(false);
                return new AuthenticationHeaderValue(result.AccessTokenType, result.AccessToken);
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorRenewingToken, authenticationException);
            }
        }

        private static AuthenticationContext GetAuthenticationContext(string domain, ActiveDirectorySettings settings, TokenCache cache, object ownerWindow)
        {
            var context = (cache == null
                ? new AuthenticationContext(settings.AuthenticationEndpoint + domain,
                    settings.ValidateAuthority)
                : new AuthenticationContext(settings.AuthenticationEndpoint + domain,
                    settings.ValidateAuthority, cache));
            context.OwnerWindow = ownerWindow;
            return context;
        }
    }
}
