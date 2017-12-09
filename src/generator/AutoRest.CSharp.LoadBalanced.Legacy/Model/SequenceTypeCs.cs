// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Model
{
    public class SequenceTypeCs : SequenceType
    {
        public SequenceTypeCs()
        {
            Name.OnGet += v => $"System.Collections.Generic.List<{ElementType.AsNullableType(!ElementType.IsValueType() || IsNullable)}>";
        }

        public virtual bool IsNullable => Extensions.Get<bool>("x-nullable") ?? true;
    }

    public class DictionaryTypeCs : DictionaryType
    {
        public DictionaryTypeCs()
        {
            Name.OnGet += v => $"System.Collections.Generic.IDictionary<string, {ValueType.AsNullableType(!ValueType.IsValueType() || IsNullable)}>";
        }

        public virtual bool IsNullable => Extensions.Get<bool>("x-nullable") ?? true;
    }
}