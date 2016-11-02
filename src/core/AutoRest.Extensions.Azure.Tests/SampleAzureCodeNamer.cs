// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Model;

namespace AutoRest.Extensions.Azure.Tests
{
    public class SampleAzureCodeNamer : CodeNamer
    {
        public SampleAzureCodeNamer()
        {
        }

        public override IModelType NormalizeTypeReference(IModelType type)
        {
            // Do nothing
            return type;
        }

        public override IModelType NormalizeTypeDeclaration(IModelType type)
        {
            // Do nothing
            return type;
        }

        public override string EscapeDefaultValue(string defaultValue, IModelType type)
        {
            return defaultValue;
        }
    }
}
