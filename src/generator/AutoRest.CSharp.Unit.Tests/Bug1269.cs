// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1269 : BugTest
    {
        public Bug1269(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1269
        ///     Verifies autorest succesfully generates code for empty path object
        /// </summary>
        [Fact]
        public async Task EmptyPathObjectCodeGenerationTest()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // check for the expected class.
                Assert.True(fileSystem.FileExists(@"GeneratedCode\PetOperations.cs"));

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

                string genCode = fileSystem.ReadFileAsText(@"GeneratedCode\PetOperations.cs");
                const string nullStreamPattern = @"(?:.+)+(if \(streamContents == null\))(?:.+)+";
                var regexResult = Regex.Match(genCode, nullStreamPattern, RegexOptions.Singleline);
                Assert.False(regexResult.Success);
            }
        }
    }
}