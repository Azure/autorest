// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Extensibility;
using Microsoft.Rest.Generator.Utilities;

namespace AutoRest.CSharp.Unit.Tests
{
    internal static class TestExtensions
    {
        internal static void Copy(this IFileSystem fileSystem , string sourceFileOnDisk)
        {
            Copy( fileSystem, sourceFileOnDisk, Path.GetFileName(sourceFileOnDisk));
        }
        internal static void Copy(this IFileSystem fileSystem, string sourceFileOnDisk, string destination)
        {
            fileSystem.WriteFile(destination, File.ReadAllText(sourceFileOnDisk));
        }

        internal static MemoryFileSystem GenerateCodeInto(this string inputFile, MemoryFileSystem fileSystem )
        {
            fileSystem.Copy(Path.Combine("Resource", inputFile));

            var settings = new Settings
            {
                Modeler = "Swagger",
                CodeGenerator = "CSharp",
                FileSystem = fileSystem,
                OutputDirectory = "GeneratedCode",
                Input = inputFile,
            };

            var codeGenerator = new CSharpCodeGenerator(settings);
            Modeler modeler = ExtensionsLoader.GetModeler(settings);
            var sc = modeler.Build();
            codeGenerator.NormalizeClientModel(sc);
            codeGenerator.Generate(sc).GetAwaiter().GetResult();

            return fileSystem;
        }
    }
}