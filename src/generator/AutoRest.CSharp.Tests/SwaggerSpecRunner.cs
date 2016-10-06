// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using AutoRest.Core;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.Tests
{
    public static class SwaggerSpecRunner
    {
        public static void RunTests(string specFile, string resultFolder, string modeler = "Swagger", string generator = "CSharp")
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Input = specFile,
                    OutputDirectory = "X:\\Output",
                    Header = "MICROSOFT_MIT_NO_VERSION",
                    Modeler = modeler,
                    CodeGenerator = generator,
                    PayloadFlatteningThreshold = 1
                };

                RunTests(settings, resultFolder);
            }
        }

        public static void RunTests(Settings settings, string resultFolder)
        {
            // TODO: Run as process

            //var virtualStore = new MemoryFileSystem();
            //settings.FileSystem = virtualStore;
            //settings.ApplicationConfigurationPath = Path.Combine((new FileSystem()).GetCurrentDirectory(), 
            //    "../../../../binaries/net45/autorest.json");
            //settings.FileSystem.WriteFile("AutoRest.json", File.ReadAllText("AutoRest.json"));
            //settings.FileSystem.CreateDirectory(Path.GetDirectoryName(settings.Input));
            //settings.FileSystem.WriteFile(settings.Input, File.ReadAllText(settings.Input));
            //settings.FileSystem = new FileSystem();
            //var flavor = ExtensionsLoader.GetCodeGenerator(settings);
            //settings.FileSystem = virtualStore;

            //var expectedWithSeparator = "Expected" + Path.DirectorySeparatorChar;
            //var specFileName = resultFolder.StartsWith(expectedWithSeparator, StringComparison.Ordinal)
            //    ? resultFolder.Substring(expectedWithSeparator.Length)
            //    : resultFolder;
            //settings.Namespace = string.IsNullOrEmpty(settings.Namespace)
            //    ? "Fixtures." + (flavor.Name.Contains("Azure") ? "Azure." : "") + specFileName.
            //        Replace(".cs", "").Replace(".Cs", "").Replace(".java", "").
            //        Replace(".js", "").Replace(".", "").
            //        Replace(Path.DirectorySeparatorChar.ToString(), "").Replace("-", "")
            //    : settings.Namespace;

            //AutoRest.Generate(settings);
            //Assert.NotEmpty(((MemoryFileSystem)settings.FileSystem).VirtualStore);

            //var actualFiles = settings.FileSystem.GetFiles("X:\\Output", "*.*", true).OrderBy(f => f).ToArray();
            //var expectedFiles = Directory.GetFiles(resultFolder, "*.*", SearchOption.AllDirectories).OrderBy(f => f).ToArray();
            //Assert.Equal(expectedFiles.Length, actualFiles.Length);

            //for (int i = 0; i < expectedFiles.Length; i++)
            //{
            //    var actualFile = actualFiles[i];
            //    var expectedFile = expectedFiles[i];
            //    EnsureFilesMatch(File.ReadAllText(expectedFile), settings.FileSystem.ReadFileAsText(actualFile));
            //}
        }

        private static void EnsureFilesMatch(string expectedFileContent, string actualFileContent)
        {
            char[] wsChars = { '\r', ' ' };
            string[] expectedLines = expectedFileContent.Split('\n').Select(p => p.TrimEnd(wsChars)).ToArray();
            string[] actualLines = actualFileContent.Split('\n').Select(p => p.TrimEnd(wsChars)).ToArray();

            Assert.Equal(expectedLines.Length, actualLines.Length);

            for (int i = 0; i < expectedLines.Length; i++)
            {
                Assert.Equal(expectedLines[i], actualLines[i]);
            }
        }
    }

    public class _Settings
    {        
        public string Input { get; set; }
        
        public string Namespace { get; set; }
        
        public string OutputDirectory { get; set; }
        
        public string CodeGenerator { get; set; }
        
        public string Modeler { get; set; }
        
        public string ClientName { get; set; }
        
        public int PayloadFlatteningThreshold { get; set; }
        
        public string Header { get; set; }

        public bool AddCredentials { get; set; }
        
        public string OutputFileName { get; set; }

        public bool ShowHelp { get; set; }
    }
}