// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Configuration;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;

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

        internal static void CopyFile(this IFileSystem fileSystem, string source, string destination)
        {
            destination = destination.Replace("._", ".");
            fileSystem.WriteAllText(destination, File.ReadAllText(source));
        }

        internal static void Copy(this IFileSystem fileSystem, string source)
        {
            CopyFile(fileSystem, source, (File.Exists(source) ? Path.GetFileName(source) : source));
        }

        internal static void CopyFolder(this IFileSystem fileSystem, string basePath, string source, string destination)
        {
            // if copying a file
            if (File.Exists(source))
            {
                fileSystem.WriteAllText(destination, File.ReadAllText(source));
                return;
            }
            
            // if copying a directory
            fileSystem.CreateDirectory(destination);
        
            // Copy dirs recursively
            foreach (var child in Directory.EnumerateDirectories(Path.GetFullPath(Path.Combine(basePath, source))).Select(Path.GetFileName))
            {
                fileSystem.CopyFolder(basePath, Path.Combine(source, child), Path.Combine(destination, child));
            }

            // Copy files
            foreach (var childFile in Directory.EnumerateFiles(Path.GetFullPath(Path.Combine(basePath, source))).Select(Path.GetFileName))
            {
                fileSystem.CopyFile(Path.Combine(basePath,source,childFile), Path.Combine(destination, childFile));
            }
        }

        internal static string[] GetFilesByExtension(this IFileSystem fileSystem, string path, SearchOption s, params string[] fileExts)
        {
            return fileSystem.GetFiles(path, "*.*", s).Where(f => fileExts.Contains(f.Substring(f.LastIndexOf(".")+1))).ToArray();
        }

        internal static MemoryFileSystem GenerateCodeInto(this string testName,  MemoryFileSystem fileSystem, string codeGenerator="CSharp", string[] inputFiles=null, string clientName = null)
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    CodeGenerator = codeGenerator,
                    Namespace = "Test",
                    CodeGenerationMode = "rest-client",
                    ClientName = clientName
                };

                return testName.GenerateCodeInto(fileSystem, settings, inputFiles);
            }
        }

        internal static MemoryFileSystem GenerateCodeInto(this string testName, MemoryFileSystem fileSystem, Settings settings, string[] inputFiles=null)
        {
            // copy the whole input directory into the memoryfilesystem.
            fileSystem.CopyFolder("Resource", testName,"");

            // find the appropriately named .yaml or .json file for the swagger. 
            if (inputFiles == null)
            {
                if (settings.Input != null)
                {
                    inputFiles = new[] {settings.Input};
                }
                else
                {
                    foreach (var ext in new[] {".yaml", ".json", ".md"})
                    {
                        var name = testName + ext;
                        if (fileSystem.FileExists(name))
                        {
                            inputFiles = new[] {name};
                        }
                    }
                }
            }

            if (inputFiles == null) {
                throw new Exception($"Can't find swagger file ${testName} [.yaml] [.json] [.md]");
            }

            var config = settings.CreateConfiguration();
            config.InputFiles = inputFiles;
            config.DisableSimplifier = true;
            return AutoRestController.Generate(fileSystem, config).GetAwaiter().GetResult();
        }

        internal static string SaveFilesToTemp(this IFileSystem fileSystem, string folderName = null)
        {
            folderName = string.IsNullOrWhiteSpace(folderName) ? Guid.NewGuid().ToString() : folderName;
            var outputFolder = Path.Combine(Path.GetTempPath(), folderName);
            if (Directory.Exists(outputFolder))
            {
                try
                {
                    Directory.Delete(outputFolder, true);
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
                File.WriteAllText(target, fileSystem.ReadAllText(file));
            }

            return outputFolder;
        }

        internal static bool IsNullableValueType(this Type type) => type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>);
    }
}