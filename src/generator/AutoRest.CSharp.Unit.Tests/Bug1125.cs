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
    public class Bug1125 : BugTest
    {
        public Bug1125(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1125
        ///     Support format:'char' for single character strings.
        /// </summary>
        [Fact]
        public async Task SupportCharFormatForString()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObject.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObjectWithDefault.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObjectWithMinMax.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObjectWithExclusiveMinMax.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ParamObject.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ParamObjectWithDefault.cs"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // use this to dump the files to disk for examination
                // fileSystem.SaveFilesToTemp("bug1125");

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
                var resultObject = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.ResultObject");
                Assert.NotNull(resultObject);

                // verify the property is generated 
                var property = resultObject.GetProperty("SingleLetter");
                Assert.NotNull(property);

                // verify the type is as expected.
                Assert.Equal(property.PropertyType, typeof(char?));
            }
        }
    }
}