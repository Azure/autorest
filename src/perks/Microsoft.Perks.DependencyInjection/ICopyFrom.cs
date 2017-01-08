// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks {
    public interface ICopyFrom {
        bool CopyFrom(object source);
    }

    public interface ICopyFrom<in T> : ICopyFrom {
        bool CopyFrom(T source);
    }
}