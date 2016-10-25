// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using Newtonsoft.Json.Linq;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.AzureResourceSchema.Tests
{
    [Collection("AutoRest Tests")]
    public class AzureResourceSchemaCodeGeneratorTests
    {
        [Fact]
        public void Description()
        {
            using (NewContext) {
                new Settings();
                Assert.Equal("Azure Resource Schema generator", CreatePlugin().Settings.Description);
            }
        }

        [Fact]
        public void ImplementationFileExtension()
        {
            using (NewContext) {
                new Settings();
                Assert.Equal(".json", CreatePlugin().CodeGenerator.ImplementationFileExtension);
            }
        }

        [Fact]
        public void Name()
        {
            using (NewContext) {
                new Settings();
                Assert.Equal("AzureResourceSchema", CreatePlugin().Settings.Name);
            }
        }

        [Fact]
        public void UsageInstructionsWithNoOutputFileSetting()
        {
            using (NewContext) {
                new Settings();
                PluginArs plugin = CreatePlugin();
                Assert.Equal("Your Azure Resource Schema(s) can be found in " + Settings.Instance.OutputDirectory, plugin.CodeGenerator.UsageInstructions);
            }
        }

        [Fact]
        public void UsageInstructionsWithOutputFileSetting()
        {
            using (NewContext) {
                Settings settings = new Settings() {
                    OutputFileName = "spam.json"
                };
                PluginArs plugin = CreatePlugin();

                Assert.Equal("Your Azure Resource Schema(s) can be found in " + settings.OutputDirectory, plugin.CodeGenerator.UsageInstructions);
            }
        }


        private static PluginArs CreatePlugin()
        {
            return new PluginArs();
        }

        private static async Task TestGenerate(string apiVersion, string[] methodUrls, string expectedJsonString)
        {
            using (NewContext) {
                MemoryFileSystem fileSystem = new MemoryFileSystem();

                Settings settings = new Settings();
                settings.FileSystem = fileSystem;

                CodeModel serviceClient = New<CodeModel>();
                serviceClient.ApiVersion = apiVersion;
                foreach (string methodUrl in methodUrls) {
                    serviceClient.Add(New<Method>(new {
                        Url = methodUrl,
                        HttpMethod = HttpMethod.Put,
                    }));
                }
                await CreatePlugin().CodeGenerator.Generate(serviceClient);

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
}
