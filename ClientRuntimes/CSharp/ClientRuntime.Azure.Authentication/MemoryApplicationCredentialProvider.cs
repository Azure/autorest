// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace Microsoft.Rest.Azure.Authentication
{
    /// <summary>
    /// In memory store for application credentials.
    /// </summary>
    internal class MemoryApplicationCredentialProvider : IApplicationCredentialProvider
    {
        private IDictionary<string, ClientCredential> _credentials;

        /// <summary>
        /// Intializes an in-memory store of application credentials
        /// </summary>
        public MemoryApplicationCredentialProvider()
        {
            this._credentials = new Dictionary<string, ClientCredential>();
        }

        /// <summary>
        /// Initializes an in-memory store of application credentials starting with the given credential
        /// </summary>
        /// <param name="credential"></param>
        public MemoryApplicationCredentialProvider(ClientCredential credential)
            : this()
        {
            AddCredential(credential);
        }

        /// <summary>
        /// Add the given credential to the in-memory store.
        /// </summary>
        /// <param name="credential">The credential to add.</param>
        public void AddCredential(ClientCredential credential)
        {
            if (!_credentials.ContainsKey(credential.ClientId))
            {
                _credentials[credential.ClientId] = credential;
            }
        }

        /// <summary>
        /// Retireve a credential from the in-memory store.  Throw an AuthenticationException if no matching
        /// credential is found.
        /// </summary>
        /// <param name="clientId">The clientId to match.</param>
        /// <returns>The credential associated with the given client Id.</returns>
        public Task<ClientCredential> GetCredentialAsync(string clientId)
        {
            if (_credentials.ContainsKey(clientId))
            {
                return Task.FromResult(_credentials[clientId]);
            }

            throw new AuthenticationException("Matching credentials for client id '{0}' could not be found.");
        }
    }
}
