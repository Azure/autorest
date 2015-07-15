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
    public class PageJsonConverterTest
    {
        public class Product
        {
            [JsonProperty(PropertyName = "id")]
            public string Id { get; set; }

            [JsonProperty(PropertyName = "name")]
            public string Name { get; set; }

            public Product()
            {

            }
            public Product(string id, string name)
            {
                this.Id = id;
                this.Name = name;
            }
        }

        [Fact]
        public void TestPageDeSerialization()
        {
            var responseBody = @"{
  ""value"": [
    {
      ""id"": ""Product_1"",
      ""name"": ""ProductOne""
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
            deserializeSettings.Converters.Add(new PageJsonConverter());
            deserializeSettings.Converters.Add(new PolymorphicDeserializeJsonConverter<Product>("dType"));
            var deserializedProduct = JsonConvert.DeserializeObject<Page<Product>>(responseBody, deserializeSettings);

            Assert.Equal("https://sdktestvault7826.vault.azure.net:443/keys?api-version=2015-06-01", deserializedProduct.NextPage);
        }
    }
}
