using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug781 : BugTest
    {
        public Bug781(ITestOutputHelper output) : base(output)
        {
        }
        /// <summary>
        ///     https://github.com/Azure/autorest/issues/781
        ///     Support format:'char' for single character strings.
        /// </summary>
        [Fact]
        public async Task EnsureModelCtorSetsDefaultValues()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // Expected Files
                Assert.True(fileSystem.FileExists(@"SimpleAPIClient.cs"));

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
                Assert.True(asm.DefinedTypes.Any(defType => defType.Name == "RequestObject"));

                // Check if the default ctor is setting the default value
                var codeText = fileSystem.ReadAllText(@"Models\RequestObject.cs");
                int sIndex = codeText.IndexOf("public RequestObject()");
                int eIndex = codeText.Substring(sIndex, codeText.Length - 1 - sIndex).IndexOf("}");
                var ctorText = codeText.Substring(sIndex, eIndex);
                Assert.True(ctorText.Contains("ReqProp = \"defpropvalue\";"));
            }
        }
    }
}