// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Newtonsoft.Json.Linq;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace Microsoft.Rest.Generator.AzureResourceSchema.Tests
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
            Assert.Equal("Your Azure Resource Schema can be found at " + codeGen.SchemaPath, codeGen.UsageInstructions);
        }

        [Fact]
        public void UsageInstructionsWithOutputFileSetting()
        {
            Settings settings = new Settings()
            {
                OutputFileName = "spam.json"
            };
            AzureResourceSchemaCodeGenerator codeGen = CreateGenerator(settings);

            Assert.Equal("Your Azure Resource Schema can be found at " + codeGen.SchemaPath, codeGen.UsageInstructions);
        }

        [Fact]
        public async void GenerateWithEmptyServiceClient()
        {
            await TestGenerate(null, new string[0],
            @"{
                ""id"": null,
                ""$schema"": ""http://json-schema.org/draft-04/schema#"",
                ""title"": null,
                ""description"": null,
                ""resourceDefinitions"": { }
            }");
        }

        [Fact]
        public async void GenerateWithServiceClientWithOneType()
        {
            await TestGenerate(null, new string[]
            {
                "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Mock.Provider/mockType"
            },
            @"{
                ""id"": null,
                ""$schema"": ""http://json-schema.org/draft-04/schema#"",
                ""title"": ""Mock.Provider"",
                ""description"": ""Mock Provider Resource Types"",
                ""resourceDefinitions"": {
                    ""mockType"": {
                        ""type"": ""object"",
                        ""properties"": {
                            ""type"": {
                                ""enum"": [
                                    ""Mock.Provider/mockType""
                                ]
                            },
                            ""apiVersion"": {
                                ""enum"": [
                                    null
                                ]
                            }
                        },
                        ""required"": [
                            ""type"",
                            ""apiVersion"",
                            ""properties""
                        ],
                        ""description"": ""Mock.Provider/mockType""
                    }
                }
            }");
        }

        [Fact]
        public async void GenerateWithServiceClientWithTwoTypes()
        {
            await TestGenerate("2016-05-01", new string[]
            {
                "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Mock.Provider/mockType1",
                "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Mock.Provider/mockType2"
            },
            @"{
                ""id"": ""http://schema.management.azure.com/schemas/2016-05-01/Mock.Provider.json#"",
                ""$schema"": ""http://json-schema.org/draft-04/schema#"",
                ""title"": ""Mock.Provider"",
                ""description"": ""Mock Provider Resource Types"",
                ""resourceDefinitions"": {
                    ""mockType1"": {
                        ""type"": ""object"",
                        ""properties"": {
                            ""type"": {
                                ""enum"": [
                                    ""Mock.Provider/mockType1""
                                ]
                            },
                            ""apiVersion"": {
                                ""enum"": [
                                    ""2016-05-01""
                                ]
                            }
                        },
                        ""required"": [
                            ""type"",
                            ""apiVersion"",
                            ""properties""
                        ],
                        ""description"": ""Mock.Provider/mockType1""
                    },
                    ""mockType2"": {
                        ""type"": ""object"",
                        ""properties"": {
                            ""type"": {
                                ""enum"": [
                                    ""Mock.Provider/mockType2""
                                ]
                            },
                            ""apiVersion"": {
                                ""enum"": [
                                    ""2016-05-01""
                                ]
                            }
                        },
                        ""required"": [
                            ""type"",
                            ""apiVersion"",
                            ""properties""
                        ],
                        ""description"": ""Mock.Provider/mockType2""
                    }
                }
            }");
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
