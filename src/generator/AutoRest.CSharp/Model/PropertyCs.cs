// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;

namespace AutoRest.CSharp.Model
{
    public class PropertyCs : Property
    {
        public override string ModelTypeName => ModelType.AsNullableType(this.IsNullable());
    }
}