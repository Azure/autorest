// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.Azure.Extensions;
using Microsoft.Rest.Generator.ClientModel;

namespace Microsoft.Rest.Modeler.Swagger.Azure.Tests
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
    }
}
