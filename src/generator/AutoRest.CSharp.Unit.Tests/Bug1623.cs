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
    public class Bug1623 : BugTest
    {
        public Bug1623(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/Bug1623
        ///     x-ms-pageable and nullability.
        /// </summary>
        [Fact]
        public async Task CheckForCorrectParameterType()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\Page.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\IProductsOperations.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\ProductsOperationsExtensions.cs"));

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

                // verify that parameter is of correct type
                var ops = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.ProductsOperationsExtensions");
                Assert.NotNull(ops);
                var opsMethod = ops.GetMethod("List");
                Assert.NotNull(opsMethod);
                var opsMethodReturnType = opsMethod.ReturnType?.GetGenericArguments()?.FirstOrDefault();
                Assert.NotNull(opsMethodReturnType);
                Assert.Equal(typeof(int?), opsMethodReturnType);
            }
        }
    }
}