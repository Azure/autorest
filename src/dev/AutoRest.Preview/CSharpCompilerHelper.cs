using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using AutoRest.Core.Utilities;
using Microsoft.CodeAnalysis;
using Microsoft.Rest.CSharp.Compiler.Compilation;

namespace AutoRest.Preview
{
    public static class CSharpCompilerHelper
    {
        private static readonly string[] SuppressWarnings = { "CS1701", "CS1591" };

        private static async Task<CompilationResult> Compile(IFileSystem fileSystem)
        {
            var compiler = new CSharpCompiler(
                fileSystem.GetFiles("GeneratedCode", "*.cs", SearchOption.AllDirectories)
                    .Select(each => new KeyValuePair<string, string>(each, fileSystem.ReadFileAsText(each))).ToArray(),
                ManagedAssets.FrameworkAssemblies.Concat(
                    AppDomain.CurrentDomain.GetAssemblies()
                        .Where(each => !each.IsDynamic && !string.IsNullOrEmpty(each.Location))
                        .Select(each => each.Location)
                        .Concat(new[]
                        {
                            Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                                "Microsoft.Rest.ClientRuntime.dll"),
                            Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                                "Microsoft.Rest.ClientRuntime.Azure.dll")
                        })
                ));

            return await compiler.Compile(Microsoft.Rest.CSharp.Compiler.Compilation.OutputKind.DynamicallyLinkedLibrary);
        }

        public static async Task<IEnumerable<Type>> CompileTypes(MemoryFileSystem fileSystem)
        {
            // compile
            var result = await Compile(fileSystem);

            // filter the warnings
            var warnings = result.Messages.Where(
                each => each.Severity == DiagnosticSeverity.Warning
                        && !SuppressWarnings.Contains(each.Id)).ToArray();

            // filter the errors
            var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

            if (!result.Succeeded)
            {
                throw new Exception("compilation failed: " + string.Join(", ", errors.Concat(warnings)));
            }

            // try to load the assembly
            var asm = Assembly.Load(result.Output.GetBuffer());
            if (asm == null)
            {
                throw new Exception("could not load assembly");
            }

            return asm.ExportedTypes;
        }
    }
}
