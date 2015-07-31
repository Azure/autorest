// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest.Azure.Authentication.Properties;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// Settings for authentication with an Azure or Azure Stack service using Active Directory.
    /// </summary>
    public sealed class ActiveDirectorySettings : ICloneable
    {
        private Uri _authenticationEndpoint;
        /// <summary>
        /// Query string allowing use of cookies in user login dialog
        /// </summary>
        public const string EnableEbdMagicCookie = "site_id=501358&display=popup";

        /// <summary>
        /// Initializes default active directory dialog parameters.
        /// </summary>
        public ActiveDirectorySettings()
        {
            this.PromptBehavior = PromptBehavior.Auto;
            this.UserIdentifier = UserIdentifier.AnyUser;
            this.AdditionalQueryParameters = EnableEbdMagicCookie;
        }

        private static readonly ActiveDirectorySettings AzureSettings = new ActiveDirectorySettings
        {
            AuthenticationEndpoint= new Uri("https://login.windows.net/"), 
            TokenAudience = new Uri("https://management.core.windows.net/"),
            ValidateAuthority = true
        };

        private static readonly ActiveDirectorySettings AzureChinaSettings = new ActiveDirectorySettings
        {
            AuthenticationEndpoint= new Uri("https://login.chinacloudapi.cn/"), 
            TokenAudience = new Uri("https://management.core.chinacloudapi.cn/"),
            ValidateAuthority = true
        };

        /// <summary>
        /// Gets the settings for authentication with Azure
        /// </summary>
        public static ActiveDirectorySettings Azure { get { return AzureSettings; } }

        /// <summary>
        /// Gets the settings for authentication with Azure China
        /// </summary>
        public static ActiveDirectorySettings AzureChina { get { return AzureChinaSettings; } }

        /// <summary>
        /// Gets or sets the ActiveDirectory Endpoint for the Azure Environment
        /// </summary>
        public Uri AuthenticationEndpoint 
        {
            get { return _authenticationEndpoint; }
            set { _authenticationEndpoint = EnsureTrailingSlash(value); } 
        }

        /// <summary>
        /// Gets or sets the Token audience for an endpoint
        /// </summary>
        public Uri TokenAudience { get; set; }

        /// <summary>
        /// Gets or sets a value that determines whether the authentication endpoint should be validated with Azure AD
        /// </summary>
        public bool ValidateAuthority { get; set; }

                /// <summary>
        /// Gets or sets prompt behavior.
        /// </summary>
        public PromptBehavior PromptBehavior { get; set; }

        /// <summary>
        /// Gets or sets owner window.
        /// </summary>
        public object OwnerWindow { get; set; }

        /// <summary>
        /// The user identifier to be diaplayed in the dialog
        /// </summary>
        public UserIdentifier UserIdentifier { get; set; }

        /// <summary>
        /// Additional query parameters sent with the AD request
        /// </summary>
        public string AdditionalQueryParameters { get; set; }

        private static Uri EnsureTrailingSlash(Uri authenticationEndpoint)
        {
            if (authenticationEndpoint == null)
            {
                throw new ArgumentNullException("authenticationEndpoint");
            }

            UriBuilder builder = new UriBuilder(authenticationEndpoint);
            if (!string.IsNullOrEmpty(builder.Query))
            {
                throw new ArgumentOutOfRangeException(Resources.AuthenticationEndpointContainsQuery);
            }

            var path = builder.Path;
            if (string.IsNullOrWhiteSpace(path))
            {
                path = "/";
            }
            else if (!path.EndsWith("/", StringComparison.Ordinal))
            {
                path = path + "/";
            }

            builder.Path = path;
            return builder.Uri;
        }

        public object Clone()
        {
            return new ActiveDirectorySettings
            {
                AdditionalQueryParameters = this.AdditionalQueryParameters,
                AuthenticationEndpoint = this.AuthenticationEndpoint,
                OwnerWindow = this.OwnerWindow,
                PromptBehavior = this.PromptBehavior,
                TokenAudience = this.TokenAudience,
                UserIdentifier = this.UserIdentifier,
                ValidateAuthority = this.ValidateAuthority
            };
        }
    }
}
