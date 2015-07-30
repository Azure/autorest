// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Microsoft.Rest;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// Credentials class for authenticating using a Microsoft ID or Organizational Id.
    /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">
    /// Active Directory Quickstart for .Net</see> for an example. 
    /// </summary>
    public class UserTokenCredentials : TokenCredentials
    {
        /// <summary>
        /// Creates a new UserTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.</param> 
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="clientRedirectUri">The Uri where the user will be redirected after authenticating with AD.</param>
        public UserTokenCredentials(string clientId, string domain, Uri clientRedirectUri)
            : this(clientId, domain, clientRedirectUri, ActiveDirectorySettings.Azure)
        {
        }


        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.</param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="clientRedirectUri">The Uri where the user will be redirected after authenticating with AD.</param>
        /// <param name="settings">The azure active directory settings to use for authentication.</param>
        public UserTokenCredentials(string clientId, string domain, Uri clientRedirectUri, 
            ActiveDirectorySettings settings)
            : this(clientId, domain, clientRedirectUri, settings, null)
        {
        }

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.</param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="clientRedirectUri">The Uri where the user will be redirected after authenticating with AD.</param>
        /// <param name="settings">The azure active directory settings to use for authentication.</param>
        /// <param name="cache">The token cache to target durign authentication.</param>
        public UserTokenCredentials(string clientId, string domain, Uri clientRedirectUri, 
            ActiveDirectorySettings settings, TokenCache cache)
            : base(new UserTokenProvider(clientId, domain, settings, clientRedirectUri, cache))
        {
        }

        /// <summary>
        /// Log in to Azure active directory, prompting the user for credentials.
        /// </summary>
        public async Task LoginAsync()
        {
            var provider = TokenProvider as UserTokenProvider;
            await provider.LoginAsync().ConfigureAwait(false);
        }

        /// <summary>
        /// Log in to Azure active directory using the given credentials. This requires use of Organization id credentials.
        /// </summary>
        /// <param name="username">The organization is user name.</param>
        /// <param name="password">The password for the given organizational id.</param>
        /// <returns>A Task which completes when log in is complete.</returns>
        public async Task LoginSilentAsync(string username, string password)
        {
            var provider = TokenProvider as UserTokenProvider;
            await provider.LoginSilentAsync(username, password).ConfigureAwait(false);
        }
    }
}
