// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.CSharp;
using AutoRest.Java;
using AutoRest.NodeJS;
using AutoRest.Python;
using AutoRest.Ruby;
using AutoRest.Swagger;
using Xunit;

namespace AutoRest.Extensions.Tests
{
    public class ExtensionsTests
    {
        [Fact]
        public void TestClientModelWithPayloadFlattening()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-payload-flatten.json"),
                PayloadFlatteningThreshold = 3
            };
            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);

            Assert.NotNull(clientModel);
            Assert.Equal(4, clientModel.Methods[0].Parameters.Count);
            Assert.Equal("String subscriptionId", clientModel.Methods[0].Parameters[0].ToString());
            Assert.Equal("String resourceGroupName", clientModel.Methods[0].Parameters[1].ToString());
            Assert.Equal("String apiVersion", clientModel.Methods[0].Parameters[2].ToString());
            Assert.Equal("MaxProduct max_product", clientModel.Methods[0].Parameters[3].ToString());
            Assert.Equal(6, clientModel.Methods[1].Parameters.Count);
            Assert.Equal("String subscriptionId", clientModel.Methods[1].Parameters[0].ToString());
            Assert.Equal("String resourceGroupName", clientModel.Methods[1].Parameters[1].ToString());
            Assert.Equal("String apiVersion", clientModel.Methods[1].Parameters[2].ToString());
            Assert.Equal("String base_product_id", clientModel.Methods[1].Parameters[3].ToString());
            Assert.Equal(true, clientModel.Methods[1].Parameters[3].IsRequired);
            Assert.Equal("String base_product_description", clientModel.Methods[1].Parameters[4].ToString());
            Assert.Equal(false, clientModel.Methods[1].Parameters[4].IsRequired);
            Assert.Equal("MaxProduct max_product_reference", clientModel.Methods[1].Parameters[5].ToString());
            Assert.Equal(false, clientModel.Methods[1].Parameters[5].IsRequired);
            Assert.Equal(1, clientModel.Methods[1].InputParameterTransformation.Count);
            Assert.Equal(3, clientModel.Methods[1].InputParameterTransformation[0].ParameterMappings.Count);
        }

        [Fact]
        public void TestParameterLocationExtension()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-parameter-location.json"),
                PayloadFlatteningThreshold = 3
            };
            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);

            Assert.NotNull(clientModel);
            Assert.Equal(2, clientModel.Properties.Count);
            Assert.Equal(clientModel.Properties[0].Name, "subscriptionId");
            Assert.Equal(clientModel.Properties[1].Name, "apiVersion");
            Assert.True(clientModel.Methods[0].Parameters.Any(p => p.Name == "resourceGroupName" && !p.IsClientProperty));
            Assert.True(clientModel.Methods[0].Parameters.Any(p => p.Name == "subscriptionId" && p.IsClientProperty));
            Assert.True(clientModel.Methods[0].Parameters.Any(p => p.Name == "apiVersion" && p.IsClientProperty));
            Assert.True(clientModel.Methods[1].Parameters.Any(p => p.Name == "resourceGroupName" && !p.IsClientProperty));
            Assert.True(clientModel.Methods[1].Parameters.Any(p => p.Name == "subscriptionId" && p.IsClientProperty));
            Assert.True(clientModel.Methods[1].Parameters.Any(p => p.Name == "apiVersion" && p.IsClientProperty));
        }

        [Fact]
        public void TestClientModelWithPayloadFlatteningViaXMSClientFlatten()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-x-ms-client-flatten.json")
            };
            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);

            Assert.NotNull(clientModel);
            Assert.Equal(8, clientModel.ModelTypes.Count);
            Assert.True(clientModel.ModelTypes.Any(m => m.Name == "BaseProduct"));
            Assert.True(clientModel.ModelTypes.Any(m => m.Name == "SimpleProduct"));
            Assert.True(clientModel.ModelTypes.Any(m => m.Name == "ConflictedProduct"));
            Assert.True(clientModel.ModelTypes.Any(m => m.Name == "ConflictedProductProperties")); // Since it's referenced in the response
            Assert.True(clientModel.ModelTypes.Any(m => m.Name == "RecursiveProduct"));
            Assert.True(clientModel.ModelTypes.Any(m => m.Name == "Error"));
            Assert.True(clientModel.ModelTypes.Any(m => m.Name == "ProductWithInheritance"));
            Assert.True(clientModel.ModelTypes.Any(m => m.Name == "BaseFlattenedProduct"));

            var simpleProduct = clientModel.ModelTypes.First(m => m.Name == "SimpleProduct");
            Assert.True(simpleProduct.Properties.Any(p => p.SerializedName == "details.max_product_display_name"
                                                       && p.Name == "max_product_display_name"));
            Assert.True(simpleProduct.Properties.Any(p => p.SerializedName == "details.max_product_capacity"
                                                       && p.Name == "max_product_capacity"));
            Assert.True(simpleProduct.Properties.Any(p => p.SerializedName == "details.max_product_image.@odata\\\\.value"
                                                       && p.Name == "@odata.value"));

            var conflictedProduct = clientModel.ModelTypes.First(m => m.Name == "ConflictedProduct");
            Assert.True(conflictedProduct.Properties.Any(p => p.SerializedName == "max_product_display_name"
                                                       && p.Name == "max_product_display_name"));
            Assert.True(conflictedProduct.Properties.Any(p => p.SerializedName == "details.max_product_display_name"
                                                       && p.Name == "ConflictedProductProperties_max_product_display_name"));
            Assert.True(conflictedProduct.Properties.Any(p => p.SerializedName == "simpleDetails.max_product_display_name"
                                                       && p.Name == "SimpleProductProperties_max_product_display_name"));
            Assert.True(conflictedProduct.Properties.Any(p => p.SerializedName == "details.base_product_description"
                                                       && p.Name == "ConflictedProduct_base_product_description"));

            var recursiveProduct = clientModel.ModelTypes.First(m => m.Name == "RecursiveProduct");
            Assert.True(recursiveProduct.Properties.Any(p => p.SerializedName == "properties.name"
                                                       && p.Name == "name"));
            Assert.True(recursiveProduct.Properties.Any(p => p.SerializedName == "properties.parent"
                                                       && p.Name == "parent"));

            var error = clientModel.ModelTypes.First(m => m.Name == "Error");
            Assert.Equal(3, error.Properties.Count);
            Assert.True(error.Properties.Any(p => p.SerializedName == "code" && p.Name == "code"));
            Assert.True(error.Properties.Any(p => p.SerializedName == "message" && p.Name == "message"));
            Assert.True(error.Properties.Any(p => p.SerializedName == "parentError" && p.Name == "parentError"));
            Assert.True(error.Properties.First(p => p.SerializedName == "parentError" && p.Name == "parentError").Type == error);
        }

        [Fact]
        public void TestClientModelClientName()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-x-ms-client-name.json")
            };

            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);

            Assert.NotNull(clientModel);
            Assert.Equal(2, clientModel.Methods.Count);
            Assert.Equal(2, clientModel.Methods[0].Parameters.Where(p => !p.IsClientProperty).Count());
            Assert.Equal(0, clientModel.Methods[1].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].GetClientName());
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].GetClientName());
            Assert.Equal("subscriptionId", clientModel.Methods[0].Parameters[0].Name);
            Assert.Equal("apiVersion", clientModel.Methods[0].Parameters[1].Name);

            Assert.Equal(2, clientModel.Properties.Count);
            Assert.Equal("subscription", clientModel.Properties[0].GetClientName());
            Assert.Equal("_version", clientModel.Properties[1].GetClientName());
            Assert.Equal("subscriptionId", clientModel.Properties[0].Name);
            Assert.Equal("apiVersion", clientModel.Properties[1].Name);

            Assert.Equal(1, clientModel.ModelTypes.Count);

            var type = clientModel.ModelTypes.First();

            Assert.Equal("code", type.Properties[0].Name);
            Assert.Equal("message", type.Properties[1].Name);
            Assert.Equal("parentError", type.Properties[2].Name);

            Assert.Equal("errorCode", type.Properties[0].GetClientName());
            Assert.Equal("errorMessage", type.Properties[1].GetClientName());
            Assert.Equal("ParentError", type.Properties[2].GetClientName());
        }

        [Fact]
        public void TestClientNameCSharpNormalization()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-x-ms-client-name.json")
            };

            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);
            var namer = new CSharpCodeNamer();
            namer.NormalizeClientModel(clientModel);

            Assert.NotNull(clientModel);
            Assert.Equal(2, clientModel.Methods.Count);

            Assert.Equal(2, clientModel.Methods[0].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].GetClientName());
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].GetClientName());
            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].Name);
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].Name);

            Assert.Equal(2, clientModel.Properties.Count);
            Assert.Equal(0, clientModel.Methods[1].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Properties[0].GetClientName());
            Assert.Equal("_version", clientModel.Properties[1].GetClientName());
            Assert.Equal("Subscription", clientModel.Properties[0].Name);
            Assert.Equal("_version", clientModel.Properties[1].Name);

            var type = clientModel.ModelTypes.First();

            Assert.Equal("ErrorCode", type.Properties[0].Name);
            Assert.Equal("ErrorMessage", type.Properties[1].Name);
            Assert.Equal("ParentError", type.Properties[2].Name);
        }

        [Fact]
        public void TestClientNameJavaNormalization()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-x-ms-client-name.json")
            };

            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);
            var namer = new JavaCodeNamer(setting.Namespace);
            namer.NormalizeClientModel(clientModel);

            Assert.NotNull(clientModel);
            Assert.Equal(2, clientModel.Methods.Count);

            Assert.Equal(2, clientModel.Methods[0].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].GetClientName());
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].GetClientName());
            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].Name);
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].Name);

            Assert.Equal(2, clientModel.Properties.Count);
            Assert.Equal(0, clientModel.Methods[1].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Properties[0].GetClientName());
            Assert.Equal("_version", clientModel.Properties[1].GetClientName());
            Assert.Equal("subscription", clientModel.Properties[0].Name);
            Assert.Equal("_version", clientModel.Properties[1].Name);

            var type = clientModel.ModelTypes.First();

            Assert.Equal("errorCode", type.Properties[0].Name);
            Assert.Equal("errorMessage", type.Properties[1].Name);
            Assert.Equal("parentError", type.Properties[2].Name);
        }

        [Fact]
        public void TestClientNameNodeJSNormalization()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-x-ms-client-name.json")
            };

            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);
            var namer = new NodeJsCodeNamer();
            namer.NormalizeClientModel(clientModel);

            Assert.NotNull(clientModel);
            Assert.Equal(2, clientModel.Methods.Count);

            Assert.Equal(2, clientModel.Methods[0].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].GetClientName());
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].GetClientName());
            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].Name);
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].Name);

            Assert.Equal(2, clientModel.Properties.Count);
            Assert.Equal(0, clientModel.Methods[1].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Properties[0].GetClientName());
            Assert.Equal("_version", clientModel.Properties[1].GetClientName());
            Assert.Equal("subscription", clientModel.Properties[0].Name);
            Assert.Equal("_version", clientModel.Properties[1].Name);

            var type = clientModel.ModelTypes.First();

            Assert.Equal("errorCode", type.Properties[0].Name);
            Assert.Equal("errorMessage", type.Properties[1].Name);
            Assert.Equal("parentError", type.Properties[2].Name);
        }

        [Fact]
        public void TestClientNamePythonNormalization()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-x-ms-client-name.json")
            };

            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);
            var namer = new PythonCodeNamer();
            namer.NormalizeClientModel(clientModel);

            Assert.NotNull(clientModel);
            Assert.Equal(2, clientModel.Methods.Count);

            Assert.Equal(2, clientModel.Methods[0].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].GetClientName());
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].GetClientName());
            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].Name);
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].Name);

            Assert.Equal(2, clientModel.Properties.Count);
            Assert.Equal(0, clientModel.Methods[1].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Properties[0].GetClientName());
            Assert.Equal("_version", clientModel.Properties[1].GetClientName());
            Assert.Equal("subscription", clientModel.Properties[0].Name);
            Assert.Equal("_version", clientModel.Properties[1].Name);

            var type = clientModel.ModelTypes.First();

            Assert.Equal("error_code", type.Properties[0].Name);
            Assert.Equal("error_message", type.Properties[1].Name);
            Assert.Equal("parent_error", type.Properties[2].Name);
        }

        [Fact]
        public void TestClientNameRubyNormalization()
        {
            var setting = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-x-ms-client-name.json")
            };

            var modeler = new SwaggerModeler(setting);
            var clientModel = modeler.Build();
            SwaggerExtensions.NormalizeClientModel(clientModel, setting);
            var namer = new RubyCodeNamer();
            namer.NormalizeClientModel(clientModel);

            Assert.NotNull(clientModel);
            Assert.Equal(2, clientModel.Methods.Count);

            Assert.Equal(2, clientModel.Methods[0].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].GetClientName());
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].GetClientName());
            Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].Name);
            Assert.Equal("version", clientModel.Methods[0].Parameters[1].Name);

            Assert.Equal(2, clientModel.Properties.Count);
            Assert.Equal(0, clientModel.Methods[1].Parameters.Where(p => !p.IsClientProperty).Count());

            Assert.Equal("subscription", clientModel.Properties[0].GetClientName());
            Assert.Equal("_version", clientModel.Properties[1].GetClientName());
            Assert.Equal("subscription", clientModel.Properties[0].Name);
            Assert.Equal("_version", clientModel.Properties[1].Name);

            var type = clientModel.ModelTypes.First();

            Assert.Equal("error_code", type.Properties[0].Name);
            Assert.Equal("error_message", type.Properties[1].Name);
            Assert.Equal("parent_error", type.Properties[2].Name);
        }
    }
}
