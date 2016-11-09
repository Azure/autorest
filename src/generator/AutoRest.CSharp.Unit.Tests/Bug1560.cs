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
    public class Bug1560 : BugTest
    {
        public Bug1560(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1560
        ///     Obsolete attribute does not get applied to all generated c# methods.
        /// </summary>
        [Fact]
        public async Task MarkAllDeprecatedOperationVariantsObsolete()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObject.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\IDeprecated.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Deprecated.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\DeprecatedExtensions.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\IApproved.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Approved.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\ApprovedExtensions.cs"));

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

                // verify that deprecated_operations are marked correctly
                var deprecatedInterface = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.IDeprecated");
                Assert.NotNull(deprecatedInterface);
                Assert.NotNull(deprecatedInterface.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                var deprecatedClass = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Deprecated");
                Assert.NotNull(deprecatedClass);
                Assert.NotNull(deprecatedClass.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                var deprecatedExtensions = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.DeprecatedExtensions");
                Assert.NotNull(deprecatedExtensions);
                Assert.NotNull(deprecatedExtensions.GetMethod("Operation").GetCustomAttribute(typeof(System.ObsoleteAttribute)));
                Assert.NotNull(deprecatedExtensions.GetMethod("OperationAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                // verify the other operations are not marked as deprecated
                var approvedInterface = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.IApproved");
                Assert.NotNull(approvedInterface);
                Assert.Null(approvedInterface.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                var approvedClass = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Approved");
                Assert.NotNull(approvedClass);
                Assert.Null(approvedClass.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                var approvedExtensions = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.ApprovedExtensions");
                Assert.NotNull(approvedExtensions);
                Assert.Null(approvedExtensions.GetMethod("Operation").GetCustomAttribute(typeof(System.ObsoleteAttribute)));
                Assert.Null(approvedExtensions.GetMethod("OperationAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));
            }
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1560
        ///     Obsolete attribute does not get applied to all generated c# methods.
        /// </summary>
        [Fact]
        public async Task MarkAllDeprecatedOperationVariantsObsoleteAzure()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObject.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\IDeprecatedOperations.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\DeprecatedOperations.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\DeprecatedOperationsExtensions.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\IApprovedOperations.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\ApprovedOperations.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\ApprovedOperationsExtensions.cs"));

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

                // verify that deprecated_operations are marked correctly
                var deprecatedInterface = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.IDeprecatedOperations");
                Assert.NotNull(deprecatedInterface);
                Assert.NotNull(deprecatedInterface.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                var deprecatedClass = asm.DefinedTypes.FirstOrDefault(each => each.FullName == "Test.DeprecatedOperations");
                Assert.NotNull(deprecatedClass);
                Assert.NotNull(deprecatedClass.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                var deprecatedExtensions = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.DeprecatedOperationsExtensions");
                Assert.NotNull(deprecatedExtensions);
                Assert.NotNull(deprecatedExtensions.GetMethod("Operation").GetCustomAttribute(typeof(System.ObsoleteAttribute)));
                Assert.NotNull(deprecatedExtensions.GetMethod("OperationAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                // verify the other operations are not marked as deprecated
                var approvedInterface = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.IApprovedOperations");
                Assert.NotNull(approvedInterface);
                Assert.Null(approvedInterface.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                var approvedClass = asm.DefinedTypes.FirstOrDefault(each => each.FullName == "Test.ApprovedOperations");
                Assert.NotNull(approvedClass);
                Assert.Null(approvedClass.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

                var approvedExtensions = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.ApprovedOperationsExtensions");
                Assert.NotNull(approvedExtensions);
                Assert.Null(approvedExtensions.GetMethod("Operation").GetCustomAttribute(typeof(System.ObsoleteAttribute)));
                Assert.Null(approvedExtensions.GetMethod("OperationAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));
            }
        }
    }
}