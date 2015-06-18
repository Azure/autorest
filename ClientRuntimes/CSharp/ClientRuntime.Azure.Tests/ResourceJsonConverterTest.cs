// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using Microsoft.Rest.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Xunit;
using Microsoft.Azure;

namespace Microsoft.Rest.ClientRuntime.Azure.Test
{
    public class ResourceJsonConverterTest
    {
        [Fact]
        public void TestResourceSerialization()
        {
            var sampleResource = new SampleResource()
            {
                Size = "3",
                Child = new SampleResourceChild1()
                {
                    ChildName1 = "name1"
                },
                Location = "EastUS"
            };
            sampleResource.Tags = new Dictionary<string, string>();
            sampleResource.Tags["tag1"] = "value1";
            var serializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            serializeSettings.Converters.Add(new ResourceJsonConverter());
            serializeSettings.Converters.Add(new PolymorphicSerializeJsonConverter<SampleResourceChild>("dType"));
            string json = JsonConvert.SerializeObject(sampleResource, serializeSettings);
            Assert.Equal(@"{
  ""location"": ""EastUS"",
  ""tags"": {
    ""tag1"": ""value1""
  },
  ""properties"": {
    ""size"": ""3"",
    ""child"": {
      ""dType"": ""SampleResourceChild1"",
      ""location"": null,
      ""tags"": null,
      ""properties"": {
        ""name1"": ""name1""
      }
    },
    ""name"": null
  }
}", json);
            
            var deserializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            deserializeSettings.Converters.Add(new ResourceJsonConverter());
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<SampleResourceChild>("dType"));
            var deserializedResource = JsonConvert.DeserializeObject<SampleResource>(json, deserializeSettings);
            var jsonoverProcessed = JsonConvert.SerializeObject(deserializedResource, serializeSettings);

            Assert.Equal(json, jsonoverProcessed);
        }

        [Fact]
        public void TestResourceSerializationWithPolymorphism()
        {
            var sampleResource = new SampleResource()
            {
                Size = "3",
                Child = new SampleResourceChild1(),
                Location = "EastUS"
            };
            sampleResource.Tags = new Dictionary<string, string>();
            sampleResource.Tags["tag1"] = "value1";
            var serializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            serializeSettings.Converters.Add(new ResourceJsonConverter());
            serializeSettings.Converters.Add(new PolymorphicSerializeJsonConverter<Resource>("dType"));
            serializeSettings.Converters.Add(new PolymorphicSerializeJsonConverter<SampleResourceChild>("dType"));
            string json = JsonConvert.SerializeObject(sampleResource, serializeSettings);
            Assert.Equal(@"{
  ""dType"": ""SampleResource"",
  ""location"": ""EastUS"",
  ""tags"": {
    ""tag1"": ""value1""
  },
  ""properties"": {
    ""size"": ""3"",
    ""child"": {
      ""dType"": ""SampleResourceChild1"",
      ""location"": null,
      ""tags"": null,
      ""properties"": {
        ""name1"": null
      }
    },
    ""name"": null
  }
}", json);
        }

        [Fact]
        public void TestGenericResourceSerialization()
        {
            var sampleResource = new GenericResource()
            {
                Location = "EastUS",
                Properties = JObject.Parse("{ \"size\" : \"3\" }")
            };
            sampleResource.Tags = new Dictionary<string, string>();
            sampleResource.Tags["tag1"] = "value1";
            var serializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            serializeSettings.Converters.Add(new ResourceJsonConverter());
            serializeSettings.Converters.Add(new PolymorphicSerializeJsonConverter<SampleResourceChild>("dType"));
            string json = JsonConvert.SerializeObject(sampleResource, serializeSettings);
            Assert.Equal(@"{
  ""properties"": {
    ""size"": ""3""
  },
  ""location"": ""EastUS"",
  ""tags"": {
    ""tag1"": ""value1""
  }
}", json);

            var deserializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            deserializeSettings.Converters.Add(new ResourceJsonConverter());
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<SampleResourceChild>("dType"));
            var deserializedResource = JsonConvert.DeserializeObject<GenericResource>(json, deserializeSettings);
            var jsonoverProcessed = JsonConvert.SerializeObject(deserializedResource, serializeSettings);

            Assert.Equal(json, jsonoverProcessed);
        }
        
        [Fact]
        public void TestProvisioningStateDeserialization()
        {
            var expected = @"{
                              ""location"": ""EastUS"",
                              ""tags"": {
                                ""tag1"": ""value1""
                              },
                              ""properties"": {
                                ""size"": ""3"",
                                ""provisioningState"": ""some string"",
                                ""child"": {
                                  ""dType"": ""SampleResourceChild1"",
                                  ""name1"": ""name1"",
                                  ""id"": ""child""
                                }
                              }
                            }";

            var deserializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            deserializeSettings.Converters.Add(new ResourceJsonConverter());
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<SampleResourceChild>("dType"));
            var deserializedResource = JsonConvert.DeserializeObject<SampleResource>(expected, deserializeSettings);

            Assert.Equal("some string", deserializedResource.ProvisioningState);
        }

        [Fact]
        public void TestGenericResourceDeserialization()
        {
            var expected = @"{
                              ""location"": ""EastUS"",
                              ""tags"": {
                                ""tag1"": ""value1""
                              },
                              ""properties"": {
                                ""size"": ""3"",
                                ""provisioningState"": ""some string"",
                                ""child"": {
                                  ""dType"": ""SampleResourceChild1"",
                                  ""name1"": ""name1"",
                                  ""id"": ""child""
                                }
                              }
                            }";

            var deserializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            deserializeSettings.Converters.Add(new ResourceJsonConverter());
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<SampleResourceChild>("dType"));
            var deserializedResource = JsonConvert.DeserializeObject<GenericResource>(expected, deserializeSettings);

            Assert.Equal("some string", deserializedResource.ProvisioningState);
            Assert.Equal("EastUS", deserializedResource.Location);
            Assert.Equal("value1", deserializedResource.Tags["tag1"]);
            Assert.Equal("3", ((JObject)deserializedResource.Properties)["size"]);
            Assert.Equal("name1", ((JObject)deserializedResource.Properties)["child"]["name1"]);
        }
    }
}
