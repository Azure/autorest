// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using System.Collections.Generic;

namespace AutoRest.Go.Model
{
    public class SequenceTypeGo : SequenceType
    {
        public SequenceTypeGo() : base()
        {
            Name.OnGet += v => $"[]{ElementType.Name}";
        }

        /// <summary>
        /// Add imports for sequence type.
        /// </summary>
        /// <param name="imports"></param>
        public void AddImports(HashSet<string> imports)
        {
            ElementType.AddImports(imports);
        }

        public string GetElement => $"{ElementType.Name}";

        public string GetEmptyCheck(string valueReference, bool asEmpty)
        {
            return string.Format(asEmpty
                                   ? "{0} == nil || len({0}) == 0"
                                   : "{0} != nil && len({0}) > 0", valueReference);
        }
    }
}
