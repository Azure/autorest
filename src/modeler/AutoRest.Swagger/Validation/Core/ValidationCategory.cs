// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Swagger.Validation.Core
{
    [Flags]
    public enum ValidationCategory
    {
        None            = 0,
        RPCViolation    = 1 << 0,
        OneAPIViolation = 1 << 1,
        SDKViolation    = 1 << 2
    }
}
