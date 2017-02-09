// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

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
    public class Bug1710 : BugTest
    {

        public Bug1710(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1710
        ///     Verifies autorest respects the XNullable flag 
        ///     for response objects and generates method signatures 
        ///     with appropriate return types
        /// </summary>
        [Fact]
        public async Task VerifyNonNullableReturnTypes()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // check for the expected class.
                Assert.True(fileSystem.FileExists(@"GeneratedCode\ISimpleAPI.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\SimpleAPIExtensions.cs"));

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
                
                var testApiExtensions = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.SimpleAPIExtensions");
                Assert.NotNull(testApiExtensions);
                var testExtensionMethod = testApiExtensions.GetMethod("GetInt");
                Assert.False(testExtensionMethod.ReturnType.IsNullableValueType());
            }
        }
    }
}
