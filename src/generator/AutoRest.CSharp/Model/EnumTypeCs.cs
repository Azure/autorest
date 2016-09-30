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

        public bool IsValueType => !ModelAsString; 
    }
}