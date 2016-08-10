// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 


using AutoRest.Core.Utilities;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class BatchTestSpecs : BugTest
    {
        public BatchTestSpecs(ITestOutputHelper output) : base(output)
        {
        }
        /// <summary>
        ///   Generates code for all JSON and YAML files in a folder and verifies the project compiles without error
        /// </summary>
        /// Comment out the Skip and update the path below to run
        [Fact(Skip = "Manual Test")]  
        public async Task BatchTest()
        {
            FileSystem fs = new FileSystem();
            string path = @"C:\PathToSpecs"; //path to specs
            Assert.True(fs.DirectoryExists(path), $"{path} does not exist");

            // get all of the json and yaml files from filesystem
            string[] files = fs.GetFilesByExtension(path, SearchOption.AllDirectories, "json", "yaml");
            Assert.True(files.Count() > 0, $"{path} does not contain any json or yaml files");

            foreach (string file in files)
            {
                // Comment this block out if not needed
                if (!fs.ReadFileAsText(file).Contains(@"""swagger"": ""2.0"""))
                {
                    //skip files that are not swagger files.
                    continue;
                }

                using (var memoryFileSystem = GenerateCodeForTestFromSpec(file))
                {
                    // Expected Files
                    Assert.True(memoryFileSystem.GetFiles(@"GeneratedCode\", "*.cs", SearchOption.TopDirectoryOnly).GetUpperBound(0) > 0);
                    Assert.True(memoryFileSystem.GetFiles(@"GeneratedCode\Models\", "*.cs", SearchOption.TopDirectoryOnly).GetUpperBound(0) > 0);

                    var result = await Compile(memoryFileSystem);

                    // filter the warnings
                    var warnings = result.Messages.Where(
                        each => each.Severity == DiagnosticSeverity.Warning
                                && !SuppressWarnings.Contains(each.Id)).ToArray();

                    // use this to dump the files to disk for examination
                    // memoryFileSystem.SaveFilesToTemp(file.Name);

                    // filter the errors
                    var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                    Write(warnings, memoryFileSystem);
                    Write(errors, memoryFileSystem);

                    // use this to write out all the messages, even hidden ones.
                    // Write(result.Messages, memoryFileSystem);

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
}