// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.AzureResourceSchema.Tests
{
    using AutoRest.Core.Logging;
    using AutoRest.Core.Model;
    using AutoRest.Swagger;
    using Core.Extensibility;

    public static class SwaggerSpecHelper
    {
        public static void RunTests(string specFile, string resultFolder)
        {
            using (NewContext)
            {
                RunTests(
                    new Settings
                    {
                        Input = specFile ?? throw new ArgumentNullException(nameof(specFile)),
                        Header = "MICROSOFT_MIT_NO_VERSION",
                        PayloadFlatteningThreshold = 1
                    },
                    resultFolder ?? throw new ArgumentNullException(nameof(resultFolder)));
            }
        }

        private static void RunTests(Settings settings, string resultFolder)
        {
            settings.FileSystemInput = new MemoryFileSystem();
            settings.FileSystemInput.CreateDirectory(Path.GetDirectoryName(settings.Input));
            settings.FileSystemInput.WriteAllText(settings.Input, File.ReadAllText(settings.Input));

            var expectedWithSeparator = "Expected" + Path.DirectorySeparatorChar;
            var specFileName = resultFolder.StartsWith(expectedWithSeparator, StringComparison.Ordinal)
                ? resultFolder.Substring(expectedWithSeparator.Length)
                : resultFolder;

            var name = "AzureResourceSchema";
            settings.Namespace = string.IsNullOrEmpty(settings.Namespace)
                ? "Fixtures." + (name.Contains("Azure") ? "Azure." : "") + specFileName.
                    Replace(".cs", "").Replace(".Cs", "").Replace(".java", "").
                    Replace(".js", "").Replace(".", "").
                    Replace(Path.DirectorySeparatorChar.ToString(), "").Replace("-", "")
                : settings.Namespace;
            
            Generate(settings);

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

        private static void Generate(Settings settings)
        {
            CodeModel codeModel = null;

            var modeler = new SwaggerModeler();

            try
            {
                using (NewContext)
                {
                    // generate model from swagger 
                    codeModel = modeler.Build(SwaggerParser.Parse(Settings.Instance.FileSystemInput.ReadAllText(Settings.Instance.Input)));
                }
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError("Error generating client model", exception);
            }

            var plugin = ExtensionsLoader.GetPlugin("AzureResourceSchema");

            try
            {
                var genericSerializer = new ModelSerializer<CodeModel>();
                var modelAsJson = genericSerializer.ToJson(codeModel);

                // ensure once we're doing language-specific work, that we're working
                // in context provided by the language-specific transformer. 
                using (plugin.Activate())
                {
                    // load model into language-specific code model
                    codeModel = plugin.Serializer.Load(modelAsJson);

                    // apply language-specific tranformation (more than just language-specific types)
                    // used to be called "NormalizeClientModel" . 
                    codeModel = plugin.Transformer.TransformCodeModel(codeModel);

                    // Generate code from CodeModel.
                    plugin.CodeGenerator.Generate(codeModel).GetAwaiter().GetResult();
                }
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError("Error generating client code", exception);
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
