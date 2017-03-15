// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using AutoRest.Core;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swagger.Tests
{
    [Collection("AutoRest Tests")]
    public class VendorExtensionInPath
    {
        [Fact]
        public void AllowVendorExtensionInPath()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test"
                };
                SwaggerModeler modeler = new SwaggerModeler();
                var clientModel = modeler.Build(SwaggerParser.Parse("", File.ReadAllText(Path.Combine("Resource", "Swagger", "vendor-extension-in-path.json"))));

                // should return a valid model.
                Assert.NotNull(clientModel);

                // there should be one method in this generated api.
                Assert.Equal(1, modeler.CodeModel.Methods.Count);
            }
        }

    }
}