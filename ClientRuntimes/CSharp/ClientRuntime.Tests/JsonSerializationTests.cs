// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using Microsoft.Rest.ClientRuntime.Tests.Fakes;
using Microsoft.Rest.ClientRuntime.Tests.Resources;
using Microsoft.Rest.TransientFaultHandling;
using Newtonsoft.Json;
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
            serializeSettings.Converters.Add(new PolymorphicJsonSerializer<Animal>("dType"));

            var deserializeSettings = new JsonSerializerSettings();
            deserializeSettings.ReferenceLoopHandling = ReferenceLoopHandling.Serialize;
            deserializeSettings.Converters.Add(new PolymorphicJsonDeserializer<Animal>("dType"));

            var serializedJson = JsonConvert.SerializeObject(zoo, Formatting.Indented, serializeSettings);
            var zoo2 = JsonConvert.DeserializeObject<Zoo>(serializedJson, deserializeSettings);

            Assert.Equal(zoo.Animals[0].GetType(), zoo2.Animals[0].GetType());
            Assert.Equal(zoo.Animals[1].GetType(), zoo2.Animals[1].GetType());
            Assert.Equal(((Cat)zoo.Animals[1]).Dislikes.GetType(), ((Cat)zoo2.Animals[1]).Dislikes.GetType());
            Assert.Contains("dType", serializedJson);
        }
    }
}