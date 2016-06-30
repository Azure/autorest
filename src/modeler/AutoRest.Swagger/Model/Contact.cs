// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Contact information for the defined API.
    /// </summary>
    [Serializable]
    public class Contact
    {
        /// <summary>
        /// Name of the API contact.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Url of the API contact.
        /// </summary>
        public string Url { get; set; }

        /// <summary>
        /// Email of the API contact.
        /// </summary>
        public string Email { get; set; }
    }
}