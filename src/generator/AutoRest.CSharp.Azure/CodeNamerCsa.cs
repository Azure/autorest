// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.Azure
{
    public class CodeNamerCsa : CodeNamerCs
    {
        public override string GetClientName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return PascalCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Model"))).EnsureEndsWith("Client");
        }
    }
}