// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// Defines parameters used with user token credentials.
    /// </summary>
    public class ActiveDirectoryParameters
    {
        /// <summary>
        /// Gets or sets prompt behavior.
        /// </summary>
        public PromptBehavior PromptBehavior { get; set; }

        /// <summary>
        /// Gets or sets owner window.
        /// </summary>
        public object OwnerWindow { get; set; }

        /// <summary>
        /// Gets or sets token cache.
        /// </summary>
        public TokenCache TokenCache { get; set; }
    }
}
