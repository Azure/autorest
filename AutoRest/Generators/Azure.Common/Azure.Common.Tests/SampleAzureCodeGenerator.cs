// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;

namespace Microsoft.Rest.Modeler.Swagger.Azure.Tests
{
    public class SampleAzureCodeGenerator : AzureCodeGenerator
    {
        public SampleAzureCodeGenerator(Settings settings) : base(settings)
        {
        }

        public override string Name
        {
            get { throw new System.NotImplementedException(); }
        }

        public override string Description
        {
            get { throw new System.NotImplementedException(); }
        }

        public override string UsageInstructions
        {
            get { throw new System.NotImplementedException(); }
        }

        public override string ImplementationFileExtension
        {
            get { throw new System.NotImplementedException(); }
        }

        public override Task Generate(ServiceClient serviceClient)
        {
            throw new System.NotImplementedException();
        }
    }
}
