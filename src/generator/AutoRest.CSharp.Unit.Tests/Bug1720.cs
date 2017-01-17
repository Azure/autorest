using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using AutoRest.Core.Utilities;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;


namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1720 : BugTest
    {
        public Bug1720(ITestOutputHelper output) : base(output)
        {
        }

        [Fact]
        public async Task PolymorphicTypesAreNotConstants()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\JobDefinitionsOperations.cs"));

                var result = await Compile(fileSystem);
                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // filter the errors
                var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                Write(warnings, fileSystem);
                Write(errors, fileSystem);

                // use this to write out all the messages, even hidden ones.
                // Write(result.Messages, fileSystem);

                // Don't proceed unless we have zero warnings.
                Assert.Empty(warnings);
                // Don't proceed unless we have zero Errors.
                Assert.Empty(errors);

                // Should also succeed.
                Assert.True(result.Succeeded);

                // try to load the assembly
                var asm = Assembly.Load(result.Output.GetBuffer());
                Assert.NotNull(asm);

                // verify that class with the expected name is present
                var ops = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.JobDefinitionsOperationsExtensions");
                Assert.NotNull(ops);

                // verify the method is there.
                var method = ops.GetMethod("ListResults");
                Assert.NotNull(method);

                // verify that the parameter is there.
                Assert.True(method.GetParameters().Any(each => each.Name.EqualsIgnoreCase("DataServiceResultQuery")));
            }
        }
    }
}