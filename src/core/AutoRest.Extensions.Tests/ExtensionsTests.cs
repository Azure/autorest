// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Swagger;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

#if gws_uh_no_just_no
// If we want to keep these tests, they really 
// should be migrated to the language 
// specific tests projects. 

using AutoRest.Java;
using AutoRest.NodeJS;
using AutoRest.Python;
using AutoRest.Ruby;
#endif

namespace AutoRest.Extensions.Tests
{
    public class ExtensionsTests
    {
        [Fact]
        public void TestClientModelWithPayloadFlattening()
        {
            using (NewContext)
            {
                var setting = new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "swagger-payload-flatten.json"),
                    PayloadFlatteningThreshold = 3
                };
                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build();
                SwaggerExtensions.NormalizeClientModel(clientModel);

                Assert.NotNull(clientModel);
                Assert.Equal(4, clientModel.Methods[0].Parameters.Count);
                Assert.Equal("String subscriptionId", clientModel.Methods[0].Parameters[0].ToString());
                Assert.Equal("String resourceGroupName", clientModel.Methods[0].Parameters[1].ToString());
                Assert.Equal("String apiVersion", clientModel.Methods[0].Parameters[2].ToString());
                Assert.Equal("MaxProduct maxProduct", clientModel.Methods[0].Parameters[3].ToString());
                Assert.Equal(6, clientModel.Methods[1].Parameters.Count);
                Assert.Equal("String subscriptionId", clientModel.Methods[1].Parameters[0].ToString());
                Assert.Equal("String resourceGroupName", clientModel.Methods[1].Parameters[1].ToString());
                Assert.Equal("String apiVersion", clientModel.Methods[1].Parameters[2].ToString());
                Assert.Equal("String baseProductId", clientModel.Methods[1].Parameters[3].ToString());
                Assert.Equal(true, clientModel.Methods[1].Parameters[3].IsRequired);
                Assert.Equal("String baseProductDescription", clientModel.Methods[1].Parameters[4].ToString());
                Assert.Equal(false, clientModel.Methods[1].Parameters[4].IsRequired);
                Assert.Equal("MaxProduct maxProductReference", clientModel.Methods[1].Parameters[5].ToString());
                Assert.Equal(false, clientModel.Methods[1].Parameters[5].IsRequired);
                Assert.Equal(1, clientModel.Methods[1].InputParameterTransformation.Count);
                Assert.Equal(3, clientModel.Methods[1].InputParameterTransformation[0].ParameterMappings.Count);
            }
        }

        [Fact]
        public void TestParameterLocationExtension()
        {
            using (NewContext)
            {
                var setting = new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "swagger-parameter-location.json"),
                    PayloadFlatteningThreshold = 3
                };
                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build();
                SwaggerExtensions.NormalizeClientModel(clientModel);

                Assert.NotNull(clientModel);
                Assert.Equal(2, clientModel.Properties.Count);
                Assert.Equal(clientModel.Properties[0].Name, "SubscriptionId");
                Assert.Equal(clientModel.Properties[1].Name, "ApiVersion");
                Assert.False(
                    clientModel.Methods[0].Parameters.First(p => p.Name == "resourceGroupName").IsClientProperty);
                Assert.True(clientModel.Methods[0].Parameters.First(p => p.Name == "subscriptionId").IsClientProperty);
                Assert.True(clientModel.Methods[0].Parameters.First(p => p.Name == "apiVersion").IsClientProperty);
                Assert.False(
                    clientModel.Methods[1].Parameters.First(p => p.Name == "resourceGroupName").IsClientProperty);
                Assert.True(clientModel.Methods[1].Parameters.First(p => p.Name == "subscriptionId").IsClientProperty);
                Assert.True(clientModel.Methods[1].Parameters.First(p => p.Name == "apiVersion").IsClientProperty);
            }
        }

        [Fact]
        public void TestClientModelWithPayloadFlatteningViaXMSClientFlatten()
        {
            using (NewContext)
            {
                var setting = new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "swagger-x-ms-client-flatten.json")
                };
                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build();
                SwaggerExtensions.NormalizeClientModel(clientModel);

                Assert.NotNull(clientModel);
                Assert.Equal(8, clientModel.ModelTypes.Count);
                Assert.True(clientModel.ModelTypes.Any(m => m.Name == "BaseProduct"));
                Assert.True(clientModel.ModelTypes.Any(m => m.Name == "SimpleProduct"));
                Assert.True(clientModel.ModelTypes.Any(m => m.Name == "ConflictedProduct"));
                Assert.True(clientModel.ModelTypes.Any(m => m.Name == "ConflictedProductProperties"));
                // Since it's referenced in the response
                Assert.True(clientModel.ModelTypes.Any(m => m.Name == "RecursiveProduct"));
                Assert.True(clientModel.ModelTypes.Any(m => m.Name == "Error"));
                Assert.True(clientModel.ModelTypes.Any(m => m.Name == "ProductWithInheritance"));
                Assert.True(clientModel.ModelTypes.Any(m => m.Name == "BaseFlattenedProduct"));

                var simpleProduct = clientModel.ModelTypes.First(m => m.Name == "SimpleProduct");
                Assert.True(simpleProduct.Properties.Any(p => (p.SerializedName == "details.max_product_display_name")
                                                              && (p.Name == "MaxProductDisplayName")));
                Assert.True(simpleProduct.Properties.Any(p => (p.SerializedName == "details.max_product_capacity")
                                                              && (p.Name == "MaxProductCapacity")));
                Assert.Equal("@odata.value",
                    simpleProduct.Properties.FirstOrDefault(
                        p => p.SerializedName == "details.max_product_image.@odata\\\\.value").Name.FixedValue);


                var conflictedProduct = clientModel.ModelTypes.First(m => m.Name == "ConflictedProduct");
                Assert.True(conflictedProduct.Properties.Any(p => (p.SerializedName == "max_product_display_name")
                                                                  && (p.Name.FixedValue == "max_product_display_name")));
                Assert.Equal("MaxProductDisplayName2",
                    conflictedProduct.Properties.FirstOrDefault(
                        p => p.SerializedName == "details.max_product_display_name").Name);


                Assert.Equal("MaxProductDisplayName1",
                    conflictedProduct.Properties.First(p => p.SerializedName == "simpleDetails.max_product_display_name")
                        .Name);
                Assert.Equal("ConflictedProductBaseProductDescription",
                    conflictedProduct.Properties.First(p => p.SerializedName == "details.base_product_description").Name);

                var recursiveProduct = clientModel.ModelTypes.First(m => m.Name == "RecursiveProduct");
                Assert.Equal("Name", recursiveProduct.Properties.First(p => p.SerializedName == "properties.name").Name);

                Assert.Equal("Parent",
                    recursiveProduct.Properties.First(p => p.SerializedName == "properties.parent").Name);


                var error = clientModel.ModelTypes.First(m => m.Name == "Error");
                Assert.Equal(3, error.Properties.Count);
                Assert.Equal("Code", error.Properties.First(p => p.SerializedName == "code").Name);
                Assert.Equal("Message", error.Properties.First(p => p.SerializedName == "message").Name);
                Assert.Equal("ParentError", error.Properties.First(p => p.SerializedName == "parentError").Name);
            }
        }

        [Fact]
        public void TestClientModelClientName()
        {
            using (NewContext)
            {
                var setting = new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "swagger-x-ms-client-name.json")
                };

                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build();
                SwaggerExtensions.NormalizeClientModel(clientModel);

                Assert.NotNull(clientModel);
                Assert.Equal(2, clientModel.Methods.Count);
                Assert.Equal(2, clientModel.Methods[0].Parameters.Where(p => !p.IsClientProperty).Count());
                Assert.Equal(0, clientModel.Methods[1].Parameters.Where(p => !p.IsClientProperty).Count());

                Assert.Equal("subscription", clientModel.Methods[0].Parameters[0].Name);
                Assert.Equal("version", clientModel.Methods[0].Parameters[1].Name);
                Assert.Equal("subscriptionId", clientModel.Methods[0].Parameters[0].Name.FixedValue);
                Assert.Equal("apiVersion", clientModel.Methods[0].Parameters[1].Name.FixedValue);

                Assert.Equal(2, clientModel.Properties.Count);
                Assert.Equal("Subscription", clientModel.Properties[0].Name);
                Assert.Equal("_version", clientModel.Properties[1].Name);
                Assert.Equal("subscriptionId", clientModel.Properties[0].Name.FixedValue);
                Assert.Equal("apiVersion", clientModel.Properties[1].Name.FixedValue);

                Assert.Equal(1, clientModel.ModelTypes.Count);

                var type = clientModel.ModelTypes.First();

                Assert.Equal("ErrorCode", type.Properties[0].Name);
                Assert.Equal("ErrorMessage", type.Properties[1].Name);
                Assert.Equal("ParentError", type.Properties[2].Name);

                Assert.Equal("code", type.Properties[0].Name.FixedValue);
                Assert.Equal("message", type.Properties[1].Name.FixedValue);
                Assert.Equal("parentError", type.Properties[2].Name.FixedValue);
            }
        }

        [Fact]
        public void TestClientNameCSharpNormalization()
        {
            using (NewContext)
            {
                var setting = new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "swagger-x-ms-client-name.json")
                };

                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build();
                SwaggerExtensions.NormalizeClientModel(clientModel);

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
        }

#if gws_uh_no_just_no
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
#endif
    }
}