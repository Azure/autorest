// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using Microsoft.Rest;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// Credentials class for authenticating using a Microsoft ID or Organizational Id
    /// </summary>
    public class UserTokenCredentials : TokenCredentials
    {
        //Use preprocessor to expose the "IPlatformParameters" only on portable
#if !PORTABLE
        private static readonly Uri DefaultRedirectUri = new Uri("urn:ietf:wg:oauth:2.0:oob");
        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// This method will display a dialog for providing username and password.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.  
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> for an example. </param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        public UserTokenCredentials(string clientId, string domain) 
            : this(clientId, domain, AzureEnvironment.Azure)
        {
        }

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organizational Id accounts.  
        /// This method will display a dialog for providing username and password.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.  
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> for an example. </param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="environment">The azure environment to authenticate with. </param>
        public UserTokenCredentials(string clientId, string domain, AzureEnvironment environment) 
            :  this(clientId, domain, environment, DefaultRedirectUri)
        {
        }

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// This method will display a dialog for providing username and password.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.  
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> for an example. </param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="environment">The azure environment to authenticate with. </param>
        /// <param name="clientRedirectUri">The Uri where the user will be redirected after authenticating with AD.</param>
        public UserTokenCredentials(string clientId, string domain, AzureEnvironment environment, Uri clientRedirectUri) 
            : base(new ActiveDirectoryUserTokenProvider(clientId, domain, environment, clientRedirectUri))
        {
        }        
#else
        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Microsoft accounts or Organization Id accounts.  
        /// This method will display a dialog for providing username and password.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.  
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> for an example. </param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="platformParameters">platform specific parameters</param>
        /// <param name="environment">The azure environment to authenticate with. </param>
        /// <param name="clientRedirectUri">The Uri where the user will be redirected after authenticating with AD.</param>
        public UserTokenCredentials(string clientId, string domain, IPlatformParameters platformParameters, AzureEnvironment environment, Uri clientRedirectUri)
            : base(new ActiveDirectoryUserTokenProvider(clientId, domain, platformParameters, environment, clientRedirectUri))
        {
        }
#endif

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Organization Id accounts only.  
        /// This method will not display a dialog.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.  
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> for an example. </param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="username">The user name for the Organization Id account.</param>
        /// <param name="password">The password for the Organization Id account.</param>
        public UserTokenCredentials(string clientId, string domain, string username, string password) 
            : this(clientId, domain, username, password, AzureEnvironment.Azure)
        {
        }

        /// <summary>
        /// Creates a new UserAccessTokenCredentials object for Organization Id accounts only.  
        /// This method will not display a dialog.
        /// </summary>
        /// <param name="clientId">The active directory identity of this application.  
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> for an example. </param>
        /// <param name="domain">The domain name or tenant id containing the subscription or resources to manage.</param>
        /// <param name="username">The user name for the Organization Id account.</param>
        /// <param name="password">The password for the Organization Id account.</param>
        /// <param name="environment">The azure environment to authenticate with. </param>
        public UserTokenCredentials(string clientId, string domain, string username, string password, AzureEnvironment environment) 
            : base(new ActiveDirectoryUserTokenProvider(clientId, domain, username, password, environment))
        {
            
        }
    }
}
