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
    public class Bug816 : BugTest
    {
        public Bug816(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/816
        ///     Nullable int property on response model for element that will always be present.
        /// </summary>
        [Fact]
        public async Task NullableIfReadOnlyRequiredDefault()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObject.cs"));

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
                var resultObject = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.ResultObject");
                Assert.NotNull(resultObject);
                Assert.NotNull(resultObject.GetMethod("OperationWithHttpMessagesAsync").GetCustomAttribute(typeof(System.ObsoleteAttribute)));

            }
        }
    }
}