using AutoRest.Core;
using AutoRest.Core.Model;

namespace AutoRest.Php
{
    public sealed class CodeGeneratorPhp : CodeGenerator
    {
        public override string ImplementationFileExtension => ".php";

        public override string UsageInstructions => string.Empty;

        public override async Task Generate(CodeModel codeModel)
            => await Write("PHP code", "my.php", false);
    }
}
