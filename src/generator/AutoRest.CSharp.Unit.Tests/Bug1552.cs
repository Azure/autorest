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
    public class Bug1552 : BugTest
    {
        public Bug1552(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/Bug1552
        ///     C# codegen can generate invalid C# comments.
        /// </summary>
        [Fact]
        public async Task CheckForProperDescriptionEscaping()
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
                var asm = Assembly.Load(result.Output.GetBuffer());
                Assert.NotNull(asm);

                // verify that "Func<int>" doesn't exist in the sources (otherwise escaping is still insufficient, even if newlines were handled)
                var unescapedFiles = fileSystem
                    .VirtualStore
                    .Where(file => file.Key.EndsWith(".cs"))
                    .Where(file => file.Value.ToString().Contains("Func<int>"));
                Assert.Empty(unescapedFiles);
            }
        }

        /// <summary>
        ///     Wordwrap was a root of the problem, so here are some additional tests for the new version.
        /// </summary>
        [Fact]
        public void CheckWordWrap()
        {
            // no break
            Assert.Equal(1, "".WordWrap(7).Count());
            Assert.Equal(1, "aaaaaaaaa".WordWrap(7).Count());
            Assert.Equal(1, "aaaaaaaa".WordWrap(7).Count());
            Assert.Equal(1, "aaaaaaa".WordWrap(7).Count());
            Assert.Equal(1, "aaaaaa".WordWrap(7).Count());

            // correct cutting
            Assert.Equal(1, "aaa".WordWrap(7).Count());
            Assert.Equal(1, "aaa aaa".WordWrap(7).Count());
            Assert.Equal(2, "aaa aaa aaa".WordWrap(7).Count());
            Assert.Equal(2, "aaa aaa aaa aaa".WordWrap(7).Count());
            Assert.Equal(3, "aaa aaa aaa aaa aaa".WordWrap(7).Count());
            Assert.Equal(1, "aaa".WordWrap(6).Count());
            Assert.Equal(2, "aaa aaa".WordWrap(6).Count());
            Assert.Equal(3, "aaa aaa aaa".WordWrap(6).Count());
            Assert.Equal(4, "aaa aaa aaa aaa".WordWrap(6).Count());
            Assert.Equal(5, "aaa aaa aaa aaa aaa".WordWrap(6).Count());

            // correct newline handling
            Assert.Equal(2, "aa \r aa".WordWrap(100).Count());
            Assert.Equal(2, "aa \n aa".WordWrap(100).Count());
            Assert.Equal(2, "aa \r\n aa".WordWrap(100).Count());

            Assert.Equal(3, "aaa\raaa aaa aaa".WordWrap(7).Count());
            Assert.Equal(2, "aaa aaa\raaa aaa".WordWrap(7).Count());
            Assert.Equal(3, "aaa aaa aaa\raaa".WordWrap(7).Count());
        }
    }
}