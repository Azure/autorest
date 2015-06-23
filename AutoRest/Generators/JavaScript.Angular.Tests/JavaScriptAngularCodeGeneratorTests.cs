// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Utilities;
using Xunit;

namespace Microsoft.Rest.Generator.JavaScript.Angular.Tests
{
    [Collection("AutoRest Tests")]
    public class CSharpCodeGeneratorTests
    {
        private readonly MemoryFileSystem _fileSystem = new MemoryFileSystem();

        public CSharpCodeGeneratorTests()
        {
            Logger.Entries.Clear();
            SetupMock();
        }

        private void SetupMock()
        {
            _fileSystem.WriteFile("AutoRest.json", File.ReadAllText("Resource\\AutoRest.json"));
            _fileSystem.WriteFile("RedisResource.json", File.ReadAllText("Resource\\RedisResource.json"));
            _fileSystem.WriteFile("swagger.2.0.example.json", File.ReadAllText("Resource\\swagger.2.0.example.json"));
        }

        [Fact]
        public void GenerateRedisModel()
        {
            var settings = new Settings
            {
                CodeGenerator = "Angular",
                FileSystem = _fileSystem,
                OutputDirectory = "X:\\Output",
                Modeler = "Swagger",
                Input = "RedisResource.json"
            };

            AutoRest.Generate(settings);

            Assert.Contains("RedisResource.json", _fileSystem.VirtualStore.Keys);
        }

        [Fact]
        public void GeneratePetStoreModel()
        {
            var settings = new Settings
            {
                CodeGenerator = "Angular",
                FileSystem = _fileSystem,
                OutputDirectory = "X:\\Output",
                Modeler = "Swagger",
                Input = "swagger.2.0.example.json"
            };

            AutoRest.Generate(settings);

            Assert.NotEmpty(_fileSystem.VirtualStore[@"X:\Output\SwaggerPetstore.cs"].ToString());
        }
    }
}