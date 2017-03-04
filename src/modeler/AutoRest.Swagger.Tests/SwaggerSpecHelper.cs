// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swagger.Tests
{
    using Core.Extensibility;

    public static class SwaggerSpecHelper
    {
        public static void RunTests(string specFile, string resultFolder, string modeler = "Swagger", string plugin = "CSharp", string nameSpace = null)
        {
            using (NewContext)
            {
                var settings = new Settings
                    {
                        Input = specFile,
                        Header = "MICROSOFT_MIT_NO_VERSION",
                        Modeler = modeler,
                        PayloadFlatteningThreshold = 1,
                        CodeGenerator =  plugin,
                        Namespace = nameSpace
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

            settings.FileSystemInput = new MemoryFileSystem();
            settings.FileSystemInput.CreateDirectory(Path.GetDirectoryName(settings.Input));
            settings.FileSystemInput.WriteAllText(settings.Input, File.ReadAllText(settings.Input));

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
            settings.DisableSimplifier = true;

            AutoRestController.Generate();

            var actualFiles = settings.FileSystemOutput.GetFiles("", "*.*", SearchOption.AllDirectories).OrderBy(f => f).ToArray();
            var expectedFiles = Directory.Exists(resultFolder) ? Directory.GetFiles(resultFolder, "*.*", SearchOption.AllDirectories).OrderBy(f => f).ToArray() : new string[0];
            Assert.Equal(expectedFiles.Length, actualFiles.Length);

            for (int i = 0; i < expectedFiles.Length; i++)
            {
                var actualFile = actualFiles[i];
                var expectedFile = expectedFiles[i];
                EnsureFilesMatch(File.ReadAllText(expectedFile), settings.FileSystemOutput.ReadAllText(actualFile));
            }
        }

        private static void EnsureFilesMatch(string expectedFileContent, string actualFileContent)
        {
            char[] wsChars = { '\r', ' ' };
            string[] expectedLines = expectedFileContent.Trim().Split('\n').Select(p => p.TrimEnd(wsChars)).ToArray();
            string[] actualLines = actualFileContent.Trim().Split('\n').Select(p => p.TrimEnd(wsChars)).ToArray();

            Assert.Equal(expectedLines.Length, actualLines.Length);

            for (int i = 0; i < expectedLines.Length; i++)
            {
                Assert.Equal(expectedLines[i], actualLines[i]);
            }
        }
    }
}
