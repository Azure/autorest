// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using Newtonsoft.Json.Linq;
using Xunit;

namespace AutoRest.AzureResourceSchema.Tests
{
    [Collection("AutoRest Tests")]
    public class AzureResourceSchemaCodeGeneratorTests
    {
        [Fact]
        public void Description()
        {
            Assert.Equal("Azure Resource Schema generator", CreateGenerator().Description);
        }

        [Fact]
        public void ImplementationFileExtension()
        {
            Assert.Equal(".json", CreateGenerator().ImplementationFileExtension);
        }

        [Fact]
        public void Name()
        {
            Assert.Equal("AzureResourceSchema", CreateGenerator().Name);
        }

        [Fact]
        public void UsageInstructionsWithNoOutputFileSetting()
        {
            AzureResourceSchemaCodeGenerator codeGen = CreateGenerator();
            Assert.Equal("Your Azure Resource Schema(s) can be found in " + codeGen.Settings.OutputDirectory, codeGen.UsageInstructions);
        }

        [Fact]
        public void UsageInstructionsWithOutputFileSetting()
        {
            Settings settings = new Settings()
            {
                OutputFileName = "spam.json"
            };
            AzureResourceSchemaCodeGenerator codeGen = CreateGenerator(settings);

            Assert.Equal("Your Azure Resource Schema(s) can be found in " + settings.OutputDirectory, codeGen.UsageInstructions);
        }

        [Fact]
        public void NormalizeClientModelDoesNothing()
        {
            ServiceClient serviceClient = new ServiceClient();
            CreateGenerator().NormalizeClientModel(serviceClient);

            // Nothing happens
        }

        private static AzureResourceSchemaCodeGenerator CreateGenerator()
        {
            return CreateGenerator(new Settings());
        }
        private static AzureResourceSchemaCodeGenerator CreateGenerator(Settings settings)
        {
            return new AzureResourceSchemaCodeGenerator(settings);
        }

        private static async Task TestGenerate(string apiVersion, string[] methodUrls, string expectedJsonString)
        {
            MemoryFileSystem fileSystem = new MemoryFileSystem();

            Settings settings = new Settings();
            settings.FileSystem = fileSystem;

            ServiceClient serviceClient = new ServiceClient();
            serviceClient.ApiVersion = apiVersion;
            foreach(string methodUrl in methodUrls)
            {
                serviceClient.Methods.Add(new Method()
                {
                    Url = methodUrl,
                    HttpMethod = HttpMethod.Put,
                });
            }
            await CreateGenerator(settings).Generate(serviceClient);

            Assert.Equal(2, fileSystem.VirtualStore.Count);

            string folderPath = fileSystem.VirtualStore.Keys.First();
            Assert.Equal("Folder", fileSystem.VirtualStore[folderPath].ToString());

            JObject expectedJSON = JObject.Parse(expectedJsonString);

            string fileContents = fileSystem.VirtualStore[fileSystem.VirtualStore.Keys.Skip(1).First()].ToString();
            JObject actualJson = JObject.Parse(fileContents);

            Assert.Equal(expectedJSON, actualJson);
        }
    }
}
