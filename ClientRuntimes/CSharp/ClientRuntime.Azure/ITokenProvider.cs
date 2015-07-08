// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Azure
{
    /// <summary>
    /// Interface to a provider of access tokens
    /// </summary>
    internal interface ITokenProvider
    {
        /// <summary>
        /// Perform setup steps for the token provider.
        /// </summary>
        void Initialize();

        /// <summary>
        /// Gets the text of the access token.
        /// </summary>
        string AccessToken { get; }
    }
}
