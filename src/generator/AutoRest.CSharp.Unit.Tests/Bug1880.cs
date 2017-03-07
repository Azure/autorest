// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1880: BugTest
    {
        private readonly Regex reg = new Regex(@"(Product\([^)]+(?<ctor>[^}]+)\})+", RegexOptions.IgnoreCase);

        public Bug1880(ITestOutputHelper output) : base(output)
        {

        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1880
        ///     Verifies if model constructor parameters have description for base class
        ///     parameters
        /// </summary>
        [Fact]
        public async Task BaseModelParameterDescription()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // check for the expected class.
                Assert.True(fileSystem.FileExists(@"Models/Product.cs"));

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

                // try to load the assembly
                var asm = LoadAssembly(result.Output);
                Assert.NotNull(asm);

                // verify if the model exists
                var product = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.Product");
                Assert.NotNull(product);
                var productCtor = product.GetConstructors().First(ctor=>ctor.GetParameters().Any());
                Assert.NotNull(productCtor);

                // verify if the model constructor has the base class constructor parameter descriptions
                var codeText = fileSystem.ReadAllText(@"Models\Product.cs");
                Assert.True(reg.IsMatch(codeText));
                var matches = reg.Matches(codeText);
                var sIndex = codeText.IndexOf(matches[0].Value);
                codeText = codeText.Substring(0, sIndex);
                Assert.True(codeText.Contains("/// <param name=\"manuf\">name of manufacturer</param>"));

            }
        }

    }
}

