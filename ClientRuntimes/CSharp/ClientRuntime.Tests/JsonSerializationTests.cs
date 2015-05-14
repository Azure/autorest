// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.ClientRuntime.Tests.Resources;
using Microsoft.Rest.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Xunit;

namespace Microsoft.Rest.ClientRuntime.Tests
{
    public class JsonSerializationTests
    {
        [Fact]
        public void PolymorphicSerializeWorks()
        {
            Zoo zoo = new Zoo() { Id = 1 };
            zoo.Animals.Add(new Dog() { Name = "Fido", LikesDogfood = true });
            zoo.Animals.Add(new Cat() { Name = "Felix", LikesMice = false, Dislikes = new Dog() { Name = "Angry", LikesDogfood = true } });
            var serializeSettings = new JsonSerializerSettings();
            serializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            serializeSettings.Converters.Add(new PolymorphicSerializeJsonConverter<Animal>("dType"));

            var deserializeSettings = new JsonSerializerSettings();
            deserializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<Animal>("dType"));

            var serializedJson = JsonConvert.SerializeObject(zoo, Formatting.Indented, serializeSettings);
            var zoo2 = JsonConvert.DeserializeObject<Zoo>(serializedJson, deserializeSettings);

            Assert.Equal(zoo.Animals[0].GetType(), zoo2.Animals[0].GetType());
            Assert.Equal(zoo.Animals[1].GetType(), zoo2.Animals[1].GetType());
            Assert.Equal(((Cat)zoo.Animals[1]).Dislikes.GetType(), ((Cat)zoo2.Animals[1]).Dislikes.GetType());
            Assert.Contains("dType", serializedJson);
        }

        [Fact]
        public void PolymorphismWorksWithReadOnlyProperties()
        {
            var deserializeSettings = new JsonSerializerSettings();
            deserializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            deserializeSettings.NullValueHandling = NullValueHandling.Ignore;
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<Animal>("dType"));

            string zooWithPrivateSet = @"{
              ""Id"": 1,
              ""Animals"": [
                {
                  ""dType"": ""dog"",
                  ""likesDogfood"": true,
                  ""name"": ""Fido""
                },
                {
                  ""dType"": ""cat"",
                  ""likesMice"": false,
                  ""dislikes"": {
                    ""dType"": ""dog"",
                    ""likesDogfood"": true,
                    ""name"": ""Angry""
                  },
                  ""name"": ""Felix""
                },
                {
                  ""dType"": ""siamese"",
                  ""color"": ""grey"",
                  ""likesMice"": false,
                  ""dislikes"": null,
                  ""name"": ""Felix""
                }
              ]
            }";

            var zoo2 = JsonConvert.DeserializeObject<Zoo>(zooWithPrivateSet, deserializeSettings);

            Assert.Equal("grey", ((Siamese)zoo2.Animals[2]).Color);
        }

        [Fact]
        public void RawJsonIsSerialized()
        {
            var serializeSettings = new JsonSerializerSettings();
            serializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            serializeSettings.ContractResolver = new ReadOnlyJsonContractResolver();

            var firstAlienJson = JsonConvert.SerializeObject(new Alien("green") { Name = "autorest", Planet = "Mars", Body = JObject.Parse(@"{ ""custom"" : ""json"" }") }, 
                Formatting.Indented, serializeSettings);

            var firstAlien = JsonConvert.DeserializeObject<Alien>(firstAlienJson, serializeSettings);

            string secondAlienJson = @"{
                    ""color"": ""green"",
                    ""planet"": ""Mars"",
                    ""name"": ""autorest"",
                    ""body"": { ""custom"" : ""json"" },
                }";

            var secondAlien = JsonConvert.DeserializeObject<Alien>(secondAlienJson, serializeSettings);

            Assert.Equal("autorest", firstAlien.Name);
            Assert.Null(firstAlien.Color);
            Assert.Null(firstAlien.GetPlanetName());
            Assert.Equal("json", firstAlien.Body.custom.ToString());

            Assert.Equal("autorest", secondAlien.Name);
            Assert.Equal("green", secondAlien.Color);
            Assert.Equal("json", secondAlien.Body.custom.ToString());
        }

        [Fact]
        public void ReadOnlyPropertiesWorkStandalone()
        {
            var serializeSettings = new JsonSerializerSettings();
            serializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            serializeSettings.ContractResolver = new ReadOnlyJsonContractResolver();

            var firstAlienJson = JsonConvert.SerializeObject(new Alien("green") { Name = "autorest", Planet = "Mars" },
                Formatting.Indented, serializeSettings);

            var firstAlien = JsonConvert.DeserializeObject<Alien>(firstAlienJson, serializeSettings);

            string secondAlienJson = @"{
                    ""color"": ""green"",
                    ""planet"": ""Mars"",
                    ""name"": ""autorest""
                }";

            var secondAlien = JsonConvert.DeserializeObject<Alien>(secondAlienJson, serializeSettings);

            Assert.Equal("autorest", firstAlien.Name);
            Assert.Null(firstAlien.Color);
            Assert.Null(firstAlien.GetPlanetName());

            Assert.Equal("autorest", secondAlien.Name);
            Assert.Equal("green", secondAlien.Color);
            Assert.Equal("Mars", secondAlien.GetPlanetName());
        }
    }
}