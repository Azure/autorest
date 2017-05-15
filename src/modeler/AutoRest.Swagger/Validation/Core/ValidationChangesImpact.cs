// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Swagger.Validation.Core
{
    [Flags]
    public enum ValidationChangesImpact
    {
        None = 0,
        ServiceImpactingChanges = 1 << 0,
        SDKImpactingChanges = 1 << 1
    }
}
