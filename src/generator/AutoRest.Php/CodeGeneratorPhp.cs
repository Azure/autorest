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
            var operations = codeModel.Operations;
            var groups = operations.Select(o => new Class(
                name: Class.CreateName(@namespace, o.Name),
                methods: o.Methods.Select(m => new PhpBuilder.Method(m.Name, m.Description))));
            var client = new Class(
                name: Class.CreateName(@namespace, "Client"),
                methods: operations.Select(o => new PhpBuilder.Method(o.Name)),
                properties: operations.Select(o => new PhpBuilder.Property(o.Name)));
            foreach (var class_ in groups.Concat(new[] { client }))
            {
                await Write(string.Join("\n", class_.ToLines()), class_.GetFileName(), false);
            }
        }
    }
}
