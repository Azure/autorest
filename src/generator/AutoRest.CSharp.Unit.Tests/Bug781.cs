// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;
using System.Reflection;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug781 : BugTest
    {

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/781
        ///     Autorest does not generate empty default constructor
        /// </summary>
        [Fact]
        public async Task EnsureNoEmptyCtorsGenerated()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // check for the expected class.
                Assert.True(fileSystem.FileExists(@"Models\ReqObject.cs"));

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
                var asm = LoadAssembly(result.Output);
                Assert.NotNull(asm);

                // verify that we have the class we expected
                var reqObject = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.ReqObject");
                
                // verify there is no ctor that does not take any args
                Assert.True(reqObject.GetConstructors().All(ctor => ctor.GetParameters().Any()));
            }
        }

    }
}
