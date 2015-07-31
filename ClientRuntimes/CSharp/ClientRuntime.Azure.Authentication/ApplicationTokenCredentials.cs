// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// Credential object for authenticating as an Active Directory application.
    /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">
    /// Active Directory Quickstart for .Net</see> 
    /// for detailed instructions on creating an Azure Active Directory application.
    /// </summary>
    public class ApplicationTokenCredentials : TokenCredentials
    {
        /// <summary>
        /// Create credentials for authenticating as an Azure Active Directory application.
        /// </summary>
        /// <param name="clientId">The active directory application client id.</param>
        /// <param name="domain">The domain or tenant id containing this application.</param>
        /// <param name="secret">The authentication secret for the application.</param>
        public ApplicationTokenCredentials(string clientId, string domain, string secret)
            : this(clientId, domain, secret, ActiveDirectorySettings.Azure)
        {
        }

        /// <summary>
        /// Create credentials for authenticating as an Azure Active Directory application.
        /// </summary>
        /// <param name="clientId">The active directory application client id.</param>
        /// <param name="domain">The domain or tenant id containing this application.</param>
        /// <param name="secret">The authentication secret for the application.</param>
        /// <param name="activeDirectorySettings">The azure active directory settings to authenticate with.</param>
        public ApplicationTokenCredentials(string clientId, string domain, string secret, ActiveDirectorySettings activeDirectorySettings)
            : base(new ApplicationTokenProvider(clientId, domain, secret, activeDirectorySettings))
        {
        }
    }
}
