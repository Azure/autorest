// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest
{
    /// <summary>
    /// Represents a collection that supports on-demand initialization.
    /// </summary>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", 
        "CA1711:IdentifiersShouldNotHaveIncorrectSuffix",
        Justification = "The name has been reviewed and decided. Changing it has too broad impact")]
    public interface ILazyCollection
    {
        /// <summary>
        /// True if collection has been initialized.
        /// </summary>
        bool IsInitialized { get; }
    }
}
