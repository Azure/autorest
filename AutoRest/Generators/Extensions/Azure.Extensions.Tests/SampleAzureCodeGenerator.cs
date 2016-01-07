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
    public class SampleAzureCodeGenerator : CodeGenerator
    {
        public SampleAzureCodeGenerator(Settings settings) : base(settings)
        {
        }

        public override string Name
        {
            get { return null; }
        }

        public override string Description
        {
            get { return null; }
        }

        public override string UsageInstructions
        {
            get { return null; }
        }

        public override string ImplementationFileExtension
        {
            get { return null; }
        }

        public override Task Generate(ServiceClient serviceClient)
        {
            return null;
        }

        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            AzureExtensions.NormalizeAzureClientModel(serviceClient, Settings, new SampleAzureCodeNamer());
        }
    }
}
