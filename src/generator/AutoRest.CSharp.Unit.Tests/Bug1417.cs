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
    public class Bug1417 : BugTest
    {
        public Bug1417(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/Bug1417
        ///     If an operation parameter name is the same as a definition name, the definition type is used.
        /// </summary>
        [Fact]
        public async Task CheckForCorrectParameterType()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\SimpleAPI.cs"));
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
                var simpleApi = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.SimpleAPI");
                Assert.NotNull(simpleApi);
                var simpleApiMethod = simpleApi.GetMethod("TestMethodWithHttpMessagesAsync");
                Assert.NotNull(simpleApiMethod);
                var simpleApiMethodParam = simpleApiMethod.GetParameters().FirstOrDefault(param => param.Name == "query");
                Assert.NotNull(simpleApiMethodParam);
                Assert.Equal("System.String", simpleApiMethodParam.ParameterType.FullName);

                var simpleApiExtensions =
                    asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.SimpleAPIExtensions");
                Assert.NotNull(simpleApiExtensions);
                var simpleApiExtensionsMethod = simpleApiExtensions.GetMethod("TestMethod");
                Assert.NotNull(simpleApiExtensionsMethod);
                var simpleApiExtensionsMethodParam = simpleApiExtensionsMethod.GetParameters().FirstOrDefault(param => param.Name == "query");
                Assert.NotNull(simpleApiExtensionsMethodParam);
                Assert.Equal("System.String", simpleApiExtensionsMethodParam.ParameterType.FullName);
            }
        }
    }
}