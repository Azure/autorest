// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.Unit.Tests
{
    internal static class TestExtensions
    {
        public static dynamic ToDynamic(this object anonymousObject)
        {
            return new AutoDynamic(anonymousObject);
        }

        public static bool IsAnonymousType(this Type type)
        {
            var name = type.Name;
            if (name.Length < 3)
            {
                return false;
            }
            return name[0] == '<' && name[1] == '>' && name.IndexOf("AnonymousType", StringComparison.Ordinal) > 0;
        }

        internal static void Copy(this IFileSystem fileSystem, string sourceFileOnDisk)
        {
            Copy(fileSystem, sourceFileOnDisk, Path.GetFileName(sourceFileOnDisk));
        }

        internal static void Copy(this IFileSystem fileSystem, string sourceFileOnDisk, string destination)
        {
            fileSystem.WriteFile(destination, File.ReadAllText(sourceFileOnDisk));
        }

        internal static string[] GetFilesByExtension(this IFileSystem fileSystem, string path, SearchOption s, params string[] fileExts)
        {
            return fileSystem.GetFiles(path, "*.*", s).Where(f => fileExts.Contains(f.Substring(f.LastIndexOf(".")+1))).ToArray();
        }

        internal static MemoryFileSystem GenerateCodeInto(this string inputFile,  MemoryFileSystem fileSystem)
        {
            var settings = new Settings
            {
                Modeler = "Swagger",
                CodeGenerator = "CSharp",
                FileSystem = fileSystem,
                OutputDirectory = "GeneratedCode",
                Namespace = "Test"
            };

            return inputFile.GenerateCodeInto(fileSystem, settings);
        }

        internal static MemoryFileSystem GenerateCodeInto(this string inputFile, MemoryFileSystem fileSystem, Settings settings)
        {
            string fileName = Path.GetFileName(inputFile);

            // If inputFile does not contain a path use the local Resource folder
            if (inputFile == fileName)
            {
                fileSystem.Copy(Path.Combine("Resource", inputFile));
            }
            else
            {
                fileSystem.Copy(inputFile);
            }

            settings.Input = fileName;

            var codeGenerator = new CSharpCodeGenerator(settings);
            var modeler = ExtensionsLoader.GetModeler(settings);
            var sc = modeler.Build();
            codeGenerator.NormalizeClientModel(sc);
            codeGenerator.Generate(sc).GetAwaiter().GetResult();

            return fileSystem;
        }

        internal static void SaveFilesToTemp(this IFileSystem fileSystem, string folderName = null)
        {
            folderName = string.IsNullOrWhiteSpace(folderName) ? Guid.NewGuid().ToString() : folderName;
            var outputFolder = Path.Combine(Path.GetTempPath(), folderName);
            if (Directory.Exists(outputFolder))
            {
                try
                {
                    fileSystem.EmptyDirectory(outputFolder);
                    fileSystem.DeleteDirectory(outputFolder);
                }
                catch
                {
                    // who cares...
                }
            }

            Directory.CreateDirectory(outputFolder);
            foreach (var file in fileSystem.GetFiles("", "*", SearchOption.AllDirectories))
            {
                var target = Path.Combine(outputFolder, file.Substring(file.IndexOf(":", StringComparison.Ordinal) + 1));
                Directory.CreateDirectory(Path.GetDirectoryName(target));
                File.WriteAllText(target, fileSystem.ReadFileAsText(file));
            }
        }
    }
}