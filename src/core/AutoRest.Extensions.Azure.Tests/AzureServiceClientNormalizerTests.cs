// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Swagger;
using Xunit;

namespace AutoRest.Extensions.Azure.Tests
{
    [Collection("AutoRest Tests")]
    public class AzureServiceClientNormalizerTests
    {
        [Fact]
        public void ResourceIsFlattenedForSimpleResource()
        {
            var serviceClient = new ServiceClient();
            serviceClient.BaseUrl = "https://petstore.swagger.wordnik.com";
            serviceClient.ApiVersion = "1.0.0";
            serviceClient.Documentation =
                "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
            serviceClient.Name = "Swagger Petstore";

            var getPet = new Method();
            var resource = new CompositeType();
            var dogProperties = new CompositeType();
            var dog = new CompositeType();
            serviceClient.Methods.Add(getPet);

            resource.Name = "resource";
            resource.Properties.Add(new Property
            {
                Name = "id",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "location",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "name",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "tags",
                Type = new SequenceType { ElementType = new PrimaryType(KnownPrimaryType.String) },
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "type",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            dogProperties.Name = "dogProperties";
            dog.Name = "dog";
            dog.BaseModelType = resource;
            var dogPropertiesProperty = new Property
            {
                Name = "properties",
                Type = dogProperties,
                IsRequired = true
            };
            dogPropertiesProperty.Extensions[SwaggerExtensions.FlattenExtension] = true;
            dog.Properties.Add(dogPropertiesProperty);
            dog.Properties.Add(new Property
            {
                Name = "pedigree",
                Type = new PrimaryType(KnownPrimaryType.Boolean),
                IsRequired = true
            });
            getPet.ReturnType = new Response(dog, null);

            serviceClient.ModelTypes.Add(resource);
            serviceClient.ModelTypes.Add(dogProperties);
            serviceClient.ModelTypes.Add(dog);

            var codeGen = new SampleAzureCodeGenerator(new Settings());
            codeGen.NormalizeClientModel(serviceClient);
            Assert.Equal(3, serviceClient.ModelTypes.Count);
            Assert.Equal("dog", serviceClient.ModelTypes.First(m => m.Name == "dog").Name);
            Assert.Equal(1, serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Count);
            Assert.True(serviceClient.ModelTypes.First(m => m.Name == "resource").Properties.Any(p => p.Name == "id"));
            Assert.True(serviceClient.ModelTypes.First(m => m.Name == "resource").Properties.Any(p => p.Name == "name"));
            Assert.Equal("pedigree", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[0].Name);
            Assert.Equal("dog", serviceClient.Methods[0].ReturnType.Body.Name);
            Assert.Equal(serviceClient.ModelTypes.First(m => m.Name == "dog"), serviceClient.Methods[0].ReturnType.Body);
        }

        [Fact]
        public void ResourceIsFlattenedForConflictingResource()
        {
            var serviceClient = new ServiceClient();
            serviceClient.BaseUrl = "https://petstore.swagger.wordnik.com";
            serviceClient.ApiVersion = "1.0.0";
            serviceClient.Documentation =
                "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
            serviceClient.Name = "Swagger Petstore";

            var getPet = new Method();
            var resource = new CompositeType();
            var dogProperties = new CompositeType();
            var dog = new CompositeType();
            serviceClient.Methods.Add(getPet);
            resource.Name = "resource";
            resource.Properties.Add(new Property
            {
                Name = "id",
                SerializedName = "id",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "location",
                SerializedName = "location",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "name",
                SerializedName = "name",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "tags",
                SerializedName = "tags",
                Type = new SequenceType { ElementType = new PrimaryType(KnownPrimaryType.String) },
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "type",
                SerializedName = "type",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            dogProperties.Name = "dogProperties";
            dogProperties.SerializedName = "dogProperties";
            dogProperties.Properties.Add(new Property
            {
                Name = "id",
                SerializedName = "id",
                Type = new PrimaryType(KnownPrimaryType.Long),
                IsRequired = true
            });
            dogProperties.Properties.Add(new Property
            {
                Name = "name",
                SerializedName = "name",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            dog.Name = "dog";
            dog.SerializedName = "dog";
            dog.BaseModelType = resource;
            var dogPropertiesProperty = new Property
            {
                Name = "properties",
                SerializedName = "properties",
                Type = dogProperties,
                IsRequired = true
            };
            dogPropertiesProperty.Extensions[SwaggerExtensions.FlattenExtension] = true;
            dog.Properties.Add(dogPropertiesProperty);
            dog.Properties.Add(new Property
            {
                Name = "pedigree",
                SerializedName = "pedigree",
                Type = new PrimaryType(KnownPrimaryType.Boolean),
                IsRequired = true
            });
            getPet.ReturnType = new Response(dog, null);

            serviceClient.ModelTypes.Add(resource);
            serviceClient.ModelTypes.Add(dogProperties);
            serviceClient.ModelTypes.Add(dog);

            var codeGen = new SampleAzureCodeGenerator(new Settings());
            codeGen.NormalizeClientModel(serviceClient);
            Assert.Equal(3, serviceClient.ModelTypes.Count);
            Assert.Equal("dog", serviceClient.ModelTypes.First(m => m.Name == "dog").Name);
            Assert.Equal(3, serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Count);
            Assert.True(serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Any(p => p.Name == "dog_name"));
            Assert.True(serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Any(p => p.Name == "dog_id"));
            Assert.True(serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Any(p => p.Name == "pedigree"));
            Assert.Equal("dog", serviceClient.Methods[0].ReturnType.Body.Name);
            Assert.Equal(serviceClient.ModelTypes.First(m => m.Name == "dog"), serviceClient.Methods[0].ReturnType.Body);
        }

        [Fact]
        public void ExternalResourceTypeIsNullSafe()
        {
            var serviceClient = new ServiceClient();
            serviceClient.BaseUrl = "https://petstore.swagger.wordnik.com";
            serviceClient.ApiVersion = "1.0.0";
            serviceClient.Documentation =
                "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
            serviceClient.Name = "Swagger Petstore";

            var resource = new CompositeType();
            var resourceProperties = new CompositeType();
            serviceClient.ModelTypes.Add(resource);
            serviceClient.ModelTypes.Add(resourceProperties);

            resource.Name = "resource";
            resource.Properties.Add(new Property
            {
                Name = "id",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "location",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "name",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "tags",
                Type = new SequenceType { ElementType = new PrimaryType(KnownPrimaryType.String) },
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "type",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Extensions[AzureExtensions.AzureResourceExtension] = null;
            resourceProperties.Name = "resourceProperties";
            resourceProperties.Properties.Add(new Property
            {
                Name = "parent",
                Type = new PrimaryType(KnownPrimaryType.Long),
                IsRequired = true
            });

            var codeGen = new SampleAzureCodeGenerator(new Settings());
            codeGen.NormalizeClientModel(serviceClient);
            Assert.Equal(2, serviceClient.ModelTypes.Count);
        }

        [Fact(Skip = "TODO: Implement scenario with property that inherits from another type and is flattened.")]
        public void ResourceIsFlattenedForComplexResource()
        {
            var serviceClient = new ServiceClient();
            serviceClient.BaseUrl = "https://petstore.swagger.wordnik.com";
            serviceClient.ApiVersion = "1.0.0";
            serviceClient.Documentation =
                "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification";
            serviceClient.Name = "Swagger Petstore";

            var getPet = new Method();
            var resource = new CompositeType();
            var resourceProperties = new CompositeType();
            var dogProperties = new CompositeType();
            var dog = new CompositeType();
            serviceClient.Methods.Add(getPet);
            resource.Name = "resource";
            resource.SerializedName = "resource";
            resource.Properties.Add(new Property
            {
                Name = "id",
                SerializedName = "id",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "location",
                SerializedName = "location",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "name",
                SerializedName = "name",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "tags",
                SerializedName = "tags",
                Type = new SequenceType { ElementType = new PrimaryType(KnownPrimaryType.String) },
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "type",
                SerializedName = "type",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            resourceProperties.Name = "resourceProperties";
            resourceProperties.SerializedName = "resourceProperties";
            resourceProperties.Properties.Add(new Property
            {
                Name = "parent",
                SerializedName = "parent",
                Type = new PrimaryType(KnownPrimaryType.Long),
                IsRequired = true
            });
            dogProperties.Name = "dogProperties";
            dogProperties.SerializedName = "dogProperties";
            dogProperties.BaseModelType = resourceProperties;
            dogProperties.Properties.Add(new Property
            {
                Name = "id",
                SerializedName = "id",
                Type = new PrimaryType(KnownPrimaryType.Long),
                IsRequired = true
            });
            dogProperties.Properties.Add(new Property
            {
                Name = "name",
                SerializedName = "name",
                Type = new PrimaryType(KnownPrimaryType.String),
                IsRequired = true
            });
            dog.Name = "dog";
            dog.SerializedName = "dog";
            dog.BaseModelType = resource;
            var dogPropertiesProperty = new Property
            {
                Name = "properties",
                SerializedName = "properties",
                Type = dogProperties,
                IsRequired = true
            };
            dogPropertiesProperty.Extensions[SwaggerExtensions.FlattenExtension] = true;
            dog.Properties.Add(dogPropertiesProperty);
            dog.Properties.Add(new Property
            {
                Name = "pedigree",
                SerializedName = "pedigree",
                Type = new PrimaryType(KnownPrimaryType.Boolean),
                IsRequired = true
            });
            getPet.ReturnType = new Response(dog, null);

            serviceClient.ModelTypes.Add(resource);
            serviceClient.ModelTypes.Add(dogProperties);
            serviceClient.ModelTypes.Add(resourceProperties);
            serviceClient.ModelTypes.Add(dog);

            var codeGen = new SampleAzureCodeGenerator(new Settings());
            codeGen.NormalizeClientModel(serviceClient);
            Assert.Equal(3, serviceClient.ModelTypes.Count);
            Assert.Equal("dog", serviceClient.ModelTypes.First(m => m.Name == "dog").Name);
            Assert.Equal(4, serviceClient.ModelTypes.First(m => m.Name == "dog").Properties.Count);
            Assert.Equal("dog_id", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[1].Name);
            Assert.Equal("dog_name", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[2].Name);
            Assert.Equal("pedigree", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[0].Name);
            Assert.Equal("parent", serviceClient.ModelTypes.First(m => m.Name == "dog").Properties[3].Name);
        }

        [Fact]
        public void SwaggerODataSpecParsingTest()
        {
            var settings = new Settings
            {
                Namespace = "Test",
                Input = @"Swagger\swagger-odata-spec.json"
            };


            var modeler = new SwaggerModeler(settings);
            var serviceClient = modeler.Build();
            var codeGen = new SampleAzureCodeGenerator(settings);
            codeGen.NormalizeClientModel(serviceClient);

            Assert.NotNull(serviceClient);
            Assert.Equal(5, serviceClient.Methods[0].Parameters.Count);
            Assert.Equal("$filter", serviceClient.Methods[0].Parameters[2].Name);
            Assert.Equal("Product", serviceClient.Methods[0].Parameters[2].Type.Name);
        }

        [Fact]
        public void SwaggerResourceExternalFalseTest()
        {
            var settings = new Settings
            {
                Namespace = "Test",
                Input = @"Swagger\resource-external-false.json"
            };


            var modeler = new SwaggerModeler(settings);
            var serviceClient = modeler.Build();
            var codeGen = new SampleAzureCodeGenerator(settings);
            codeGen.NormalizeClientModel(serviceClient);

            Assert.NotNull(serviceClient);
            var resource = serviceClient.ModelTypes.First(m =>
                m.Name.Equals("Resource", System.StringComparison.OrdinalIgnoreCase));
            Assert.True(resource.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension));
            Assert.False((bool)resource.Extensions[AzureExtensions.AzureResourceExtension]);
            var flattenedProduct = serviceClient.ModelTypes.First(m =>
                m.Name.Equals("FlattenedProduct", System.StringComparison.OrdinalIgnoreCase));
            Assert.True(flattenedProduct.BaseModelType.Equals(resource));
        }

        [Fact]
        public void AzureParameterTest()
        {
            var settings = new Settings
            {
                Namespace = "Test",
                Input = @"Swagger\swagger-odata-spec.json"
            };


            var modeler = new SwaggerModeler(settings);
            var serviceClient = modeler.Build();
            var codeGen = new SampleAzureCodeGenerator(settings);
            codeGen.NormalizeClientModel(serviceClient);

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

        [Fact]
        public void PageableTest()
        {
            var settings = new Settings
            {
                Namespace = "Test",
                Input = @"Swagger\swagger-odata-spec.json"
            };


            var modeler = new SwaggerModeler(settings);
            var serviceClient = modeler.Build();
            var codeGen = new SampleAzureCodeGenerator(settings);
            codeGen.NormalizeClientModel(serviceClient);

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

        [Fact]
        public void FlatteningTest()
        {
            var settings = new Settings
            {
                Namespace = "Test",
                Input = @"Swagger\swagger-resource-flattening.json"
            };


            var modeler = new SwaggerModeler(settings);
            var serviceClient = modeler.Build();
            var codeGen = new SampleAzureCodeGenerator(settings);
            codeGen.NormalizeClientModel(serviceClient);

            Assert.NotNull(serviceClient);
            Assert.True(serviceClient.ModelTypes.Any(t => t.Name == "Product"));
            // ProductProperties type is not removed because it is referenced in response of one of the methods
            Assert.True(serviceClient.ModelTypes.Any(t => t.Name == "ProductProperties"));
            Assert.Equal(serviceClient.ModelTypes.First(t => t.Name == "ProductProperties").Properties.Count,
                serviceClient.ModelTypes.First(t => t.Name == "Product").Properties.Count);
            Assert.Equal("product_id", serviceClient.ModelTypes.First(t => t.Name == "ProductProperties").Properties[0].SerializedName);
            Assert.Equal("properties.product_id", serviceClient.ModelTypes.First(t => t.Name == "Product").Properties[0].SerializedName);
        }
    }
}