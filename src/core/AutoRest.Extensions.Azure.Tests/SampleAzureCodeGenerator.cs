// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;

namespace AutoRest.Extensions.Azure.Tests
{
    public class SampleAzureCodeGenerator : CodeGenerator
    {
        public SampleAzureCodeGenerator() : base(new CodeModelTransformer())
        {
        }

        public override string Name => null;

        public override string Description => null;

        public override string UsageInstructions => null;

        public override string ImplementationFileExtension => null;

        public override Task Generate(CodeModel codeModel) => null;
    }
}
