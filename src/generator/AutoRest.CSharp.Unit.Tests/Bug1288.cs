// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1288 : BugTest
    {
        public Bug1288(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1288
        ///     Support format:'char' for single character strings.
        /// </summary>
        [Fact]
        public async Task CompositeSwaggerWithPayloadFlattening()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec(modeler: "CompositeSwagger"))
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\CompositeModel.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\Param1.cs"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // use this to dump the files to disk for examination
                // fileSystem.SaveFilesToTemp("bug1288");

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
                
                // verify that we have the composite class we expected
                var testCompositeObject = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.CompositeModel");
                Assert.NotNull(testCompositeObject);
                
                // verify that we have the class we expected
                var testObject = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.Param1");
                Assert.NotNull(testObject);

                // verify the property is generated 
                var property1 = testObject.GetProperty("Prop1");
                Assert.NotNull(property1);
                // verify the property is generated 
                var property2 = testObject.GetProperty("Prop2");
                Assert.NotNull(property2);
                
            }
        }
    }
}