// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Utilities;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug470 : BugTest
    {
        public Bug470(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/470
        ///     Verifies the Models folder and namespace are correct based on the settings paramenter -ModelsName
        /// </summary>
        [Fact]
        public async Task SupportModelsNameOverride()
        {
            using (NewContext)
            {
                string modelsName = "MyModels";

                MemoryFileSystem fileSystem = CreateMockFilesystem();

                var settings = new Settings
                {
                    Modeler = "Swagger",
                    CodeGenerator = "CSharp",
                    FileSystem = fileSystem,
                    OutputDirectory = "GeneratedCode",
                    Namespace = "Test",
                    ModelsName = modelsName
                };

                using (fileSystem = $"{GetType().Name}".GenerateCodeInto(fileSystem, settings))
                {
                    // Expected Files
                    Assert.True(fileSystem.FileExists($@"{settings.OutputDirectory}\{modelsName}\ResultObject.cs"));

                    var result = await Compile(fileSystem);

                    // filter the warnings
                    var warnings = result.Messages.Where(
                        each => each.Severity == DiagnosticSeverity.Warning
                                && !SuppressWarnings.Contains(each.Id)).ToArray();

                    // use this to dump the files to disk for examination
                    // fileSystem.SaveFilesToTemp($"{GetType().Name}");

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
                    var asm = Assembly.Load(result.Output.GetBuffer());
                    Assert.NotNull(asm);

                    // verify that we have the class we expected
                    var resultObject =
                        asm.ExportedTypes.FirstOrDefault(each => each.FullName == $"Test.{modelsName}.ResultObject");
                    Assert.NotNull(resultObject);
                }
            }
        }
    }
}