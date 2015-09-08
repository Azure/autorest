// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Fixtures.MirrorRecursiveTypes;
using Fixtures.MirrorPolymorphic;
using Fixtures.MirrorPolymorphic.Models;
using Fixtures.MirrorPrimitives;
using Fixtures.MirrorSequences;
using Fixtures.MirrorSequences.Models;
using Microsoft.Rest.Modeler.Swagger.Tests;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Xunit;
using System.Net.Http;

namespace Microsoft.Rest.Generator.CSharp.Tests
{
    [Collection("AutoRest Tests")]
    public class MirrorTests
    {

        private static string ExpectedPath(string file)
        {
            return Path.Combine("Expected", file);
        }

        private static string SwaggerPath(string file)
        {
            return Path.Combine("Swagger", file);
        }

        [Fact]
        public void UrlIsCorrectWhenBaseUriContainsSegment()
        {
            var product = MirrorTestHelpers.GenerateProduct();
            using (var content = new StringContent(""))
            using (var message = new HttpResponseMessage { Content = content })
            using (var handler = new RecordedDelegatingHandler(message))
            using (var client = MirrorTestHelpers.CreateDataClient(handler))
            {
                client.BaseUri = new Uri("http://somesite/segment1/");
                client.PutProduct("200", product);
                Assert.Equal("http://somesite/segment1/datatypes", handler.Uri.AbsoluteUri);
            }
        }

        [Fact]
        public void CanSerializeAndDeserializePrimitiveTypes()
        {
            // first regen the spec
            SwaggerSpecHelper.RunTests<CSharpCodeGenerator>(
                SwaggerPath("swagger-mirror-primitives.json"), ExpectedPath("Mirror.Primitives"));

            //Now run mocked tests using the client
            var product = MirrorTestHelpers.GenerateProduct();
            using (var client = MirrorTestHelpers.CreateDataClient())
            {
                var response = client.PutProduct("200", product);
                MirrorTestHelpers.ValidateProduct(product, response);
            }
        }

        [Fact]
        public void CanRoundTripSequences()
        {
            SwaggerSpecHelper.RunTests<CSharpCodeGenerator>(
                SwaggerPath("swagger-mirror-sequences.json"), ExpectedPath("Mirror.Sequences"));
            using (var sequenceClient = MirrorTestHelpers.CreateSequenceClient())
            {
                var testList = new List<int?> {1, 1, 2, 3, 5, 8, 13, 21};
                var intList = sequenceClient.AddPetStyles(testList);
                MirrorTestHelpers.ValidateList(testList, intList, (s, t) => Assert.Equal(s, t));

                var petList = new List<Pet>
                {
                    new Pet
                    {
                        Id = 1,
                        Name = "fluffy",
                        Tag = "rabbit",
                        Styles = new List<PetStyle> {new PetStyle {Name = "cute"}, new PetStyle {Name = "cuddly"}}
                    },
                    new Pet
                    {
                        Id = 2,
                        Name = "rex",
                        Tag = "dog",
                        Styles = new List<PetStyle> {new PetStyle {Name = "friendly"}, new PetStyle {Name = "loyal"}}
                    },
                    new Pet
                    {
                        Id = 10111,
                        Name = "Tabby",
                        Tag = "cat",
                        Styles = new List<PetStyle> {new PetStyle {Name = "independent"}}
                    }
                };

                var actualPets = sequenceClient.AddPet(petList);
                MirrorTestHelpers.ValidateList(petList, actualPets, MirrorTestHelpers.ValidatePet);
            }
        }

        [Fact]
        public void CanRoundtripPolymorphicTypes()
        {
            //SwaggerSpecHelper.RunTests<CSharpCodeGenerator>(SwaggerPath("Mirror\swagger-mirror-polymorphic.json",ExpectedPath("Mirror.Polymorphic.cs");
            var pets = new[]
            {
                new Animal {Description = "Pet Only", Id = "1"},
                new BaseCat {Description = "Base Cat", Id = "2", Color = "blue"},
                new Doggy {Description = "Doggy", Id = "3", Name = "Rex"},
                new Horsey {Description = "Horsey", Id = "4", Breed = "Paint"},
                new HimalayanCat {Description = "Himalayn", Id = "1", Color = "blue", HairLength = 17, Length = 22},
                new BurmeseCat {Description = "Himalayn", Id = "1", Color = "blue", Length = 22, NickName = 76},
                new SiameseCat {Description = "Himalayn", Id = "1", Color = "blue", Length = 22}
            };
            foreach (var pet in pets)
            {
                SendAndComparePolymorphicObjects(pet);
            }
        }

