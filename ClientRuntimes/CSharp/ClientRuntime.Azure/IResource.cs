// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json;

namespace Microsoft.Azure
{
    /// <summary>
    /// Defines interface for Azure resource.
    /// </summary>
    public interface IResource
    {
        /// <summary>
        /// Gets the ID of the resource.
        /// </summary>
        string Id { get; }

        /// <summary>
        /// Gets the provisioning state of the resource.
        /// </summary>
        string ProvisioningState { get; }
    }
}
