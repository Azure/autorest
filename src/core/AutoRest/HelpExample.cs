// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest
{
    /// <summary>
    /// Structure that represents an example in generated help.
    /// </summary>
    public struct HelpExample
    {
        /// <summary>
        /// Gets or sets example plain text description.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets example code.
        /// </summary>
        public string Example { get; set; }
    }
}
