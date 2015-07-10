// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Azure
{
    /// <summary>
    /// Interface to a provider of access tokens
    /// </summary>
    public interface ITokenProvider
    {
        /// <summary>
        /// Gets the text of the access token.
        /// </summary>
        Task<string> GetAccessTokenAsync(CancellationToken cancellationToken);
    }
}
