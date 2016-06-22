// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;

namespace Microsoft.Rest.Generator
{
    public class NoopCodeGenerator: CodeGenerator
    {
        public NoopCodeGenerator(Settings settings) : base(settings)
        {
        }

        public override string Description
        {
            get
            {
                return "No op code generator";
            }
        }

        public override string ImplementationFileExtension
        {
            get
            {
                return string.Empty;
            }
        }

        public override string Name
        {
            get
            {
                return "No op code generator";
            }
        }

        public override string UsageInstructions
        {
            get
            {
                return string.Empty;
            }
        }

        public override Task Generate(ServiceClient serviceClient)
        {
            return Task.FromResult(0);
        }

        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
        }
    }
}