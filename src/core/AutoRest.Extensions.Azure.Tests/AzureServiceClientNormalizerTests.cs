// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Extensions.Azure.Tests
{
    [Collection("AutoRest Tests")]
    public class AzureServiceClientNormalizerTests
    {
        [Fact(Skip = "gws - disabled, because normaliztion not done anymore")]
        public void ResourceIsFlattenedForSimpleResource()
        {
            using (NewContext)
            {
                var serviceClient = New<CodeModel>();
                serviceClient.BaseUrl = "https://petstore.swagger.wordnik.com";
                serviceClient.ApiVersion = "1.0.0";
                serviceClient.Documentation =
                    "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
                serviceClient.Name = "Swagger Petstore";

                var getPet = New<Method>();
                var resource = New<CompositeType>("resource");
                var dogProperties = New<CompositeType>("dogProperties");
                var dog = New<CompositeType>("dog");
                serviceClient.Add(getPet);


                resource.Add(New<Property>(new
                {
                    Name = "id",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "location",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "name",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "tags",
                    ModelType = New<SequenceType>(new {ElementType = New<PrimaryType>(KnownPrimaryType.String)}),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "type",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                dog.BaseModelType = resource;
                var dogPropertiesProperty = New<Property>(new
                {
                    Name = "properties",
                    ModelType = dogProperties,
                    IsRequired = true
                });
                dogPropertiesProperty.Extensions[SwaggerExtensions.FlattenExtension] = true;
                dog.Add(dogPropertiesProperty);
                dog.Add(New<Property>(new
                {
                    Name = "pedigree",
                    ModelType = New<PrimaryType>(KnownPrimaryType.Boolean),
                    IsRequired = true
                }));
                getPet.ReturnType = new Response(dog, null);

                serviceClient.Add(resource);
                serviceClient.Add(dogProperties);
                serviceClient.Add(dog);

                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif
                Assert.Equal(3, serviceClient.ModelTypes.Count);
                Assert.Equal("dog", serviceClient.ModelTypes.First(m => m.Name == "dog").Name);
                Assert.Equal(1, serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Count);
                Assert.True(serviceClient.ModelTypes.First(m => m.Name == "resource")
                    .Properties.Any(p => p.Name == "id"));
                Assert.True(
                    serviceClient.ModelTypes.First(m => m.Name == "resource").Properties.Any(p => p.Name == "name"));
                Assert.Equal("pedigree", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[0].Name);
                Assert.Equal("dog", serviceClient.Methods[0].ReturnType.Body.Name);
                Assert.Equal(serviceClient.ModelTypes.First(m => m.Name == "dog"),
                    serviceClient.Methods[0].ReturnType.Body);
            }
        }

        [Fact(Skip = "gws - disabled, because normaliztion not done anymore")]
        public void ResourceIsFlattenedForConflictingResource()
        {
            using (NewContext)
            {
                var serviceClient = New<CodeModel>();
                serviceClient.BaseUrl = "https://petstore.swagger.wordnik.com";
                serviceClient.ApiVersion = "1.0.0";
                serviceClient.Documentation =
                    "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
                serviceClient.Name = "Swagger Petstore";

                var getPet = New<Method>();
                var resource = New<CompositeType>("resource");
                var dogProperties = New<CompositeType>("dogProperties");
                var dog = New<CompositeType>("dog");
                serviceClient.Add(getPet);

                resource.Add(New<Property>(new
                {
                    Name = "id",
                    SerializedName = "id",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "location",
                    SerializedName = "location",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "name",
                    SerializedName = "name",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "tags",
                    SerializedName = "tags",
                    ModelType = New<SequenceType>(new {ElementType = New<PrimaryType>(KnownPrimaryType.String)}),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "type",
                    SerializedName = "type",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));

                dogProperties.SerializedName = "dogProperties";
                dogProperties.Add(New<Property>(new
                {
                    Name = "id",
                    SerializedName = "id",
                    ModelType = New<PrimaryType>(KnownPrimaryType.Long),
                    IsRequired = true
                }));
                dogProperties.Add(New<Property>(new
                {
                    Name = "name",
                    SerializedName = "name",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                dog.SerializedName = "dog";
                dog.BaseModelType = resource;
                var dogPropertiesProperty = New<Property>(new
                {
                    Name = "properties",
                    SerializedName = "properties",
                    ModelType = dogProperties,
                    IsRequired = true
                });
                dogPropertiesProperty.Extensions[SwaggerExtensions.FlattenExtension] = true;
                dog.Add(dogPropertiesProperty);
                dog.Add(New<Property>(new
                {
                    Name = "pedigree",
                    SerializedName = "pedigree",
                    ModelType = New<PrimaryType>(KnownPrimaryType.Boolean),
                    IsRequired = true
                }));
                getPet.ReturnType = new Response(dog, null);

                serviceClient.Add(resource);
                serviceClient.Add(dogProperties);
                serviceClient.Add(dog);
                new Settings();
                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif
                Assert.Equal(3, serviceClient.ModelTypes.Count);
                Assert.Equal("dog", serviceClient.ModelTypes.First(m => m.Name == "dog").Name);
                Assert.Equal(3, serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Count);
                Assert.True(
                    serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Any(p => p.Name == "dog_name"));
                Assert.True(serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Any(p => p.Name == "dog_id"));
                Assert.True(
                    serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Any(p => p.Name == "pedigree"));
                Assert.Equal("dog", serviceClient.Methods[0].ReturnType.Body.Name);
                Assert.Equal(serviceClient.ModelTypes.First(m => m.Name == "dog"),
                    serviceClient.Methods[0].ReturnType.Body);
            }
        }

        [Fact]
        public void ExternalResourceTypeIsNullSafe()
        {
            using (NewContext)
            {
                var serviceClient = New<CodeModel>();
                serviceClient.BaseUrl = "https://petstore.swagger.wordnik.com";
                serviceClient.ApiVersion = "1.0.0";
                serviceClient.Documentation =
                    "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
                serviceClient.Name = "Swagger Petstore";

                var resource = New<CompositeType>("resource");
                var resourceProperties = New<CompositeType>("resourceProperties");
                serviceClient.Add(resource);
                serviceClient.Add(resourceProperties);


                resource.Add(New<Property>(new
                {
                    Name = "id",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "location",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "name",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "tags",
                    ModelType = New<SequenceType>(new {ElementType = New<PrimaryType>(KnownPrimaryType.String)}),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "type",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Extensions[AzureExtensions.AzureResourceExtension] = null;

                resourceProperties.Add(New<Property>(new
                {
                    Name = "parent",
                    ModelType = New<PrimaryType>(KnownPrimaryType.Long),
                    IsRequired = true
                }));
                new Settings();
                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif
                Assert.Equal(2, serviceClient.ModelTypes.Count);
            }
        }

        [Fact(Skip = "TODO: Implement scenario with property that inherits from another type and is flattened.")]
        public void ResourceIsFlattenedForComplexResource()
        {
            using (NewContext)
            {
                var serviceClient = New<CodeModel>();
                serviceClient.BaseUrl = "https://petstore.swagger.wordnik.com";
                serviceClient.ApiVersion = "1.0.0";
                serviceClient.Documentation =
                    "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
                serviceClient.Name = "Swagger Petstore";

                var getPet = New<Method>();
                var resource = New<CompositeType>("resource");
                var resourceProperties = New<CompositeType>("resourceProperties");
                var dogProperties = New<CompositeType>("dogProperties");
                var dog = New<CompositeType>("dog");
                serviceClient.Add(getPet);

                resource.SerializedName = "resource";
                resource.Add(New<Property>(new
                {
                    Name = "id",
                    SerializedName = "id",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "location",
                    SerializedName = "location",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "name",
                    SerializedName = "name",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "tags",
                    SerializedName = "tags",
                    ModelType = New<SequenceType>(new {ElementType = New<PrimaryType>(KnownPrimaryType.String)}),
                    IsRequired = true
                }));
                resource.Add(New<Property>(new
                {
                    Name = "type",
                    SerializedName = "type",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));

                resourceProperties.SerializedName = "resourceProperties";
                resourceProperties.Add(New<Property>(new
                {
                    Name = "parent",
                    SerializedName = "parent",
                    ModelType = New<PrimaryType>(KnownPrimaryType.Long),
                    IsRequired = true
                }));

                dogProperties.SerializedName = "dogProperties";
                dogProperties.BaseModelType = resourceProperties;
                dogProperties.Add(New<Property>(new
                {
                    Name = "id",
                    SerializedName = "id",
                    ModelType = New<PrimaryType>(KnownPrimaryType.Long),
                    IsRequired = true
                }));
                dogProperties.Add(New<Property>(new
                {
                    Name = "name",
                    SerializedName = "name",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String),
                    IsRequired = true
                }));

                dog.SerializedName = "dog";
                dog.BaseModelType = resource;
                var dogPropertiesProperty = New<Property>(new
                {
                    Name = "properties",
                    SerializedName = "properties",
                    ModelType = dogProperties,
                    IsRequired = true
                });
                dogPropertiesProperty.Extensions[SwaggerExtensions.FlattenExtension] = true;
                dog.Add(dogPropertiesProperty);
                dog.Add(New<Property>(new
                {
                    Name = "pedigree",
                    SerializedName = "pedigree",
                    ModelType = New<PrimaryType>(KnownPrimaryType.Boolean),
                    IsRequired = true
                }));
                getPet.ReturnType = new Response(dog, null);

                serviceClient.Add(resource);
                serviceClient.Add(dogProperties);
                serviceClient.Add(resourceProperties);
                serviceClient.Add(dog);

                new Settings();
                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif
                Assert.Equal(3, serviceClient.ModelTypes.Count);
                Assert.Equal("dog", serviceClient.ModelTypes.First(m => m.Name == "dog").Name);
                Assert.Equal(4, serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Count);
                Assert.Equal("dog_id", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[1].Name);
                Assert.Equal("dog_name", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[2].Name);
                Assert.Equal("pedigree", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[0].Name);
                Assert.Equal("parent", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[3].Name);
            }
        }

        [Fact(Skip = "gws - disabled, because normaliztion not done anymore")]
        public void SwaggerODataSpecParsingTest()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Namespace = "Test",
                    Input = @"Swagger\swagger-odata-spec.json"
                };


                var modeler = new SwaggerModeler();
                var serviceClient = modeler.Build();
                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif
                Assert.NotNull(serviceClient);
                Assert.Equal(5, serviceClient.Methods[0].Parameters.Count);
                Assert.Equal("$filter", serviceClient.Methods[0].Parameters[2].Name);
                Assert.Equal("Product", serviceClient.Methods[0].Parameters[2].ModelType.Name);
            }
        }

        [Fact]
        public void SwaggerResourceExternalFalseTest()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Namespace = "Test",
                    Input = @"Swagger\resource-external-false.json"
                };


                var modeler = new SwaggerModeler();
                var serviceClient = modeler.Build();
                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif
                Assert.NotNull(serviceClient);
                var resource = serviceClient.ModelTypes.First(m =>
                        m.Name.EqualsIgnoreCase("Resource"));
                Assert.True(resource.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension));
                Assert.False((bool) resource.Extensions[AzureExtensions.AzureResourceExtension]);
                var flattenedProduct = serviceClient.ModelTypes.First(m =>
                        m.Name.EqualsIgnoreCase("FlattenedProduct"));
                Assert.True(flattenedProduct.BaseModelType.Equals(resource));
            }
        }

        [Fact(Skip = "gws - disabled, because normaliztion not done anymore")]
        public void AzureParameterTest()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Namespace = "Test",
                    Input = @"Swagger\swagger-odata-spec.json"
                };


                var modeler = new SwaggerModeler();
                var serviceClient = modeler.Build();
                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif

                Assert.NotNull(serviceClient);
                Assert.Equal(3, serviceClient.Methods.Count);
                Assert.Equal(5, serviceClient.Methods[0].Parameters.Count);
                Assert.Equal("list", serviceClient.Methods[0].Name);
                Assert.Equal(4, serviceClient.Methods[1].Parameters.Count);
                Assert.Equal("reset", serviceClient.Methods[1].Name);
                Assert.Equal("subscriptionId", serviceClient.Methods[0].Parameters[0].Name);
                Assert.Equal("resourceGroupName", serviceClient.Methods[0].Parameters[1].Name);
                Assert.Equal("$filter", serviceClient.Methods[0].Parameters[2].Name);
                Assert.Equal("accept-language", serviceClient.Methods[0].Parameters[4].Name);
                Assert.Equal("resourceGroupName", serviceClient.Methods[1].Parameters[1].Name);
                Assert.Equal("apiVersion", serviceClient.Methods[1].Parameters[2].Name);
            }
        }

        [Fact(Skip = "gws - disabled, because normaliztion not done anymore")]
        public void PageableTest()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Namespace = "Test",
                    Input = @"Swagger\swagger-odata-spec.json"
                };


                var modeler = new SwaggerModeler();
                var serviceClient = modeler.Build();
                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif
                Assert.NotNull(serviceClient);
                Assert.Equal(3, serviceClient.Methods.Count);
                Assert.Equal("list", serviceClient.Methods[0].Name);
                Assert.Equal("listNext", serviceClient.Methods[2].Name);
                Assert.Equal(2, serviceClient.Methods[2].Parameters.Count);
                Assert.Equal("{nextLink}", serviceClient.Methods[2].Url);
                Assert.Equal("nextPageLink", serviceClient.Methods[2].Parameters[0].Name);
                Assert.Equal("accept-language", serviceClient.Methods[2].Parameters[1].Name);
                Assert.Equal(true, serviceClient.Methods[2].IsAbsoluteUrl);
                Assert.Equal(false, serviceClient.Methods[1].IsAbsoluteUrl);
            }
        }

        [Fact(Skip = "gws - disabled, because normaliztion not done anymore")]
        public void FlatteningTest()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Namespace = "Test",
                    Input = @"Swagger\swagger-resource-flattening.json"
                };


                var modeler = new SwaggerModeler();
                var serviceClient = modeler.Build();
                var codeGen = new SampleAzureCodeGenerator();
#if gws_removed
            codeGen.NormalizeClientModel(serviceClient);
#endif
                Assert.NotNull(serviceClient);
                Assert.True(serviceClient.ModelTypes.Any(t => t.Name == "Product"));
                // ProductProperties type is not removed because it is referenced in response of one of the methods
                Assert.True(serviceClient.ModelTypes.Any(t => t.Name == "ProductProperties"));
                Assert.Equal(serviceClient.ModelTypes.First(t => t.Name == "ProductProperties").Properties.Count,
                    serviceClient.ModelTypes.First(t => t.Name == "Product").Properties.Count);
                Assert.Equal("product_id",
                    serviceClient.ModelTypes.First(t => t.Name == "ProductProperties").Properties[0].SerializedName);
                Assert.Equal("properties.product_id",
                    serviceClient.ModelTypes.First(t => t.Name == "Product").Properties[0].SerializedName);
            }
        }
    }
}