        [Fact]
        public void CanRoundtripFilledOutNestedTypesWithoutRecursion()
        {
            using (var client = new RecursiveTypesAPI(new Uri("http://localhost:3000"), new MirroringHandler()))
            {

                var grandParentProduct = new Fixtures.MirrorRecursiveTypes.Models.Product
                {
                    ProductId = "0"
                };

                var parentProduct = new Fixtures.MirrorRecursiveTypes.Models.Product
                {
                    ProductId = "1"
                };

                var childProduct1 = new Fixtures.MirrorRecursiveTypes.Models.Product
                {
                    ProductId = "11",
                };

                var childProduct2 = new Fixtures.MirrorRecursiveTypes.Models.Product
                {
                    ProductId = "12",
                };

                parentProduct.ParentProduct = grandParentProduct;
                parentProduct.InnerProducts = new List<Fixtures.MirrorRecursiveTypes.Models.Product>();
                parentProduct.InnerProducts.Add(childProduct1);
                parentProduct.InnerProducts.Add(childProduct2);

                var product = client.Post("123", "rg1", "1.0", parentProduct);
                Assert.Equal(parentProduct.ParentProduct.ProductId, product.ParentProduct.ProductId);
                Assert.Equal(parentProduct.ProductId, product.ProductId);
                Assert.Equal(parentProduct.InnerProducts.Count, product.InnerProducts.Count);
                Assert.Equal(parentProduct.InnerProducts[0].ProductId, product.InnerProducts[0].ProductId);
                Assert.Equal(parentProduct.InnerProducts[1].ProductId, product.InnerProducts[1].ProductId);
            }
        }

        [Fact]
        public void CanRoundtripFilledOutNestedTypesWithoutRecursion2()
        {
            using (var client = new RecursiveTypesAPI(new Uri("http://localhost:3000"), new MirroringHandler()))
            {

                var parentProduct = new Fixtures.MirrorRecursiveTypes.Models.Product
                {
                    ProductId = "1"
                };

                var childProduct1 = new Fixtures.MirrorRecursiveTypes.Models.Product
                {
                    ProductId = "11",
                    ParentProduct = parentProduct
                };

                var product = client.Post("123", "rg1", "1.0", childProduct1);
                Assert.Equal(childProduct1.ProductId, product.ProductId);
                Assert.Equal(childProduct1.ParentProduct.ProductId, product.ParentProduct.ProductId);
            }
        }

        public static void SendAndComparePolymorphicObjects(Animal expected)
        {
             if (expected == null)
            {
                throw new ArgumentNullException("expected");
            }

           using (var client = new PolymorphicAnimalStore(new Uri("http://localhost:3000"), new MirroringHandler()))
            {
                var createdPet = client.CreateOrUpdatePolymorphicAnimals(expected);
                Assert.NotNull(expected);
                Assert.Equal(expected.GetType(), createdPet.GetType());
                foreach (var property in expected.GetType().GetProperties())
                {
                    var expectedValue = property.GetValue(expected, null);
                    var actualValue = property.GetValue(createdPet, null);
                    Assert.Equal(expectedValue, actualValue);
                }
            }
        }
    }

    public class PolymorphicJsonSerializer<T> : JsonConverter
    {
        private readonly string _discriminatorField = "$type";

        public PolymorphicJsonSerializer(string discriminatorField)
        {
            _discriminatorField = discriminatorField;
        }

        public override bool CanConvert(Type objectType)
        {
            return typeof (T).IsAssignableFrom(objectType);
        }

        public override object ReadJson(JsonReader reader,
            Type objectType, object existingValue, JsonSerializer serializer)
        {
            throw new NotSupportedException();
        }

        public override void WriteJson(JsonWriter writer,
            object value, JsonSerializer serializer)
        {
            if (value == null)
            {
                throw new ArgumentNullException("value");
            }

            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }

            if (serializer == null)
            {
                throw new ArgumentNullException("serializer");
            }

            string typeName = value.GetType().Name;
            if (value.GetType().GetCustomAttributes<JsonObjectAttribute>().Any())
            {
                typeName = value.GetType().GetCustomAttribute<JsonObjectAttribute>().Id;
            }

            writer.WriteStartObject();
            writer.WritePropertyName(_discriminatorField);
            writer.WriteValue(typeName);

            PropertyInfo[] properties = value.GetType().GetProperties();
            foreach (var property in properties.Where(p => p.SetMethod != null))
            {
                string propertyName = property.Name;
                if (property.GetCustomAttributes<JsonPropertyAttribute>().Any())
                {
                    propertyName = property.GetCustomAttribute<JsonPropertyAttribute>().PropertyName;
                }
                writer.WritePropertyName(propertyName);
                serializer.Serialize(writer, property.GetValue(value, null));
            }
            writer.WriteEndObject();
        }
    }

    public class PolymorphicJsonDeserializer<T> : JsonConverter
    {
        private readonly string _discriminatorField = "$type";

        public PolymorphicJsonDeserializer(string discriminatorField)
        {
            _discriminatorField = discriminatorField;
        }

        public override bool CanConvert(Type objectType)
        {
            return typeof (T) == objectType;
        }

        public override object ReadJson(JsonReader reader,
            Type objectType, object existingValue, JsonSerializer serializer)
        {
            JObject item = JObject.Load(reader);
            string typeDiscriminator = (string) item[_discriminatorField];
            foreach (Type type in typeof (T).Assembly.GetTypes()
                .Where(t => t.Namespace == typeof (T).Namespace && t != typeof (T)))
            {
                string typeName = type.Name;
                if (type.GetCustomAttributes<JsonObjectAttribute>().Any())
                {
                    typeName = type.GetCustomAttribute<JsonObjectAttribute>().Id;
                }
                if (typeName.Equals(typeDiscriminator, StringComparison.OrdinalIgnoreCase))
                {
                    return item.ToObject(type, serializer);
                }
            }
            return item.ToObject(objectType);
        }

        public override void WriteJson(JsonWriter writer,
            object value, JsonSerializer serializer)
        {
            throw new NotSupportedException();
        }
    }
}
