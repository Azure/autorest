// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Azure
{
    /// <summary>
    /// Credentials for use with a Azure Mobile Services.
    /// </summary>
    public class MobileServicesCredentials : TokenCredentials
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="MobileServicesCredentials"/>.
        /// </summary>
        /// <param name="token">Valid token.</param>
        public MobileServicesCredentials(string token)
            : base("x-zumo-auth", token)
        { }
    }
}
