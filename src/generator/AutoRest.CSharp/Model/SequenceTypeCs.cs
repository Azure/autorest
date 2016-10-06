// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;

namespace AutoRest.CSharp.Model
{
    public class SequenceTypeCs : SequenceType
    {
        public SequenceTypeCs()
        {
            Name.OnGet += v => $"System.Collections.Generic.IList<{ElementType.AsNullableType()}>";
        }
    }

    public class DictionaryTypeCs : DictionaryType
    {
        public DictionaryTypeCs()
        {
            Name.OnGet += v => $"System.Collections.Generic.IDictionary<string, {ValueType.AsNullableType()}>";
        }
    }
}