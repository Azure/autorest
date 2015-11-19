// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using Microsoft.Rest.ClientRuntime.Tests.Resources;
using Microsoft.Rest.Serialization;
using Microsoft.Rest.TransientFaultHandling;
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
      ""name"": ""Felix""
    }
  ]
}";

            var zoo2 = JsonConvert.DeserializeObject<Zoo>(zooWithPrivateSet, deserializeSettings);

            Assert.Equal("grey", ((Siamese)zoo2.Animals[2]).Color);

            var serializeSettings = new JsonSerializerSettings();
            serializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            serializeSettings.NullValueHandling = NullValueHandling.Ignore;
            serializeSettings.Formatting = Formatting.Indented;
            serializeSettings.Converters.Add(new PolymorphicSerializeJsonConverter<Animal>("dType"));
            var zooReserialized = JsonConvert.SerializeObject(zoo2, serializeSettings);

            Assert.Equal(zooWithPrivateSet, zooReserialized);
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

        [Fact]
        public void DateSerializationWithoutNulls()
        {
            var localDateTimeOffset = new DateTimeOffset(2015, 6, 1, 16, 10, 08, 121, new TimeSpan(-7, 0, 0));
            var utcDate = DateTime.Parse("2015-06-01T00:00:00.0", CultureInfo.InvariantCulture);
            var serializeSettings = new JsonSerializerSettings();
            serializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            serializeSettings.Formatting = Formatting.Indented;
            serializeSettings.DateFormatHandling = DateFormatHandling.IsoDateFormat;
            serializeSettings.DateTimeZoneHandling = DateTimeZoneHandling.Utc;

            DateTestObject test = new DateTestObject();
            test.Date = localDateTimeOffset.LocalDateTime;
            test.DateNullable = localDateTimeOffset.LocalDateTime;
            test.DateTime = localDateTimeOffset.LocalDateTime;
            test.DateTimeNullable = localDateTimeOffset.LocalDateTime;
            test.DateTimeOffset = localDateTimeOffset;
            test.DateTimeOffsetNullable = localDateTimeOffset;
            test.DateTimeOffsetWithConverter = localDateTimeOffset;
            test.DateTimeOffsetNullableWithConverter = localDateTimeOffset;

            var expectedJson = @"{
  ""d"": ""2015-06-01"",
  ""dt"": ""2015-06-01T23:10:08.121Z"",
  ""dn"": ""2015-06-01T23:10:08.121Z"",
  ""dtn"": ""2015-06-01"",
  ""dtoc"": ""2015-06-01"",
  ""dtonc"": ""2015-06-01"",
  ""dto"": ""2015-06-01T16:10:08.121-07:00"",
  ""dton"": ""2015-06-01T16:10:08.121-07:00""
}";
            var json = JsonConvert.SerializeObject(test, serializeSettings);

            DateTestObject testRoundtrip = JsonConvert.DeserializeObject<DateTestObject>(json, serializeSettings);
            Assert.Equal(expectedJson, json);
            Assert.Equal(utcDate, testRoundtrip.Date);
            Assert.Equal(localDateTimeOffset, testRoundtrip.DateTime.ToLocalTime());
            Assert.Equal(test.DateTimeOffset, testRoundtrip.DateTimeOffset);
        }

        [Fact]
        public void DateSerializationWithNulls()
        {
            var serializeSettings = new JsonSerializerSettings();
            serializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            serializeSettings.Formatting = Formatting.Indented;
            serializeSettings.DateFormatHandling = DateFormatHandling.IsoDateFormat;
            serializeSettings.DateTimeZoneHandling = DateTimeZoneHandling.Utc;
            serializeSettings.NullValueHandling = NullValueHandling.Ignore;

            DateTestObject test = new DateTestObject();

            var expectedJson = @"{
  ""d"": ""0001-01-01"",
  ""dt"": ""0001-01-01T00:00:00Z"",
  ""dtoc"": ""0001-01-01"",
  ""dto"": ""0001-01-01T00:00:00+00:00""
}";
            var json = JsonConvert.SerializeObject(test, serializeSettings);

            DateTestObject testRoundtrip = JsonConvert.DeserializeObject<DateTestObject>(json, serializeSettings);

            Assert.Equal(expectedJson, json);
            Assert.Null(testRoundtrip.DateNullable);
            Assert.Null(testRoundtrip.DateTimeNullable);
        }

        [Fact]
        public void DateSerializationWithMaxValue()
        {
            var localDateTime = DateTime.Parse("9999-12-31T22:59:59-01:00", CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal).ToLocalTime();
            var serializeSettings = new JsonSerializerSettings();
            serializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            serializeSettings.Formatting = Formatting.Indented;
            serializeSettings.DateFormatHandling = DateFormatHandling.IsoDateFormat;
            serializeSettings.DateTimeZoneHandling = DateTimeZoneHandling.Utc;

            DateTestObject test = new DateTestObject();
            test.Date = localDateTime;
            test.DateNullable = localDateTime;
            test.DateTime = localDateTime;
            test.DateTimeNullable = localDateTime;
            test.DateTimeOffsetNullable = localDateTime;
            test.DateTimeOffsetNullableWithConverter = localDateTime;
            test.DateTimeOffsetWithConverter = localDateTime;

            var expectedJson = @"{
  ""d"": ""9999-12-31"",
  ""dt"": ""9999-12-31T23:59:59Z"",
  ""dn"": ""9999-12-31T23:59:59Z"",
  ""dtn"": ""9999-12-31"",
  ""dtoc"": ""9999-12-31"",
  ""dtonc"": ""9999-12-31"",
  ""dto"": ""0001-01-01T00:00:00+00:00"",
  ""dton"": """ + localDateTime.ToString("yyyy-MM-ddTHH:mm:sszzz") + @"""
}";
            var json = JsonConvert.SerializeObject(test, serializeSettings);

            DateTestObject testRoundtrip = JsonConvert.DeserializeObject<DateTestObject>(json, serializeSettings);
            Assert.Equal(localDateTime, testRoundtrip.DateTime.ToLocalTime());
            Assert.Equal(expectedJson, json);
        }
    }
}
