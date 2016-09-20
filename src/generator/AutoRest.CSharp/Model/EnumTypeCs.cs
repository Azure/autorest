// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core;
using AutoRest.Core.Model;

namespace AutoRest.CSharp.Model
{
    public class EnumTypeCs : EnumType, IExtendedModelType
    {
        protected override string ModelAsStringType => "string";

        internal static HashSet<EnumType> EnumTypesThatWereUsedNullable { get; } = new HashSet<EnumType>();

        public bool IsForcedNullable => Settings.Instance.QuirksMode && EnumTypesThatWereUsedNullable.Contains(this);

        public bool CanBeMadeNullable => !ModelAsString;

        public bool IsValueType => !ModelAsString; 
    }
}