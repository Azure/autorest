// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using System.Threading.Tasks;
using AutoRest.Core.Extensibility;

namespace AutoRest.Core
{
    
    public class NoOpPlugin :
        Plugin<NoOpPlugin.NoSettings, CodeModelTransformer<CodeModel>, NoOpCodeGenerator, CodeNamer, CodeModel>
    {
        public class NoSettings : IGeneratorSettings
        {
            public virtual string Description => "No op code generator";
        }
    }

    public class NoOpCodeGenerator: CodeGenerator
    {
        public NoOpCodeGenerator()
        {
        }

        public override string UsageInstructions => string.Empty;

        public override string ImplementationFileExtension => string.Empty;


        public override Task Generate(CodeModel codeModel) => Task.FromResult(0);
    }
}