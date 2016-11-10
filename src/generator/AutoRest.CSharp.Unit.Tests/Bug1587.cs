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
    public class Bug1587 : BugTest
    {
        public Bug1587(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1587
        ///     `x-ms-long-running-operation: false` generates bad C# code.
        /// </summary>
        [Fact]
        public async Task CheckLruCodegenBehavior()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\SimpleAPI.cs"));

                // compilation is key in this test, as `x-ms-long-running-operation: false`
                // creates method that contains call to non-existent method.
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

                // verify that correct methods exist.
                var simpleApi = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.SimpleAPI");
                Assert.NotNull(simpleApi);
                Assert.NotNull(simpleApi.GetMethod("Lru0WithHttpMessagesAsync"));
                Assert.NotNull(simpleApi.GetMethod("Lru1WithHttpMessagesAsync"));
                Assert.NotNull(simpleApi.GetMethod("Lru2WithHttpMessagesAsync"));
                Assert.Null(simpleApi.GetMethod("BeginLru0WithHttpMessagesAsync"));
                Assert.NotNull(simpleApi.GetMethod("BeginLru1WithHttpMessagesAsync"));
                Assert.Null(simpleApi.GetMethod("BeginLru2WithHttpMessagesAsync"));
            }
        }
    }
}