// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Model
{
    public class PropertyCs : Property
    {
        public override string ModelTypeName => ModelType.AsNullableType(this.IsNullable());

        public string HeaderCollectionPrefix => Extensions.GetValue<string>(SwaggerExtensions.HeaderCollectionPrefix);
        public bool IsHeaderCollection => !string.IsNullOrEmpty(HeaderCollectionPrefix);
    }
}