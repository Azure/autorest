// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
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
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// This method will display a dialog for providing username and password.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.</param> 
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="clientRedirectUri">The Uri where the user will be redirected after authenticating with AD.</param>
        public UserTokenCredentials(string clientId, string domain, Uri clientRedirectUri)
            : this(clientId, domain, clientRedirectUri: clientRedirectUri, environment: ActiveDirectoryEnvironment.Azure, ownerWindow: null, cache: null)
        {
        }

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// This method will display a dialog for providing username and password.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.</param> 
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="environment">The azure environment to authenticate with. </param>
        /// <param name="clientRedirectUri">The Uri where the user will be redirected after authenticating with AD.</param>
        public UserTokenCredentials(string clientId, string domain, Uri clientRedirectUri, ActiveDirectoryEnvironment environment)
            : this(clientId, domain, clientRedirectUri, environment, ownerWindow: null, cache: null)
        {
        }

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// This method will display a dialog for providing username and password.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.</param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="ownerWindow">The window for displaying the user credential prompt.</param>
        /// <param name="environment">The azure environment to authenticate with. </param>
        /// <param name="clientRedirectUri">The Uri where the user will be redirected after authenticating with AD.</param>
        /// <param name="cache">The ADAL token cache to use during authentication.</param>
        public UserTokenCredentials(string clientId, string domain, Uri clientRedirectUri, 
            ActiveDirectoryEnvironment environment, object ownerWindow, TokenCache cache)
            : base(new ActiveDirectoryUserTokenProvider(clientId: clientId, domain: domain, ownerWindow: ownerWindow, 
                environment: environment, clientRedirectUri: clientRedirectUri, cache: cache))
        {
        }

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Organization Id accounts only.  
        /// This method will not display a dialog.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.</param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="username">The user name for the Organization Id account.</param>
        /// <param name="password">The password for the Organization Id account.</param>
        public UserTokenCredentials(string clientId, string domain, string username, string password) 
            : this(clientId, domain, username, password, ActiveDirectoryEnvironment.Azure, null)
        {
        }

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Organization Id accounts only.  
        /// This method will not display a dialog.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.</param> 
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="username">The user name for the Organization Id account.</param>
        /// <param name="password">The password for the Organization Id account.</param>
        /// <param name="environment">The azure environment to authenticate with. </param>
        /// <param name="cache">The ADAL token cache to use during authentication.</param>
        public UserTokenCredentials(string clientId, string domain, string username, string password, 
            ActiveDirectoryEnvironment environment, TokenCache cache) 
            : base(new ActiveDirectoryUserTokenProvider(clientId:clientId, domain: domain, 
                username: username, password: password, environment: environment, cache: cache))
        {
            
        }
    }
}
