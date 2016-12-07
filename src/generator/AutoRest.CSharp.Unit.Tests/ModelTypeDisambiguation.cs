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
    public class ModelTypeDisambiguation : BugTest
    {
        public ModelTypeDisambiguation(ITestOutputHelper output) : base(output)
        {
        }
        
        /// <summary>
        /// Checks the mapping from inline schemas to generated types.
        /// </summary>
        [Fact]
        public async Task CheckModelTypeDisambiguation()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\SimpleAPIExtensions.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\CowbellOKResponse.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\CowbellOKResponseModel.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\CowbellOKResponseModelModel.cs"));

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

                // retrieve generated model types (concrete names of those types may change, please adjust this test case accordingly)
                var cowbellResponse = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.CowbellOKResponseModel");
                var cowbellResponseInt = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.CowbellOKResponse");
                var cowbellResponseBool = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.CowbellOKResponseModelModel");

                // validate model types
                var cowbellResponseProp = cowbellResponse.GetProperty("PropResponse");
                var cowbellResponseIntProp = cowbellResponseInt.GetProperty("PropParamInt");
                var cowbellResponseBoolProp = cowbellResponseBool.GetProperty("PropParamBool");
                Assert.NotNull(cowbellResponseProp);
                Assert.NotNull(cowbellResponseIntProp);
                Assert.NotNull(cowbellResponseBoolProp);
                Assert.Equal(typeof(string), cowbellResponseProp.PropertyType);
                Assert.Equal(typeof(int?), cowbellResponseIntProp.PropertyType);
                Assert.Equal(typeof(bool?), cowbellResponseBoolProp.PropertyType);

                // verify that signatures are correct
                var simpleApiExtensions = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.SimpleAPIExtensions");
                Assert.NotNull(simpleApiExtensions);
                var cowbellMethod0 = simpleApiExtensions.GetMethod("Cowbell");
                var cowbellMethod1 = simpleApiExtensions.GetMethod("Cowbell1");
                var cowbellMethod2 = simpleApiExtensions.GetMethod("Cowbell2");
                var cowbellMethod3 = simpleApiExtensions.GetMethod("Cowbell3");
                Assert.NotNull(cowbellMethod0);
                Assert.NotNull(cowbellMethod1);
                Assert.NotNull(cowbellMethod2);
                Assert.NotNull(cowbellMethod3);
                var cowbellMethod0Param = cowbellMethod0.GetParameters().FirstOrDefault(p => p.Name == "cowbellOKResponse");
                var cowbellMethod1Param = cowbellMethod1.GetParameters().FirstOrDefault(p => p.Name == "cowbellOKResponse");
                var cowbellMethod2Param = cowbellMethod2.GetParameters().FirstOrDefault(p => p.Name == "cowbellOKResponse");
                var cowbellMethod3Param = cowbellMethod3.GetParameters().FirstOrDefault(p => p.Name == "cowbellOKResponse");
                Assert.NotNull(cowbellMethod0Param);
                Assert.NotNull(cowbellMethod1Param);
                Assert.NotNull(cowbellMethod2Param);
                Assert.NotNull(cowbellMethod3Param);

                Assert.Equal(cowbellResponseInt, cowbellMethod0Param.ParameterType);
                Assert.Equal(cowbellResponseBool, cowbellMethod1Param.ParameterType);
                Assert.Equal(typeof(int?), cowbellMethod2Param.ParameterType);
                Assert.Equal(cowbellResponseBool, cowbellMethod3Param.ParameterType);

                Assert.Equal(cowbellResponse, cowbellMethod0.ReturnType);
                Assert.Equal(typeof(void), cowbellMethod1.ReturnType);
                Assert.Equal(typeof(void), cowbellMethod2.ReturnType);
                Assert.Equal(typeof(void), cowbellMethod3.ReturnType);
            }
        }
    }
}