// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class AzureResourceSchemaCodeGenerator : CodeGenerator
    {
        public AzureResourceSchemaCodeGenerator(Settings settings)
            : base(settings)
        {
        }

        public override string Description
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        public override string ImplementationFileExtension
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        public override string Name
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        public override string UsageInstructions
        {
            get
            {
                return "MOCK USAGE INSTRUCTIONS";
            }
        }

        public override Task Generate(ServiceClient serviceClient)
        {
            throw new NotImplementedException();
        }

        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            throw new NotImplementedException();
        }
    }
}
