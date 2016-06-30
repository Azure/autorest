// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Fixtures.Azure.AcceptanceTestsPaging.Models;
using Xunit;
using Newtonsoft.Json;
using Microsoft.Rest.Serialization;
using Microsoft.Rest.Azure;
using System.Linq;

namespace AutoRest.CSharp.Azure.Tests
{
    public class TestProduct
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }

        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        public TestProduct()
        {
        }
    }

    public class PageJsonTest
    {
        [Fact]
        public void TestNullPageDeSerialization()
        {
            var responseBody = @"{
  ""nextLink"": ""https://sdktestvault7826.vault.azure.net:443/keys?api-version=2015-06-01""
}";

            var deserializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            deserializeSettings.Converters.Add(new ResourceJsonConverter());
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<TestProduct>("dType"));
            var deserializedProduct = JsonConvert.DeserializeObject<Page<TestProduct>>(responseBody, deserializeSettings);

            Assert.Equal(0, deserializedProduct.Count());
        }

        [Fact]
        public void TestNextLinkDeSerialization()
        {
            var responseBody = @"{
  ""values"": [
    {
      ""id"": ""Product_1"",
      ""name"": ""ProductOne""
    },
    {
      ""id"": ""Product_2"",
      ""name"": ""ProductThree""
    }
  ],
  ""nextLink"": ""https://sdktestvault7826.vault.azure.net:443/keys?api-version=2015-06-01""
}";

            var deserializeSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            deserializeSettings.Converters.Add(new ResourceJsonConverter());
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<TestProduct>("dType"));
            var deserializedProduct = JsonConvert.DeserializeObject<Page<TestProduct>>(responseBody, deserializeSettings);
            
            Assert.Equal(2, deserializedProduct.Count());
            Assert.Equal("https://sdktestvault7826.vault.azure.net:443/keys?api-version=2015-06-01", deserializedProduct.NextPageLink);
        }
    }
}
