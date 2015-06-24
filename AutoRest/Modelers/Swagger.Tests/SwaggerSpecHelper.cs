// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.IO;
using System.Linq;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Utilities;
using Xunit;

namespace Microsoft.Rest.Modeler.Swagger.Tests
{
    public class SwaggerSpecHelper
    {
        public static void RunTests<T>(string specFile, string resultFolder, string modeler = "Swagger",
            Settings settings = null)
        {
            if (settings == null)
            {
                settings = new Settings
                {
                    Input = specFile,
                    OutputDirectory = "X:\\Output",
                    Header = "NONE",
                    Modeler = modeler
                };

            }

            RunTests<T>(settings, resultFolder);
        }

        public static void RunTests<T>(Settings settings, string resultFolder)
        {
            settings.FileSystem = new MemoryFileSystem();
            settings.FileSystem.WriteFile("AutoRest.json", File.ReadAllText("AutoRest.json"));
            settings.FileSystem.CreateDirectory(Path.GetDirectoryName(settings.Input));
            settings.FileSystem.WriteFile(settings.Input, File.ReadAllText(settings.Input));
            var flavor =
                (CodeGenerator)typeof(T).GetConstructor(new[] { typeof(Settings) }).Invoke(new object[] { settings });
            settings.CodeGenerator = flavor.Name;

            var specFileName = resultFolder.StartsWith("Expected\\")
                ? resultFolder.Substring("Expected\\".Length)
                : resultFolder;
            settings.Namespace = string.IsNullOrEmpty(settings.Namespace)
                ? "Fixtures." + (flavor.Name.Contains("Azure") ? "Azure." : "") + specFileName.
                    Replace(".cs", "").Replace(".Cs", "").Replace(".java", "").
                    Replace(".js", "").Replace(".", "").
                    Replace("\\", "").Replace("-", "")
                : settings.Namespace;

            AutoRest.Generate(settings);
            Assert.NotEmpty(((MemoryFileSystem)settings.FileSystem).VirtualStore);

            foreach (var generatedFile in settings.FileSystem.GetFiles("X:\\Output", "*.*", SearchOption.AllDirectories))
            {
                var realFile = Path.Combine(resultFolder, generatedFile.Replace("X:\\Output\\", ""));
                if (!File.Exists(realFile))
                {
                    throw new IOException(string.Format("File {0} was not found in '{1}' folder.",
                        Path.GetFileName(generatedFile), resultFolder));
                }

                EnsureFilesMatch(File.ReadAllText(realFile),
                    settings.FileSystem.ReadFileAsText(generatedFile));
            }
        }

        public static void RunNodeJSTests<T>(Settings settings, string resultFile)
        {
            settings.FileSystem = new MemoryFileSystem();
            settings.FileSystem.WriteFile("AutoRest.json", File.ReadAllText("AutoRest.json"));
            settings.FileSystem.CreateDirectory(Path.GetDirectoryName(settings.Input));
            settings.FileSystem.WriteFile(settings.Input, File.ReadAllText(settings.Input));
            var flavor =
                (CodeGenerator)typeof(T).GetConstructor(new[] { typeof(Settings) }).Invoke(new object[] { settings });
            settings.CodeGenerator = flavor.Name;

            settings.Namespace = "foo";

            AutoRest.Generate(settings);
            Assert.NotEmpty(((MemoryFileSystem)settings.FileSystem).VirtualStore);

            var generatedFile = settings.FileSystem.GetFiles("X:\\Output",
                Path.GetFileName(resultFile), SearchOption.AllDirectories).FirstOrDefault();

            EnsureFilesMatch(File.ReadAllText(resultFile),
               settings.FileSystem.ReadFileAsText(generatedFile));
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