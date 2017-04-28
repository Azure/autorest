// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using AutoRest.Core.Utilities;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1849 : BugTest
    {
        public Bug1849(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1849
        ///     C# codegen generates invalid code for int array parameters
        /// </summary>
        [Fact]
        public async Task CheckGeneratesValidCSharp()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // if newlines and stuff aren't excaped properly, compilation will fail
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
                var asm = LoadAssembly(result.Output);
                Assert.NotNull(asm);
            }
        }
    }
}