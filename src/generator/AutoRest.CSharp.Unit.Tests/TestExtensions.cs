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

        internal static void Copy(this IFileSystem fileSystem, string source)
        {
            Copy(fileSystem, source, (File.Exists(source)? Path.GetFileName(source): source));
        }

        internal static void Copy(this IFileSystem fileSystem, string source, string destination)
        {
            // if copying a file
            if (File.Exists(source))
            {
                fileSystem.WriteFile(destination, File.ReadAllText(source));
                return;
            }
            
            // if copying a directory
            if (fileSystem.DirectoryExists(destination))
            {
                fileSystem.DeleteDirectory(destination);
            }
            fileSystem.CreateDirectory(destination);
        
            // Copy dirs recursively
            foreach (var child in Directory.GetDirectories(Path.GetFullPath(source), "*", SearchOption.TopDirectoryOnly).Select(p => Path.GetDirectoryName(p)))
            {
                fileSystem.Copy(Path.Combine(source, child), Path.Combine(destination, child));
            }
            // Copy files
            foreach (var childFile in Directory.GetFiles(Path.GetFullPath(source), "*", SearchOption.TopDirectoryOnly).Select(p=>Path.GetFileName(p)))
            {
                fileSystem.Copy(Path.Combine(source, childFile), 
                                Path.Combine(destination, childFile));
            }
           
        }

        internal static string[] GetFilesByExtension(this IFileSystem fileSystem, string path, SearchOption s, params string[] fileExts)
        {
            return fileSystem.GetFiles(path, "*.*", s).Where(f => fileExts.Contains(f.Substring(f.LastIndexOf(".")+1))).ToArray();
        }

        internal static MemoryFileSystem GenerateCodeInto(this string inputDir,  MemoryFileSystem fileSystem, string codeGenerator="CSharp", string modeler = "Swagger")
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Modeler = modeler,
                    CodeGenerator =codeGenerator,
                    FileSystem = fileSystem,
                    OutputDirectory = "GeneratedCode",
                    Namespace = "Test"
                };

                return inputDir.GenerateCodeInto(fileSystem, settings);
            }
        }

        internal static MemoryFileSystem GenerateCodeInto(this string inputDir, MemoryFileSystem fileSystem, Settings settings)
        {
            fileSystem.Copy(Path.Combine("Resource", inputDir));
            var fileExt = (File.Exists(Path.Combine("Resource", Path.Combine(inputDir, inputDir + ".yaml"))) ? ".yaml" : ".json");
            settings.Input = Path.Combine("Resource", Path.Combine(inputDir, inputDir + fileExt));


            var plugin = ExtensionsLoader.GetPlugin();
            var modeler = ExtensionsLoader.GetModeler();
            var codeModel = modeler.Build();

            // After swagger Parser
            codeModel = AutoRestController.RunExtensions(Trigger.AfterModelCreation, codeModel);

            // After swagger Parser
            codeModel = AutoRestController.RunExtensions(Trigger.BeforeLoadingLanguageSpecificModel, codeModel);

            using (plugin.Activate())
            {
                // load model into language-specific code model
                codeModel = plugin.Serializer.Load(codeModel);

                // we've loaded the model, run the extensions for after it's loaded
                codeModel = AutoRestController.RunExtensions(Trigger.AfterLoadingLanguageSpecificModel, codeModel);

                // apply language-specific tranformation (more than just language-specific types)
                // used to be called "NormalizeClientModel" . 
                codeModel = plugin.Transformer.TransformCodeModel(codeModel);

                // next set of extensions
                codeModel = AutoRestController.RunExtensions(Trigger.AfterLanguageSpecificTransform, codeModel);

                // next set of extensions
                codeModel = AutoRestController.RunExtensions(Trigger.BeforeGeneratingCode, codeModel);

                // Generate code from CodeModel.
                plugin.CodeGenerator.Generate(codeModel).GetAwaiter().GetResult();
            }

            return fileSystem;
        }

        internal static string SaveFilesToTemp(this IFileSystem fileSystem, string folderName = null)
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

            return outputFolder;
        }

        internal static bool IsNullableValueType(this Type type) => type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>);
    }
}