// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Azure.Authentication
{
    /// <summary>
    /// Credential object for authenticating as an application, using a servicePrincipal and se cret
    /// </summary>
    public class ApplicationAccessTokenCredentials : AccessTokenCredentials
    {
        /// <summary>
        /// Create credentials for authenticating as an Azure Active Directory application.
        /// </summary>
        /// <param name="domain">The doamin or tenant id contianing this application.</param>
        /// <param name="applicationId">The active directory application id.</param>
        /// <param name="secret">The authentication secret for the application.</param>
        public ApplicationAccessTokenCredentials(string domain, string applicationId, string secret) : 
            this(domain, applicationId, secret, AzureEnvironment.Azure)
        {
        }

        /// <summary>
        /// Create credentials for authenticating as an Azure Active Directory application.
        /// </summary>
        /// <param name="domain">The doamin or tenant id contianing this application.</param>
        /// <param name="applicationId">The active directory application id.</param>
        /// <param name="secret">The authentication secret for the application.</param>
        /// <param name="azureEnvironment">The azure environment to authenticate with.</param>
        public ApplicationAccessTokenCredentials(string domain, string applicationId, string secret, AzureEnvironment azureEnvironment) : 
            base(new ActiveDirectoryApplicationTokenProvider(domain, applicationId, secret, azureEnvironment))
        {
        }

        /// <summary>
        /// Create access token credentials given a token provider.
        /// </summary>
        /// <param name="tokenProvider">The source of authentication tokens for these credentials.</param>
        public ApplicationAccessTokenCredentials(ITokenProvider tokenProvider) : base(tokenProvider)
        {
        }
   }
}
