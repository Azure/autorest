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
    public class Bug1285 : BugTest
    {
        public Bug1285(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1285
        ///     Support deprecated property for operations.
        /// </summary>
        [Fact]
        public async Task SupportDeprecatedOperations()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObject.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\DeprecatedExtensions.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\ApprovedExtensions.cs"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // use this to dump the files to disk for examination
                // fileSystem.SaveFilesToTemp("bug1285");

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

                // verify that deprecated_operation is marked correctly
                var deprecatedExtensions= asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.DeprecatedExtensions");
                Assert.NotNull(deprecatedExtensions);
                Assert.NotNull(deprecatedExtensions.GetMethod("Operation").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                // verify the other operations are not marked as deprecated
                var approvedExtensions = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.ApprovedExtensions");
                Assert.NotNull(approvedExtensions);
                Assert.Null(approvedExtensions.GetMethod("Operation2").GetCustomAttribute(typeof(System.ObsoleteAttribute)));
                Assert.Null(approvedExtensions.GetMethod("Operation3").GetCustomAttribute(typeof(System.ObsoleteAttribute)));
            }
        }
    }
}