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
    /// <summary>
    /// Tests semantics of x-ms-enum against https://review.docs.microsoft.com/en-us/new-hope/specs/reference/swagger-enums
    /// </summary>
    public class XMsEnum : BugTest
    {
        public XMsEnum(ITestOutputHelper output) : base(output)
        {
        }

        [Fact]
        public async Task UseCases()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"Models/Enum2CustomName.cs"));
                Assert.True(fileSystem.FileExists(@"Models/Enum3CustomName.cs"));
                Assert.True(fileSystem.FileExists(@"Models/Enum4CustomName.cs"));
                Assert.True(fileSystem.FileExists(@"Models/Enum5CustomName.cs"));

                // check that (supposedly) overridden stuff doesn't exist.
                foreach (var file in fileSystem.VirtualStore.Values)
                {
                    Assert.False(file.ToString().Contains("OVERRIDDEN"));
                }

                // enum 3-5 must have descriptions
                Assert.True(fileSystem.ReadAllText(@"Models/Enum3CustomName.cs").Contains("is cool"));
                Assert.True(fileSystem.ReadAllText(@"Models/Enum4CustomName.cs").Contains("is cool"));
                Assert.True(fileSystem.ReadAllText(@"Models/Enum5CustomName.cs").Contains("is cool"));
                // enum 4-5 must have different name than value
                Assert.True(fileSystem.ReadAllText(@"Models/Enum4CustomName.cs").Contains("4aValue"));
                Assert.True(fileSystem.ReadAllText(@"Models/Enum4CustomName.cs").Contains("4aName"));
                Assert.True(fileSystem.ReadAllText(@"Models/Enum5CustomName.cs").Contains("5aValue"));
                Assert.True(fileSystem.ReadAllText(@"Models/Enum5CustomName.cs").Contains("5aName"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // use this to dump the files to disk for examination 
                //fileSystem.SaveFilesToTemp("name_collision");

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

                // try to load the assembly
                var asm = LoadAssembly(result.Output);
                Assert.NotNull(asm);
            }
        }
    }
}