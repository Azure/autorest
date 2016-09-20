// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using System.Threading.Tasks;

namespace AutoRest.Core
{
    public class NoOpCodeGenerator: CodeGenerator
    {
        public NoOpCodeGenerator() : base( new CodeModelTransformer())
        {
        }

        public override string Description => "No op code generator";

        public override string ImplementationFileExtension => string.Empty;

        public override string Name => "No op code generator";

        public override string UsageInstructions => string.Empty;

        public override Task Generate(CodeModel codeModel) => Task.FromResult(0);
    }
}