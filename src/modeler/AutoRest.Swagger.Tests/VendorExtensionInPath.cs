// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using AutoRest.Core;
using Xunit;

namespace AutoRest.Swagger.Tests
{
    [Collection("AutoRest Tests")]
    public class VendorExtensionInPath
    {
        [Fact]
        public void AllowVendorExtensionInPath()
        {
            SwaggerModeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "vendor-extension-in-path.json")
            });
            var clientModel = modeler.Build();

            // should return a valid model.
            Assert.NotNull(clientModel);

            // there should be one method in this generated api.
            Assert.Equal(1, modeler.ServiceClient.Methods.Count);
        }
    }
}