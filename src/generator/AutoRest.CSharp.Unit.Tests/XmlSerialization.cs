// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 
namespace AutoRest.CSharp.Unit.Tests {
    using System;
    using System.Collections;
    using System.Linq;
    using System.Reflection;
    using System.Threading.Tasks;
    using Microsoft.CodeAnalysis;
    using Xunit;
    using Xunit.Abstractions;

    public class XmlSerialization : BugTest
    {
        public XmlSerialization(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     Xml Serialization tests
        /// </summary>
        /// [Fact]
        public async Task CheckXmlSerialization() {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\StorageServiceProperties.cs"));
                Assert.True(fileSystem.FileExists(@"GeneratedCode\SimpleAPI.cs"));
                
                var result = await Compile(fileSystem);
                
                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning &&
                            !SuppressWarnings.Contains(each.Id)).ToArray();

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
                
                // try to load the assembly
                var asm = LoadAssembly(result.Output);
                Assert.NotNull(asm);

                using (var service =new ServiceController()) {

                    var program = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "XmlSerialization.Program");
                    
                    dynamic test = program.GetConstructor(new Type[0]).Invoke(new object[0]);
                    // var testResult = (int)program.GetMethod("Main").Invoke(null, new object[] {$"{service.Uri.AbsolutePath}/xml"});
                    int testResult = test.Main($"{service.Uri.AbsoluteUri}xml");

                    Assert.Equal(0, testResult);

                    // Should also succeed.
                    Assert.True(result.Succeeded);
                }
            }
        }
    }
}