// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.CSharp.Azure;
using AutoRest.Swagger;
using Xunit;

namespace AutoRest.Extensions.Azure.Tests
{
    public class CSharpAzureCodeNamingFrameworkTests
    {
        [Fact]
        public void ConvertsPageResultsToPageTypeTest()
        {
            var settings = new Settings
            {
                Input = Path.Combine("Swagger", "azure-paging.json")
            };

            var modeler = new SwaggerModeler(settings);
            var serviceClient = modeler.Build();
            var codeGen = new AzureCSharpCodeGenerator(settings);
            codeGen.NormalizeClientModel(serviceClient);

            Assert.Equal(7, serviceClient.Methods.Count);
            Assert.Equal(1, serviceClient.Methods.Count(m => m.Name == "GetSinglePage"));
            Assert.Equal(0, serviceClient.Methods.Count(m => m.Name == "GetSinglePageNext"));
            Assert.Equal(1, serviceClient.Methods.Count(m => m.Name == "PutSinglePage"));
            Assert.Equal(1, serviceClient.Methods.Count(m => m.Name == "PutSinglePageSpecialNext"));

            Assert.Equal("Page<Product>", serviceClient.Methods[0].ReturnType.Body.Name);
            Assert.Equal("object", serviceClient.Methods[1].ReturnType.Body.Name.ToLowerInvariant());
            Assert.Equal("Page1<Product>", serviceClient.Methods[1].Responses.ElementAt(0).Value.Body.Name);
            Assert.Equal("string", serviceClient.Methods[1].Responses.ElementAt(1).Value.Body.Name.ToLowerInvariant());
            Assert.Equal("object", serviceClient.Methods[2].ReturnType.Body.Name.ToLowerInvariant());
            Assert.Equal("Page1<Product>", serviceClient.Methods[2].Responses.ElementAt(0).Value.Body.Name);
            Assert.Equal("Page1<Product>", serviceClient.Methods[2].Responses.ElementAt(1).Value.Body.Name);
            Assert.Equal("object", serviceClient.Methods[3].ReturnType.Body.Name.ToLowerInvariant());
            Assert.Equal("Page1<Product>", serviceClient.Methods[3].Responses.ElementAt(0).Value.Body.Name);
            Assert.Equal("Page1<ProductChild>", serviceClient.Methods[3].Responses.ElementAt(1).Value.Body.Name);
            Assert.Equal(5, serviceClient.ModelTypes.Count);
            Assert.False(serviceClient.ModelTypes.Any(t => t.Name.Equals("ProducResult", StringComparison.OrdinalIgnoreCase)));
            Assert.False(serviceClient.ModelTypes.Any(t => t.Name.Equals("ProducResult2", StringComparison.OrdinalIgnoreCase)));
            Assert.False(serviceClient.ModelTypes.Any(t => t.Name.Equals("ProducResult3", StringComparison.OrdinalIgnoreCase)));
        }
    }
}
