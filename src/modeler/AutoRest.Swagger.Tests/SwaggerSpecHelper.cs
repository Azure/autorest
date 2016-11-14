// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;
using IAnyPlugin = AutoRest.Core.Extensibility.IPlugin<AutoRest.Core.Extensibility.IGeneratorSettings, AutoRest.Core.IModelSerializer<AutoRest.Core.Model.CodeModel>, AutoRest.Core.ITransformer<AutoRest.Core.Model.CodeModel>, AutoRest.Core.CodeGenerator, AutoRest.Core.CodeNamer, AutoRest.Core.Model.CodeModel>;

namespace AutoRest.Swagger.Tests
{
    using Core.Extensibility;

    public static class SwaggerSpecHelper
    {
        public static void RunTests(string specFile, string resultFolder, string modeler = "Swagger", string plugin = "CSharp")
        {
            using (NewContext)
            {
                var settings = new Settings
                    {
                        Input = specFile,
                        OutputDirectory = "X:\\Output",
                        Header = "MICROSOFT_MIT_NO_VERSION",
                        Modeler = modeler,
                    PayloadFlatteningThreshold = 1,
                    CodeGenerator =  plugin

                    };

                RunTests(resultFolder);
            }
        }

        public static void RunTests(string resultFolder)
        {
            if (resultFolder == null)
            {
                throw new ArgumentNullException("settings");
            }
            var settings = Settings.Instance;

            settings.FileSystem = new MemoryFileSystem();
            settings.FileSystem.WriteFile("AutoRest.json", File.ReadAllText("AutoRest.json"));
            settings.FileSystem.CreateDirectory(Path.GetDirectoryName(settings.Input));
            settings.FileSystem.WriteFile(settings.Input, File.ReadAllText(settings.Input));

            var expectedWithSeparator = "Expected" + Path.DirectorySeparatorChar;
            var specFileName = resultFolder.StartsWith(expectedWithSeparator, StringComparison.Ordinal)
                ? resultFolder.Substring(expectedWithSeparator.Length)
                : resultFolder;

            var name = ExtensionsLoader.GetPlugin().Settings.Name;
            settings.Namespace = string.IsNullOrEmpty(settings.Namespace)
                ? "Fixtures." + (name.Contains("Azure") ? "Azure." : "") + specFileName.
                    Replace(".cs", "").Replace(".Cs", "").Replace(".java", "").
                    Replace(".js", "").Replace(".", "").
                    Replace(Path.DirectorySeparatorChar.ToString(), "").Replace("-", "")
                : settings.Namespace;

            AutoRest.Core.AutoRestController.Generate();
            Assert.NotEmpty(((MemoryFileSystem)settings.FileSystem).VirtualStore);

            var actualFiles = settings.FileSystem.GetFiles("X:\\Output", "*.json", SearchOption.AllDirectories).OrderBy(f => f).ToArray();
            var expectedFiles = Directory.Exists(resultFolder) ? Directory.GetFiles(resultFolder, "*.json", SearchOption.AllDirectories).OrderBy(f => f).ToArray() : new string[0];
            Assert.Equal(expectedFiles.Length, actualFiles.Length);

            for (int i = 0; i < expectedFiles.Length; i++)
            {
                var actualFile = actualFiles[i];
                var expectedFile = expectedFiles[i];
                EnsureFilesMatch(File.ReadAllText(expectedFile), settings.FileSystem.ReadFileAsText(actualFile));
            }
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
}