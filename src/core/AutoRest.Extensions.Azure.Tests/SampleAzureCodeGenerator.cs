// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.ClientModel;

namespace AutoRest.Extensions.Azure.Tests
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
