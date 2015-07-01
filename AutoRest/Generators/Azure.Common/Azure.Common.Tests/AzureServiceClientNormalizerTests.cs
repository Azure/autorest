// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Modeler.Swagger;
using Microsoft.Rest.Modeler.Swagger.Azure.Tests;
using System.Linq;
using Xunit;

namespace Microsoft.Rest.Generator.Azure.Common.Tests
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
            serviceClient.ModelTypes.Add(resource);
            serviceClient.ModelTypes.Add(dogProperties);
            serviceClient.ModelTypes.Add(dog);

            resource.Name = "resource";
            resource.Extensions[AzureCodeGenerator.ExternalExtension] = null;
            resource.Properties.Add(new Property
            {
                Name = "id",
                Type = PrimaryType.String,
                IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                 Name = "location",
                 Type = PrimaryType.String,
                 IsRequired = true
            });
            resource.Properties.Add(new Property
            {
               Name = "name",
               Type = PrimaryType.String,
               IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                Name = "tags",
                Type = new SequenceType { ElementType = PrimaryType.String },
                IsRequired = true
            }); 
            resource.Properties.Add(new Property
            {
                 Name = "type",
                 Type = PrimaryType.String,
                 IsRequired = true
            });
            dogProperties.Name = "dogProperties";
            dogProperties.Properties.Add(new Property
            {
                Name = "id",
                Type = PrimaryType.Long,
                IsRequired = true
            });
            dogProperties.Properties.Add(new Property
            {
                Name = "name",
                Type = PrimaryType.String,
                IsRequired = true
            });
            dog.Name = "dog";
            dog.BaseModelType = resource;
            dog.Properties.Add(new Property
            {
                Name = "properties",
                Type = dogProperties,
                IsRequired = true
            });
            dog.Properties.Add(new Property
            {
                Name = "pedigree",
                Type = PrimaryType.Boolean,
                IsRequired = true
            });
            getPet.ReturnType = dog;

            var codeGen = new SampleAzureCodeGenerator(new Settings());
            codeGen.NormalizeClientModel(serviceClient);
            Assert.Equal(3, serviceClient.ModelTypes.Count);
            Assert.Equal("dog", serviceClient.ModelTypes[1].Name);
            Assert.Equal(3, serviceClient.ModelTypes[1].Properties.Count);
            Assert.Equal("id", serviceClient.ModelTypes[1].Properties[1].Name);
            Assert.Equal("name", serviceClient.ModelTypes[1].Properties[2].Name);
            Assert.Equal("pedigree", serviceClient.ModelTypes[1].Properties[0].Name);
            Assert.Equal("dog", serviceClient.Methods[0].ReturnType.Name);
            Assert.Equal(serviceClient.ModelTypes[1], serviceClient.Methods[0].ReturnType);
        }

        [Fact]
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
            serviceClient.ModelTypes.Add(resource);
            serviceClient.ModelTypes.Add(dogProperties);
            serviceClient.ModelTypes.Add(resourceProperties);
            serviceClient.ModelTypes.Add(dog);

            resource.Name = "resource";
            resource.Properties.Add(new Property
            {
               Name = "id",
               Type = PrimaryType.String,
               IsRequired = true
            });
            resource.Properties.Add(new Property
            {
                 Name = "location",
                 Type = PrimaryType.String,
                 IsRequired = true
            });
            resource.Properties.Add(new Property
            {
               Name = "name",
               Type = PrimaryType.String,
               IsRequired = true
            }); 
            resource.Properties.Add(new Property
            {
                Name = "tags",
                Type = new SequenceType { ElementType = PrimaryType.String },
                IsRequired = true
            }); 
            resource.Properties.Add(new Property
            {
                 Name = "type",
                 Type = PrimaryType.String,
                 IsRequired = true
            });
            resource.Extensions[AzureCodeGenerator.ExternalExtension] = null;
            resourceProperties.Name = "resourceProperties";
            resourceProperties.Properties.Add(new Property
            {
                Name = "parent",
                Type = PrimaryType.Long,
                IsRequired = true
            });
            dogProperties.Name = "dogProperties";
            dogProperties.BaseModelType = resourceProperties;
            dogProperties.Properties.Add(new Property
            {
                Name = "id",
                Type = PrimaryType.Long,
                IsRequired = true
            });
            dogProperties.Properties.Add(new Property
            {
                Name = "name",
                Type = PrimaryType.String,
                IsRequired = true
            });
            dog.Name = "dog";
            dog.BaseModelType = resource;
            dog.Properties.Add(new Property
            {
                Name = "properties",
                Type = dogProperties,
                IsRequired = true
            });
            dog.Properties.Add(new Property
            {
                Name = "pedigree",
                Type = PrimaryType.Boolean,
                IsRequired = true
            });
            getPet.ReturnType = dog;

            var codeGen = new SampleAzureCodeGenerator(new Settings());
            codeGen.NormalizeClientModel(serviceClient);
            Assert.Equal(3, serviceClient.ModelTypes.Count);
            Assert.Equal("dog", serviceClient.ModelTypes[1].Name);
            Assert.Equal(4, serviceClient.ModelTypes[1].Properties.Count);
            Assert.Equal("id", serviceClient.ModelTypes[1].Properties[1].Name);
            Assert.Equal("name", serviceClient.ModelTypes[1].Properties[2].Name);
            Assert.Equal("pedigree", serviceClient.ModelTypes[1].Properties[0].Name);
            Assert.Equal("parent", serviceClient.ModelTypes[1].Properties[3].Name);
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
            Assert.Equal(2, serviceClient.Methods[0].Parameters.Count);
            Assert.Equal("$filter", serviceClient.Methods[0].Parameters[1].Name);
            Assert.Equal("Product", serviceClient.Methods[0].Parameters[1].Type.Name);
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
            Assert.True(resource.Extensions.ContainsKey(AzureCodeGenerator.ExternalExtension));
            Assert.False((bool)resource.Extensions[AzureCodeGenerator.ExternalExtension]);
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
            Assert.Equal(2, serviceClient.Methods[0].Parameters.Count);
            Assert.Equal("list", serviceClient.Methods[0].Name);
            Assert.Equal(2, serviceClient.Methods[1].Parameters.Count);
            Assert.Equal("reset", serviceClient.Methods[1].Name);
            Assert.Equal("resourceGroupName", serviceClient.Methods[0].Parameters[0].Name);
            Assert.Equal("$filter", serviceClient.Methods[0].Parameters[1].Name);
            Assert.Equal("resourceGroupName", serviceClient.Methods[1].Parameters[0].Name);
            Assert.Equal("apiVersion", serviceClient.Methods[1].Parameters[1].Name);
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
            Assert.Equal(1, serviceClient.Methods[2].Parameters.Count);
            Assert.Equal("{nextLink}", serviceClient.Methods[2].Url);
            Assert.Equal("nextLink", serviceClient.Methods[2].Parameters[0].Name);
            Assert.Equal(true, serviceClient.Methods[2].IsAbsoluteUrl);
            Assert.Equal(false, serviceClient.Methods[1].IsAbsoluteUrl);
        }
    }
}