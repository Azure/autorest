// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Security;

namespace Microsoft.Azure
{
    /// <summary>
    /// Provides tokens for Azure Active Directory Microsoft Id, Organization Id, and Service Principal users
    /// </summary>
    internal class ActiveDirectoryTokenProvider : ITokenProvider
    {
        private string _accessToken;

        /// <summary>
        /// Gets or sets the authentication settings for this installation of active directory
        /// </summary>
        public AzureEnvironment Environment { get; set; }

        /// <summary>
        /// Gets or sets the user of application id used for authentication.
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// Gets or sets the domain or tenant id to authenticate with.
        /// </summary>
        public string Domain { get; set; }

        /// <summary>
        /// Gets or sets the application secret or user password used in authentication.
        /// </summary>
        public SecureString Secret { get; set; }

        /// <summary>
        /// Gets or sets the application id for the client that is authentating agaisnt Active Directory
        /// </summary>
        public string ClientId { get; set; }

        /// <summary>
        /// Gets an access token from the token cache or from AD authentication endpoint.  Will attempt to 
        /// refresh the access token if it has expired.
        /// </summary>
        public string AccessToken
        {
            get
            {
                if (TokenExpired())
                {
                    RefreshToken();
                }

                return _accessToken;
            }
        }

        private void RefreshToken()
        {
            throw new NotImplementedException();
        }

        private bool TokenExpired()
        {
            throw new NotImplementedException();
        }

        public void Initialize()
        {
            throw new NotImplementedException();
        }
    }
}
