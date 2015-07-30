// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// Provides methods for creating Active Directory user credentials for common scenarios.
    /// </summary>
    public class CredentialsFactory
    {
        /// <summary>
        /// Set up the credentials factory with defaults
        /// </summary>
        protected CredentialsFactory()
        {
            this.TokenCache = TokenCache.DefaultShared;
            this.ActiveDirectorySettings = ActiveDirectorySettings.Azure;
        }

        /// <summary>
        /// Create a credentials factory with the client id for this application.
        /// </summary>
        /// <param name="clientId"></param>
        public CredentialsFactory(string clientId) : this()
        {
            this.ClientId = clientId;
        }

        /// <summary>
        /// The Active Directory application client id.
        /// </summary>
        public string ClientId { get; protected set; }

        /// <summary>
        /// The token cache used during authentication when creating credewntials.
        /// </summary>
        public TokenCache TokenCache { get; set; }

        /// <summary>
        /// The ClientRedirectUri associated with this application in active directory.
        /// </summary>
        public Uri ClientRedirectUri { get; set; }

        /// <summary>
        /// The active directory settings to use during authentication.  Includes authentication endpoints and 
        /// desired dialog behavior.
        /// </summary>
        public ActiveDirectorySettings ActiveDirectorySettings { get; set; }

        /// <summary>
        /// Creates active directory credentials, prompting with a dialog for entering credentials.
        /// </summary>
        /// <returns>Authenticated service client credentials object using the authentication information provided in the dialog.</returns>
        public async Task<ServiceClientCredentials> CreateUserCredentialsWithPromptAsync()
        {
            return await CreateUserCredentialsWithPromptAsync("common");
        }

        /// <summary>
        /// Creates active directory credentials, prompting with a dialog for entering credentials.
        /// </summary>
        /// <param name="domain">The active directory domain or tenant id to use for authentication.</param>
        /// <returns>Authenticated service client credentials object using the authentication information provided in the dialog.</returns>
        public async Task<ServiceClientCredentials> CreateUserCredentialsWithPromptAsync(string domain)
        {
            return await CreateUserCredentialsWithPromptAsync(this.ClientId, domain, this.ClientRedirectUri,
                this.ActiveDirectorySettings, this.TokenCache);
        }

        /// <summary>
        /// Creates active directory credentials, prompting with a dialog for entering credentials.
        /// </summary>
        /// <param name="clientId">The active directory clientId for this application.</param>
        /// <param name="domain">The active directory domain or tenant id to use for authentication.</param>
        /// <param name="clientRedirectUri">The active directory redirect uri associated with this application.</param>
        /// <param name="settings">The active directory settings to used dueing authentication.</param>
        /// <param name="cache">The token cache to target dueing authentication.</param>
        /// <returns>Authenticated service client credentials object using the authentication information provided in the dialog.</returns>
        public static async Task<ServiceClientCredentials> CreateUserCredentialsWithPromptAsync(string clientId, string domain,
            Uri clientRedirectUri, ActiveDirectorySettings settings, TokenCache cache)
        {
            var provider = new UserTokenProvider(clientId, domain, settings, clientRedirectUri, cache);
            await provider.LoginAsync().ConfigureAwait(false);
            return new TokenCredentials(provider);
        }

        /// <summary>
        /// Creates active directory credentials for organization id accounts.  No prompt is presented for 
        /// authentication information.
        /// </summary>
        /// <param name="username">The username of organizational id credentials to use for authentication.</param>
        /// <param name="password">The password associated with the organization id account used for authentication.</param>
        /// <returns>Authenticated service client credentials object using the provided organization id username and password.</returns>
        public async Task<ServiceClientCredentials> CreateUserCredentialsNoPromptAsync(string username, string password)
        {
            return await CreateUserCredentialsNoPromptAsync("common", username, password);
        }

        /// <summary>
        /// Creates active directory credentials for organization id accounts.  No prompt is presented for 
        /// authentication information.
        /// </summary>
        /// <param name="domain">The active directory domain or tenant id to use for authentication.</param>
        /// <param name="username">The username of organizational id credentials to use for authentication.</param>
        /// <param name="password">The password associated with the organization id account used for authentication.</param>
        /// <returns>Authenticated service client credentials object using the provided organization id username and password.</returns>
        public async Task<ServiceClientCredentials> CreateUserCredentialsNoPromptAsync(
            string domain, string username, string password)
        {
            return await CreateUserCredentialsNoPromptAsync(this.ClientId, domain,username, password, this.ClientRedirectUri, this.ActiveDirectorySettings, this.TokenCache);
        }

        /// <summary>
        /// Creates active directory credentials for organization id accounts.  No prompt is presented for 
        /// authentication information.
        /// </summary>
        /// <param name="clientId">The active directory clientId for this application.</param>
        /// <param name="domain">The active directory domain or tenant id to use for authentication.</param>
        /// <param name="username">The username of organizational id credentials to use for authentication.</param>
        /// <param name="password">The password associated with the organization id account used for authentication.</param>
        /// <param name="clientRedirectUri">The active directory redirect uri associated with this application.</param>
        /// <param name="settings">The active directory settings to used dueing authentication.</param>
        /// <param name="cache">The token cache to target dueing authentication.</param>
        /// <returns>Authenticated service client credentials object using the provided organization id username and password.</returns>
        public static async Task<ServiceClientCredentials> CreateUserCredentialsNoPromptAsync(string clientId, string domain,
            string username, string password, Uri clientRedirectUri, ActiveDirectorySettings settings, TokenCache cache)
        {
            var provider = new UserTokenProvider(clientId, domain, settings, clientRedirectUri, cache);
            await provider.LoginSilentAsync(username, password).ConfigureAwait(false);
            return new TokenCredentials(provider);
        }

        public async Task<ServiceClientCredentials> GetUserCredentialsFromTokenCache(string username)
        {
            return await GetUserCredentialsFromTokenCache("common", username);
        }

        /// <summary>
        /// Gets user credentials cached from a previous log in.  Authentication fails if matching valid tokens are not 
        /// found in the TokenCache.
        /// </summary>
        /// <param name="domain">The active directory domain or tenant id to use for authentication.</param>
        /// <param name="username">The username of organizational id credentials to use for authentication.</param>
        /// <returns>Authenticated service client credentials object using tokens retrieved from the cache.</returns>
        public async Task<ServiceClientCredentials> GetUserCredentialsFromTokenCache(
            string domain, string username)
        {
            return await GetUserCredentialsFromTokenCache(this.ClientId, domain, username, this.ClientRedirectUri,
                this.ActiveDirectorySettings, this.TokenCache);
        }

        /// <summary>
        /// Gets user credentials cached from a previous log in.  Authentication fails if matching valid tokens are not 
        /// found in the TokenCache.
        /// </summary>
        /// <param name="clientId">The active directory clientId for this application.</param>
        /// <param name="domain">The active directory domain or tenant id to use for authentication.</param>
        /// <param name="username">The username of organizational id credentials to use for authentication.</param>
        /// <param name="clientRedirectUri">The active directory redirect uri associated with this application.</param>
        /// <param name="settings">The active directory settings to used dueing authentication.</param>
        /// <param name="cache">The token cache to target dueing authentication.</param>
        /// <returns>Authenticated service client credentials object using tokens retrieved from the cache.</returns>
        public static async Task<ServiceClientCredentials> GetUserCredentialsFromTokenCache(string clientId,
            string domain, string username, Uri clientRedirectUri, ActiveDirectorySettings settings, TokenCache cache)
        {
             var provider = new UserTokenProvider(clientId, domain, settings, clientRedirectUri, cache);
             await provider.LoginSilentAsync(username).ConfigureAwait(false);
            return new TokenCredentials(provider);
        }

    }
}
