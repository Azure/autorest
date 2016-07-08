// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Reflection;
using AutoRest.CSharp.Tests.Utilities;
using Fixtures.MirrorPolymorphic;
using Fixtures.MirrorPolymorphic.Models;
using Fixtures.MirrorPrimitives;
using Fixtures.MirrorRecursiveTypes;
using Fixtures.MirrorSequences;
using Fixtures.MirrorSequences.Models;
using AutoRest.CSharp.Tests;
using Xunit;

namespace AutoRest.CSharp.Tests
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
            SwaggerSpecRunner.RunTests(
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
            SwaggerSpecRunner.RunTests(
                SwaggerPath("swagger-mirror-sequences.json"), ExpectedPath("Mirror.Sequences"));
            using (var sequenceClient = MirrorTestHelpers.CreateSequenceClient())
            {
                var testList = new List<int?> {1, 1, 2, 3, 5, 8, 13, 21};
                var intList = sequenceClient.AddPetStyles(testList);
                MirrorTestHelpers.ValidateList<int?>(testList, intList, (s, t) => Assert.Equal<int?>(s, t));

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
            SwaggerSpecRunner.RunTests(
                SwaggerPath("swagger-mirror-polymorphic.json"),
                ExpectedPath("Mirror.Polymorphic"));
            
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
}
