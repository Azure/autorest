// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class VerifyCompositeModelSignature : BugTest
    {
        public VerifyCompositeModelSignature(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     Verify PrimaryTypes in Composite Signature is correct.
        /// </summary>
        [Fact]
        public async Task VerifySignature()
        {
            using (var fileSystem = $"{GetType().Name}.yaml".GenerateCodeInto(CreateMockFilesystem()))
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\ResultObject.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\TestAllOfObject.cs"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // use this to dump the files to disk for examination
                fileSystem.SaveFilesToTemp($"{GetType().Name}");

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
            }
        }
    }
}