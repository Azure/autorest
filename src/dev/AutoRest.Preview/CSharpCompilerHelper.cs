using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core.Utilities;
using Microsoft.CodeAnalysis;
using Microsoft.Rest.CSharp.Compiler.Compilation;
using AutoRest.CSharp.Unit.Tests;
using System.Reflection;
using System.IO;

namespace AutoRest.Preview
{
    public static class CSharpCompilerHelper
    {
        private class HelpMethodExposer : BugTest
        {
            public new Task<CompilationResult> Compile(IFileSystem fileSystem) => base.Compile(fileSystem);

            public new Assembly LoadAssembly(MemoryStream stream) => base.LoadAssembly(stream);
        }

        internal static string[] SuppressWarnings = { "CS1701", "CS1702", "CS1591" };

        public static async Task<IEnumerable<Type>> CompileTypes(MemoryFileSystem fileSystem)
        {
            var helper = new HelpMethodExposer();

            // compile
            var result = await helper.Compile(fileSystem);

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
            var asm = helper.LoadAssembly(result.Output);
            if (asm == null)
            {
                throw new Exception("could not load assembly");
            }

            return asm.ExportedTypes;
        }
    }
}
