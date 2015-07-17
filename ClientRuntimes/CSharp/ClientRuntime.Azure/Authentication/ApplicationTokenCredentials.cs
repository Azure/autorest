// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest;

namespace Microsoft.Azure.Authentication
{
    /// <summary>
    /// Credential object for authenticating as an Active Directory application.
    /// </summary>
    public class ApplicationTokenCredentials : TokenCredentials
    {
        /// <summary>
        /// Create credentials for authenticating as an Azure Active Directory application.
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> 
        /// for detailed instructions on creating an Azure Active Directory application.
        /// </summary>
        /// <param name="domain">The doamin or tenant id contianing this application.</param>
        /// <param name="clientId">The active directory application client id.</param>
        /// <param name="secret">The authentication secret for the application.</param>
        public ApplicationTokenCredentials(string domain, string clientId, string secret)
            : this(domain, clientId, secret, AzureEnvironment.Azure)
        {
        }

        /// <summary>
        /// Create credentials for authenticating as an Azure Active Directory application.
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> 
        /// for detailed instructions on creating an Azure Active Directory application.
        /// </summary>
        /// <param name="domain">The doamin or tenant id contianing this application.</param>
        /// <param name="clientId">The active directory application client id.</param>
        /// <param name="secret">The authentication secret for the application.</param>
        /// <param name="azureEnvironment">The azure environment to authenticate with.</param>
        public ApplicationTokenCredentials(string domain, string clientId, string secret, AzureEnvironment azureEnvironment)
            : base(new ActiveDirectoryApplicationTokenProvider(domain, clientId, secret, azureEnvironment))
        {
        }
    }
}
