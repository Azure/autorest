using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Php.PhpBuilder;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Php
{
    public sealed class CodeGeneratorPhp : CodeGenerator
    {
        public override string ImplementationFileExtension => ".php";

        public override string UsageInstructions => string.Empty;

        public override async Task Generate(CodeModel codeModel)
        {
            var @namespace = Class.CreateName(codeModel.Namespace, codeModel.ApiVersion);
            var groups = codeModel.Operations.Select(o => new Class(
                Class.CreateName(@namespace, o.Name),
                o.Methods.Select(m => new PhpBuilder.Method(m.Name, m.Description))));
            var client = new Class(Class.CreateName(@namespace, "Client"));
            foreach (var class_ in groups.Concat(new[] { client }))
            {
                await Write(string.Join("\n", class_.ToStringList()), class_.GetFileName(), false);
            }
        }
    }
}
