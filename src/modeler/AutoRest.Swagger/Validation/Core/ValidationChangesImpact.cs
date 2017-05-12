// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Swagger.Validation.Core
{
    [Flags]
    public enum ValidationChangesImpact
    {
        ServiceImpactingChanges = 0,
        SDKImpactingChanges = 1 << 0
    }
}
