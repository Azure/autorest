using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using System.Diagnostics;
using System.IO;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests.Resource
{
    public class Bug1754 : BugTest
    {

        public Bug1754(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1754
        ///     Verifies autorest succesfully generates code 
        ///     for async extension methods that calls .Dispose()
        ///     on HTTP response objects
        /// </summary>
        [Fact]
        public async Task EnsureHttpMessageAsyncDispose()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // check for the expected class.
                Assert.True(fileSystem.FileExists(@"GeneratedCode\TestOperationsExtensions.cs"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // filter the errors
                var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                Write(warnings, fileSystem);
                Write(errors, fileSystem);

                // Don't proceed unless we have zero Warnings.
                Assert.Empty(warnings);

                // Don't proceed unless we have zero Errors.
                Assert.Empty(errors);

                // Should also succeed.
                Assert.True(result.Succeeded);


                // try to load the assembly
                var asm = Assembly.Load(result.Output.GetBuffer());
                Assert.NotNull(asm);

                // verify that parameter is of correct type
                var testApi = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.TestOperationsExtensions");
                Assert.NotNull(testApi);
                var testApiMethod = testApi.GetMethod("PutAsync");
                Assert.NotNull(testApiMethod);
            }
        }
    }
}
