// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// Interface to platform-specific methods for securely storing client credentials
    /// </summary>
    public interface IApplicationCredentialProvider
    {
        /// <summary>
        /// Retrieve ClientCredentials for an active directory application.
        /// </summary>
        /// <param name="clientId">The active directory client Id of the application.</param>
        /// <returns>ClientCredential which can be used for silen authentication with active directory.</returns>
        Task<ClientCredential> GetCredentialAsync(string clientId);
    }
}
