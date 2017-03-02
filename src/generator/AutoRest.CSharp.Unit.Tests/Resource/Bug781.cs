// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests.Resource
{
    public class Bug781 : BugTest
    {
        private readonly Regex reg = new Regex(@"(Product\((?<ctor>[^}]+)\})+", RegexOptions.IgnoreCase);

        public Bug781(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/Bug781
        ///     CustomInit() method 
        /// </summary>
        [Fact]
        public async Task EnsureCustomInitMethodInConstructors()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"Models\Product.cs"));
                
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
                // verify that parameter is of correct type
                var prod = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.Product");
                Assert.NotNull(prod);


                // find all ctors in the model and ensure they call CustomInit()
                var codeText = fileSystem.ReadAllText(@"Models\Product.cs");
                Assert.True(reg.IsMatch(codeText));
                var matches = reg.Matches(codeText);
                Assert.True(matches[0].Value.Contains("CustomInit()"));
                Assert.True(matches[1].Value.Contains("CustomInit()"));
                
            }
        }
    }
}
