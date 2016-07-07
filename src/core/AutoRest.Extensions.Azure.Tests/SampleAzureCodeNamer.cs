// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.ClientModel;

namespace AutoRest.Extensions.Azure.Tests
{
    public class SampleAzureCodeNamer : CodeNamer
    {
        public SampleAzureCodeNamer()
        {
        }

        public override IType NormalizeTypeReference(IType type)
        {
            // Do nothing
            return type;
        }

        public override IType NormalizeTypeDeclaration(IType type)
        {
            // Do nothing
            return type;
        }

        public override string EscapeDefaultValue(string defaultValue, IType type)
        {
            return defaultValue;
        }
    }
}
