// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Core.Validation
{
    [Flags]
    public enum ValidationCategory
    {
        None            = 1 << 0,
        RPCViolation    = 1 << 1,
        OneAPIViolation = 1 << 2,
        SDKViolation    = 1 << 3
    }
}
