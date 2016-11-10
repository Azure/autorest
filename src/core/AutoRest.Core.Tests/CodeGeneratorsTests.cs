// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Text;
using AutoRest.Core.Model;
using AutoRest.Core.Logging;
using AutoRest.Core.Tests.Resource;
using AutoRest.Core.Tests.Templates;
using AutoRest.Core.Utilities;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;
namespace AutoRest.Core.Tests
{
    [Collection("AutoRest Tests")]
    public class CodeGeneratorsTests
    {
        private readonly MemoryFileSystem _fileSystem = new MemoryFileSystem();

        public CodeGeneratorsTests()
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
        public void CodeWriterCreatesDirectory()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    CodeGenerator = "CSharp",
                    FileSystem = _fileSystem,
                    OutputDirectory = Path.GetTempPath()
                };
                SampleCodeGenerator codeGenerator = new SampleCodeGenerator();
                codeGenerator.Generate(New<CodeModel>()).GetAwaiter().GetResult();
                Assert.Contains(Path.Combine(settings.OutputDirectory, settings.ModelsName),
                    _fileSystem.VirtualStore.Keys);
            }
        }

        [Fact]
        public void CodeWriterWrapsComments()
        {
            var sampleModelTemplate = new SampleModel();
            var sampleViewModel = new SampleViewModel();

            sampleModelTemplate.Model = sampleViewModel;
            var output = sampleModelTemplate.ToString();
            Assert.True(output.ContainsMultiline(@"/// Deserialize current type to Json object because today is Friday and
        /// there is a sun outside the window."));
        }

        [Fact]
        public void CodeWriterWritesCRefAttribute()
        {
            var sampleModelTemplate = new SampleModel();
            var sampleViewModel = new SampleViewModel();

            sampleModelTemplate.Model = sampleViewModel;
            var output = sampleModelTemplate.ToString();
            Assert.True(output.Contains("/// <exception cref=\"CloudException\">"));
            Assert.True(output.Contains("/// <exception cref=\"ArgumentNullException\">"));
        }

        [Fact]
        public void CodeWriterOverwritesExistingFile()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    CodeGenerator = "CSharp",
                    FileSystem = _fileSystem,
                    OutputDirectory = Path.GetTempPath()
                };
                string existingContents = "this is dummy";
                string path = Path.Combine(settings.OutputDirectory, settings.ModelsName, "Pet.cs");
                _fileSystem.VirtualStore[path] = new StringBuilder(existingContents);
                var codeGenerator = new SampleCodeGenerator();
                codeGenerator.Generate(New<CodeModel>()).GetAwaiter().GetResult();
                Assert.NotEqual(existingContents, _fileSystem.VirtualStore[path].ToString());
            }
        }

        [Fact]
        public void OutputToSingleFile()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Modeler = "Swagger",
                    CodeGenerator = "CSharp",
                    Input = "RedisResource.json",
                    FileSystem = _fileSystem,
                    OutputDirectory = Path.GetTempPath(),
                    OutputFileName = "test.file.cs"
                };

                string path = Path.Combine(settings.OutputDirectory, "test.file.cs");
                string existingContents = "this is dummy";
                _fileSystem.VirtualStore[path] = new StringBuilder(existingContents);
                var codeGenerator = new SampleCodeGenerator();
                codeGenerator.Generate(New<CodeModel>()).GetAwaiter().GetResult();
                Assert.DoesNotContain(existingContents, _fileSystem.VirtualStore[path].ToString());
                Assert.Equal(4, _fileSystem.VirtualStore.Count);
                Assert.True(_fileSystem.VirtualStore.ContainsKey(path));
                Assert.True(_fileSystem.VirtualStore.ContainsKey("AutoRest.json"));
                Assert.True(_fileSystem.VirtualStore.ContainsKey("RedisResource.json"));
            }
        }
    }
}
