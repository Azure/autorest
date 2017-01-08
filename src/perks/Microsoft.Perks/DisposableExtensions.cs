// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks {
    using System;

    public static class DisposableExtensions {
        public static IDisposable OnDispose(this Action action) => 
            new OnDispose(action);
    }
}