// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using Microsoft.Rest.Modeler.Swagger;
using Xunit;

namespace Microsoft.Rest.Generator.Tests
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
            Extensions.NormalizeClientModel(clientModel, setting);

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
    }
}
