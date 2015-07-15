// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace Microsoft.Azure.Authentication
{
    /// <summary>
    /// Settings for authentication with an Azure or Azure Stack service
    /// </summary>
    public sealed class AzureEnvironment
    {
        private static readonly AzureEnvironment AzureSettings = new AzureEnvironment
        {
            AuthenticationEndpoint= new Uri("https://login.windows.net/"), 
            TokenAudience = new Uri("https://management.core.windows.net/"),
            ValidateAuthority = true
        };

        private static readonly AzureEnvironment AzureChinaSettings = new AzureEnvironment
        {
            AuthenticationEndpoint= new Uri("https://login.chinacloudapi.cn/"), 
            TokenAudience = new Uri("https://management.core.chinacloudapi.cn/"),
            ValidateAuthority = true
        };

        /// <summary>
        /// Gets the settings for authentication with Azure
        /// </summary>
        public static AzureEnvironment Azure { get { return AzureSettings; } }

        /// <summary>
        /// Gets the settings for authentication with Azure China
        /// </summary>
        public static AzureEnvironment AzureChina { get { return AzureChinaSettings; } }

        /// <summary>
        /// Gets or sets the ActiveDirectory Endpoint for the Azure Environment
        /// </summary>
        public Uri AuthenticationEndpoint { get; set; }

        /// <summary>
        /// Gets or sets the Token audience for an endpoint
        /// </summary>
        public Uri TokenAudience { get; set; }

        /// <summary>
        /// Gets or sets a value that determines whether the authentication endpoint should be validated with Azure AD
        /// </summary>
        public bool ValidateAuthority { get; set; }
    }
}
