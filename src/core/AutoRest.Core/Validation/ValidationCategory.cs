// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Core.Validation
{
    [Flags]
    public enum ValidationCategory
    {
        RPCViolation    = 1 << 0,
        OneAPIViolation = 1 << 1,
        SDKViolation    = 1 << 2,
    }
}
