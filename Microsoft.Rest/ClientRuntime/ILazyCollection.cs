// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest
{
    public interface ILazyCollection<T> : ICollection<T>
    {
        /// <summary>
        /// True if collection has been initialized.
        /// </summary>
        bool IsInitialized { get; }
    }
}
