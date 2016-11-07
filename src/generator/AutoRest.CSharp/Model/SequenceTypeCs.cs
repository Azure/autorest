// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.Model
{
    public class SequenceTypeCs : SequenceType
    {
        public SequenceTypeCs()
        {
            Name.OnGet += v => $"System.Collections.Generic.IList<{ElementType.AsNullableType(!ElementType.IsValueType() || (this.IsXNullable ?? true))}>";
        }

        public virtual bool? IsXNullable => Extensions.Get<bool>("x-nullable");
    }

    public class DictionaryTypeCs : DictionaryType
    {
        public DictionaryTypeCs()
        {
            Name.OnGet += v => $"System.Collections.Generic.IDictionary<string, {ValueType.AsNullableType(!ValueType.IsValueType() || (this.IsXNullable ?? true))}>";
        }

        public virtual bool? IsXNullable => Extensions.Get<bool>("x-nullable");
    }
}