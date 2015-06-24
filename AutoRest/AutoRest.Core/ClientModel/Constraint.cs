// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.ClientModel
{
    /// <summary>
    /// Defines constraints to be used with Property and Parameter types.
    /// </summary>
    public enum Constraint
    {
        None,
        InclusiveMaximum,
        ExclusiveMaximum,
        InclusiveMinimum,
        ExclusiveMinimum,
        MaxLength,
        MinLength,
        Pattern,
        MaxItems,
        MinItems,
        UniqueItems,
        MultipleOf
    }
}