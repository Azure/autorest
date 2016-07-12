// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Threading.Tasks;

namespace AutoRest.Core
{
    /// <summary>
    /// Defines methods to manipulate templates.
    /// </summary>
    public interface ITemplate
    {
        /// <summary>
        /// Gets or sets settings.
        /// </summary>
        Settings Settings { get; set; }

        /// <summary>
        /// Gets or sets the output stream.
        /// </summary>
        TextWriter TextWriter { get; set; }

        /// <summary>
        /// Execute an individual request.
        /// </summary>
        Task ExecuteAsync();
    }
}
