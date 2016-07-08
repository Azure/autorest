// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// License information for the defined API.
    /// </summary>
    [Serializable]
    public class License
    {
        /// <summary>
        /// Name of the license governing the API.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// URL of the licensing governing the API.
        /// </summary>
        public string Url { get; set; }
    }
}
