// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1214 : BugTest
    {
        public Bug1214(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1214
        ///     Support format:'char' for single character strings.
        /// </summary>
        [Fact]
        public async Task PropertyNamesWithLeadingUnderscores()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\TestObject.cs"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // use this to dump the files to disk for examination
                // fileSystem.SaveFilesToTemp("bug1214");

                // Or just use this to see the generated code in VsCode :D
                // ShowGeneratedCode(fileSystem);

                // filter the errors
                var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                Write(warnings, fileSystem);
                Write(errors, fileSystem);

                // use this to write out all the messages, even hidden ones.
                // Write(result.Messages, fileSystem);

                // Don't proceed unless we have zero Warnings.
                Assert.Empty(warnings);

                // Don't proceed unless we have zero Errors.
                Assert.Empty(errors);

                // Should also succeed.
                Assert.True(result.Succeeded);

                // try to load the assembly
                var asm = Assembly.Load(result.Output.GetBuffer());
                Assert.NotNull(asm);

                // verify that we have the class we expected
                var testObject = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.TestObject");
                Assert.NotNull(testObject);

                // verify the property is generated 
                var property1 = testObject.GetProperty("_name");
                Assert.NotNull(property1);
                
                // verify the property is generated 
                var property2 = testObject.GetProperty("Name");
                Assert.NotNull(property2);

                // verify the property is generated 
                var property3 = testObject.GetProperty("_namE");
                Assert.NotNull(property3);
                
            }
        }
    }
}