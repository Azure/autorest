// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.IO;
using AutoRest.Core.Configuration;
using AutoRest.Core.Model;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Logging;
using AutoRest.Core.Tests.Resource;
using AutoRest.Core.Utilities;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Tests
{
    [Collection("AutoRest Tests")]
    public class ExtensionsLoaderTests
    {
        private readonly IFileSystem _fileSystem = new MemoryFileSystem();

        public ExtensionsLoaderTests()
        {
            SetupMock();
        }

        private void SetupMock()
        {
            _fileSystem.WriteAllText("RedisResource.json", File.ReadAllText(Path.Combine("Resource", "RedisResource.json")));
        }

        [Fact]
        public void LanguageWithSettingsLoadsFromJsonFile()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    FileSystemInput = _fileSystem,
                    Input = "X:\\RedisResource.json",
                    OutputDirectory = "X:\\Output"
                };
                
                var language = ExtensionsLoader.GetPlugin(AutoRestConfiguration.CreateForPlugin("NodeJS"));
                settings.Validate();

                Assert.Equal("NodeJS", language.Settings.Name);
            }
        }

        [Fact]
        public void LanguageLoadsFromJsonFile()
        {
            using (NewContext)
            {
                var settings = new Settings {FileSystemInput = _fileSystem};
                var language = ExtensionsLoader.GetPlugin(AutoRestConfiguration.CreateForPlugin("CSharp"));

                Assert.Equal("CSharp", language.Settings.Name);
            }
        }

        [Fact]
        public void LanguageWithoutSettingsLoadsFromJsonFile()
        {
            using (NewContext)
            {
                var settings = new Settings {FileSystemInput = _fileSystem};

                var language = ExtensionsLoader.GetPlugin(AutoRestConfiguration.CreateForPlugin("CSharp"));
                Assert.Equal("CSharp", language.Settings.Name);
            }
        }

        public void InvalidModelerNameThrowsException()
        {
            using (NewContext)
            {
                string modeler = "Foo.Bar";
                var settings = new Settings { FileSystemInput = _fileSystem};
                AssertThrows<CodeGenerationException>(
                    () => ExtensionsLoader.GetModeler(modeler),
                    string.Format("Plugin {0} does not have an assembly name in AutoRest.json", modeler));
            }
        }

        [Fact]
        public void NullOrEmptyAutoRestSettings()
        {
            using (NewContext)
            {
                var settings = new Settings { FileSystemInput = _fileSystem};
                Assert.Throws<CodeGenerationException>(() => ExtensionsLoader.GetModeler(string.Empty));
            }
        }

        [Fact]
        public void InvalidLanguageNameThrowsException()
        {
            using (NewContext)
            {
                string codeGenerator = "Foo.Bar";
                var settings = new Settings
                {
                    FileSystemInput = _fileSystem
                };
            

            AssertThrows<CodeGenerationException>(
                () => ExtensionsLoader.GetPlugin(AutoRestConfiguration.CreateForPlugin(codeGenerator)),
                $"Plugin {codeGenerator} does not have an assembly name in configuration");
            }
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
