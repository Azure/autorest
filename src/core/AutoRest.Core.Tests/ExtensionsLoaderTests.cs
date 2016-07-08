// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Logging;
using AutoRest.Core.Tests.Resource;
using AutoRest.Core.Utilities;
using Xunit;

namespace AutoRest.Core.Tests
{
    [Collection("AutoRest Tests")]
    public class ExtensionsLoaderTests
    {
        private readonly IFileSystem _fileSystem = new MemoryFileSystem();

        public ExtensionsLoaderTests()
        {
            Logger.Entries.Clear();
            SetupMock();
        }

        private void SetupMock()
        {
            _fileSystem.WriteFile("AutoRest.json", File.ReadAllText(Path.Combine("Resource", "AutoRest.json")));
            _fileSystem.WriteFile("RedisResource.json", File.ReadAllText(Path.Combine("Resource", "RedisResource.json")));
        }

        [Fact]
        public void LanguageWithSettingsLoadsFromJsonFile()
        {
            var settings = new Settings
            {
                CodeGenerator = "NodeJS",
                FileSystem = _fileSystem,
                Input = "X:\\RedisResource.json",
                OutputDirectory = "X:\\Output"
            };
            CodeGenerator language = ExtensionsLoader.GetCodeGenerator(settings);
            settings.Validate();

            Assert.Equal("NodeJS", language.Name);
        }

        [Fact]
        public void LanguageLoadsFromJsonFile()
        {
            var settings = new Settings { CodeGenerator = "CSharp", FileSystem = _fileSystem };
            CodeGenerator language = ExtensionsLoader.GetCodeGenerator(settings);

            Assert.Equal("CSharp", language.Name);
        }

        [Fact]
        public void LanguageWithoutSettingsLoadsFromJsonFile()
        {
            CodeGenerator language =
                ExtensionsLoader.GetCodeGenerator(new Settings {CodeGenerator = "CSharp", FileSystem = _fileSystem});
            Assert.Equal("CSharp", language.Name);
        }

        [Fact]
        public void ModelerLoadsFromJsonFile()
        {
            var settings = new Settings {Modeler = "Swagger", Input = "RedisResource.json", FileSystem = _fileSystem};
            Modeler modeler = ExtensionsLoader.GetModeler(settings);

            Assert.Equal("Swagger", modeler.Name);
        }

        [Fact]
        public void InvalidModelerNameThrowsException()
        {
            string modeler = "Foo.Bar";
            AssertThrows<CodeGenerationException>(
                () => ExtensionsLoader.GetModeler(new Settings {Modeler = modeler, FileSystem = _fileSystem}),
                string.Format("Plugin {0} does not have an assembly name in AutoRest.json", modeler));
        }

        [Fact]
        public void NullOrEmptyAutoRestSettings()
        {
            Assert.Throws<ArgumentNullException>(() => ExtensionsLoader.GetCodeGenerator(null));
            Assert.Throws<ArgumentException>(() => ExtensionsLoader.GetCodeGenerator(
                new Settings {CodeGenerator = string.Empty, FileSystem = _fileSystem}));

            Assert.Throws<ArgumentNullException>(() => ExtensionsLoader.GetModeler(null));
            Assert.Throws<ArgumentException>(() => ExtensionsLoader.GetModeler(
                new Settings {Modeler = string.Empty, FileSystem = _fileSystem}));
        }

        [Fact]
        public void InvalidLanguageNameThrowsException()
        {
            string codeGenerator = "Foo.Bar";
            AssertThrows<CodeGenerationException>(
                () =>
                    ExtensionsLoader.GetCodeGenerator(new Settings
                    {
                        CodeGenerator = codeGenerator,
                        FileSystem = _fileSystem
                    }),
                string.Format("Plugin {0} does not have an assembly name in AutoRest.json", codeGenerator));
        }

        [Fact]
        public void InvalidJsonFileThrowsException()
        {
            _fileSystem.WriteFile("AutoRest.json", "{'foo': 'bar'}");
            AssertThrows<CodeGenerationException>(() => ExtensionsLoader.GetCodeGenerator
                (new Settings {CodeGenerator = "JavaScript", FileSystem = _fileSystem}),
                string.Format("Plugin {0} does not have an assembly name in AutoRest.json", "JavaScript"));

            _fileSystem.WriteFile("AutoRest.json", "{'foo': ");
            AssertThrows<CodeGenerationException>(() => ExtensionsLoader.GetCodeGenerator
                (new Settings {CodeGenerator = "JavaScript", FileSystem = _fileSystem}),
                "Error parsing AutoRest.json file");
        }

        [Fact]
        public void NoJsonFileThrowsException()
        {
            _fileSystem.DeleteFile("AutoRest.json");
            AssertThrows<CodeGenerationException>(() => ExtensionsLoader.GetCodeGenerator
                (new Settings {CodeGenerator = "JavaScript", FileSystem = _fileSystem}),
                "AutoRest.json was not found in the current directory");
        }

        [Fact]
        public void InvalidTypeThrowsException()
        {
            _fileSystem.WriteFile("AutoRest.json", File.ReadAllText(Path.Combine("Resource", "AutoRestWithInvalidType.json")));

            AssertThrows<CodeGenerationException>(() => ExtensionsLoader.GetCodeGenerator
                (new Settings {CodeGenerator = "CSharp", FileSystem = _fileSystem}),
                string.Format("Error loading {0} assembly", "CSharp"));

            AssertThrows<CodeGenerationException>(() => ExtensionsLoader.GetCodeGenerator
                (new Settings {CodeGenerator = "Java", FileSystem = _fileSystem}),
                string.Format("Error loading {0} assembly", "Java"));
        }

        [Fact]
        public void LoadFromLoadsServiceClient()
        {
            var source = new ServiceClient();
            source.Name = "Foo";
            source.Methods.Add(new Method
            {
                Description = "Create or update a cache.",
                Summary = "Some summary",
                Name = "CreateOrUpdate",
                Url = "/subscription/{subscriptionId}/start/{startDate}"
            });
            var templateModel = new SampleServiceClientTemplateModel(source);
            Assert.Equal(source.Name, templateModel.Name);
            Assert.Equal(source.Methods.Count, templateModel.Methods.Count);
        }

        private void AssertThrows<T>(Action action, string message) where T : Exception
        {
            try
            {
                action();
                Assert.True(false);
            }
            catch (T ex)
            {
                Assert.Contains(message, ex.Message);
            }
        }
    }
}
