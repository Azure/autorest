// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;

namespace AutoRest.Python.Model
{
    public class SequenceTypePy : SequenceType, IExtendedModelTypePy
    {
        public SequenceTypePy()
        {
            Name.OnGet += v => $"list";
        }

        public string TypeDocumentation => $"list of {((IExtendedModelTypePy)ElementType).TypeDocumentation}";
        public string ReturnTypeDocumentation => $"list of {((IExtendedModelTypePy)ElementType).TypeDocumentation}";
    }
}