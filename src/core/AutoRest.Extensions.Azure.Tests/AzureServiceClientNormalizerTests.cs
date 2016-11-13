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
        [Fact]
        public void ResourceIsFlattenedForSimpleResource()
        {
            using (NewContext)
            {
                var codeModel = New<CodeModel>();
                codeModel.BaseUrl = "https://petstore.swagger.wordnik.com";
                codeModel.ApiVersion = "1.0.0";
                codeModel.Documentation =
                    "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
                codeModel.Name = "Swagger Petstore";

                var getPet = New<Method>();
                var resource = New<CompositeType>("resource");
                var dogProperties = New<CompositeType>("dogProperties");
                var dog = New<CompositeType>("dog");
                codeModel.Add(getPet);


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

                codeModel.Add(resource);
                codeModel.Add(dogProperties);
                codeModel.Add(dog);

                new Settings();
                var transformer = new SampleAzureTransformer();
                codeModel = transformer.TransformCodeModel(codeModel);

                Assert.Equal(3, codeModel.ModelTypes.Count);
                Assert.Equal("Dog", codeModel.ModelTypes.First(m => m.Name == "Dog").Name);
                Assert.Equal(1, codeModel.ModelTypes.First(m => m.Name == "Dog").Properties.Count);
                Assert.True(codeModel.ModelTypes.First(m => m.Name == "Resource")
                    .Properties.Any(p => p.Name == "Id"));
                Assert.True(
                    codeModel.ModelTypes.First(m => m.Name == "Resource").Properties.Any(p => p.Name == "Name"));
                Assert.Equal("Pedigree", codeModel.ModelTypes.First(m => m.Name == "Dog").Properties[0].Name);
                Assert.Equal("Dog", codeModel.Methods[0].ReturnType.Body.Name);
                Assert.Equal(codeModel.ModelTypes.First(m => m.Name == "Dog"),
                    codeModel.Methods[0].ReturnType.Body);
            }
        }

        [Fact]
        public void ResourceIsFlattenedForConflictingResource()
        {
            using (NewContext)
            {
                var codeModel = New<CodeModel>();
                codeModel.BaseUrl = "https://petstore.swagger.wordnik.com";
                codeModel.ApiVersion = "1.0.0";
                codeModel.Documentation =
                    "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
                codeModel.Name = "Swagger Petstore";

                var getPet = New<Method>();
                var resource = New<CompositeType>("resource");
                var dogProperties = New<CompositeType>("dogProperties");
                var dog = New<CompositeType>("dog");
                codeModel.Add(getPet);

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

                codeModel.Add(resource);
                codeModel.Add(dogProperties);
                codeModel.Add(dog);
                new Settings();
                var transformer = new SampleAzureTransformer();
                codeModel = transformer.TransformCodeModel(codeModel);

                Assert.Equal(3, codeModel.ModelTypes.Count);
                Assert.Equal("Dog", codeModel.ModelTypes.First(m => m.Name == "Dog").Name);
                Assert.Equal(3, codeModel.ModelTypes.First(m => m.Name == "Dog").Properties.Count);
                Assert.True(
                    codeModel.ModelTypes.First(m => m.Name == "Dog").Properties.Any(p => p.Name.FixedValue == "Dog_Name"));
                Assert.True(codeModel.ModelTypes.First(m => m.Name == "Dog").Properties.Any(p => p.Name.FixedValue == "Dog_Id"));
                Assert.True(
                    codeModel.ModelTypes.First(m => m.Name == "Dog").Properties.Any(p => p.Name.FixedValue == "pedigree"));
                Assert.Equal("Dog", codeModel.Methods[0].ReturnType.Body.Name);
                Assert.Equal(codeModel.ModelTypes.First(m => m.Name == "Dog"),
                    codeModel.Methods[0].ReturnType.Body);
            }
        }

        [Fact]
        public void ExternalResourceTypeIsNullSafe()
        {
            using (NewContext)
            {
                var codeModel = New<CodeModel>();
                codeModel.BaseUrl = "https://petstore.swagger.wordnik.com";
                codeModel.ApiVersion = "1.0.0";
                codeModel.Documentation =
                    "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
                codeModel.Name = "Swagger Petstore";

                var resource = New<CompositeType>("resource");
                var resourceProperties = New<CompositeType>("resourceProperties");
                codeModel.Add(resource);
                codeModel.Add(resourceProperties);


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
                var transformer = new SampleAzureTransformer();
                transformer.TransformCodeModel(codeModel);

                Assert.Equal(3, codeModel.ModelTypes.Count);
            }
        }

        [Fact]
        public void ResourceIsFlattenedForComplexResource()
        {
            using (NewContext)
            {
                var codeModel = New<CodeModel>();
                codeModel.BaseUrl = "https://petstore.swagger.wordnik.com";
                codeModel.ApiVersion = "1.0.0";
                codeModel.Documentation =
                    "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
                codeModel.Name = "Swagger Petstore";

                var getPet = New<Method>();
                var resource = New<CompositeType>("resource");
                var resourceProperties = New<CompositeType>("resourceProperties");
                var dogProperties = New<CompositeType>("dogProperties");
                var dog = New<CompositeType>("dog");
                codeModel.Add(getPet);

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

                codeModel.Add(resource);
                codeModel.Add(dogProperties);
                codeModel.Add(resourceProperties);
                codeModel.Add(dog);

                new Settings();
                var transformer = new SampleAzureTransformer();
                codeModel = transformer.TransformCodeModel(codeModel);

                Assert.Equal(4, codeModel.ModelTypes.Count);
                Assert.Equal("Dog", codeModel.ModelTypes.First(m => m.Name == "Dog").Name);
                Assert.Equal(4, codeModel.ModelTypes.First(m => m.Name == "Dog").Properties.Count);
                Assert.Equal("Dog_Id", codeModel.ModelTypes.First(m => m.Name == "Dog").Properties[1].Name.FixedValue);
                Assert.Equal("Dog_Name", codeModel.ModelTypes.First(m => m.Name == "Dog").Properties[2].Name.FixedValue);
                Assert.Equal("parent", codeModel.ModelTypes.First(m => m.Name == "Dog").Properties[0].Name.FixedValue);
                Assert.Equal("pedigree", codeModel.ModelTypes.First(m => m.Name == "Dog").Properties[3].Name.FixedValue);
            }
        }

        [Fact]
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
                var codeModel = modeler.Build();
                var transformer = new SampleAzureTransformer();
                codeModel = transformer.TransformCodeModel(codeModel);

                Assert.NotNull(codeModel);
                Assert.Equal(5, codeModel.Methods[0].Parameters.Count);
                Assert.Equal("$filter", codeModel.Methods[0].Parameters[2].Name.FixedValue);
                Assert.Equal("Product", codeModel.Methods[0].Parameters[2].ModelType.Name);
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
                var codeModel = modeler.Build();
                var transformer = new SampleAzureTransformer();
                codeModel = transformer.TransformCodeModel(codeModel);
                Assert.NotNull(codeModel);
                var resource = codeModel.ModelTypes.First(m =>
                        m.Name.EqualsIgnoreCase("Resource"));
                Assert.True(resource.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension));
                Assert.False((bool) resource.Extensions[AzureExtensions.AzureResourceExtension]);
                var flattenedProduct = codeModel.ModelTypes.First(m =>
                        m.Name.EqualsIgnoreCase("FlattenedProduct"));
                Assert.True(flattenedProduct.BaseModelType.Equals(resource));
            }
        }

        [Fact]
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
                var codeModel = modeler.Build();
                var transformer = new SampleAzureTransformer();
                codeModel = transformer.TransformCodeModel(codeModel);


                Assert.NotNull(codeModel);
                Assert.Equal(3, codeModel.Methods.Count);
                Assert.Equal(5, codeModel.Methods[0].Parameters.Count);
                Assert.Equal("List", codeModel.Methods[0].Name);
                Assert.Equal(4, codeModel.Methods[1].Parameters.Count);
                Assert.Equal("Reset", codeModel.Methods[1].Name);
                Assert.Equal("subscriptionId", codeModel.Methods[0].Parameters[0].Name);
                Assert.Equal("resourceGroupName", codeModel.Methods[0].Parameters[1].Name);
                Assert.Equal("$filter", codeModel.Methods[0].Parameters[2].Name.FixedValue);
                Assert.Equal("accept-language", codeModel.Methods[0].Parameters[4].Name.FixedValue);
                Assert.Equal("resourceGroupName", codeModel.Methods[1].Parameters[1].Name);
                Assert.Equal("apiVersion", codeModel.Methods[1].Parameters[2].Name);
            }
        }

        [Fact]
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
                var codeModel = modeler.Build();
                var transformer = new SampleAzureTransformer();
                codeModel = transformer.TransformCodeModel(codeModel);

                Assert.NotNull(codeModel);
                Assert.Equal(3, codeModel.Methods.Count);
                Assert.Equal("List", codeModel.Methods[0].Name);
                Assert.Equal("ListNext", codeModel.Methods[2].Name);
                Assert.Equal(2, codeModel.Methods[2].Parameters.Count);
                Assert.Equal("{nextLink}", codeModel.Methods[2].Url);
                Assert.Equal("nextPageLink", codeModel.Methods[2].Parameters[0].Name);
                Assert.Equal("acceptLanguage", codeModel.Methods[2].Parameters[1].Name);
                Assert.Equal(true, codeModel.Methods[2].IsAbsoluteUrl);
                Assert.Equal(false, codeModel.Methods[1].IsAbsoluteUrl);
            }
        }

        [Fact]
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
                var codeModel = modeler.Build();
                var transformer = new SampleAzureTransformer();
                codeModel = transformer.TransformCodeModel(codeModel);
                Assert.NotNull(codeModel);
                Assert.True(codeModel.ModelTypes.Any(t => t.Name == "Product"));
                // ProductProperties type is not removed because it is referenced in response of one of the methods
                Assert.True(codeModel.ModelTypes.Any(t => t.Name == "ProductProperties"));
                Assert.Equal(codeModel.ModelTypes.First(t => t.Name == "ProductProperties").Properties.Count,
                    codeModel.ModelTypes.First(t => t.Name == "Product").Properties.Count);
                Assert.Equal("product_id",
                    codeModel.ModelTypes.First(t => t.Name == "ProductProperties").Properties[0].SerializedName);
                Assert.Equal("properties.product_id",
                    codeModel.ModelTypes.First(t => t.Name == "Product").Properties[0].SerializedName);
            }
        }
    }
}