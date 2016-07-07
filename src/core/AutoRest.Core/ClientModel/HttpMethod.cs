// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines available HTTP methods
    /// </summary>
    public enum HttpMethod
    {
        None = 0,
        Get,
        Post,
        Put,
        Patch,
        Delete,
        Head,
        Options
    }
}