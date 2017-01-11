// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.Azure;
using AutoRest.Swagger;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Extensions.Azure.Tests
{
    public class CSharpAzureCodeNamingFrameworkTests
    {
        [Fact]
        public void ConvertsPageResultsToPageTypeTest()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Input = Path.Combine("Swagger", "azure-paging.json")
                };

                var modeler = new SwaggerModeler();
                var codeModel = modeler.Build();
                var plugin = new PluginCsa();
                using (plugin.Activate()) {
                    codeModel = plugin.Serializer.Load(codeModel);
                    codeModel = plugin.Transformer.TransformCodeModel(codeModel);

                    Assert.Equal(7, codeModel.Methods.Count);
                    Assert.Equal(1, codeModel.Methods.Count(m => m.Name == "GetSinglePage"));
                    Assert.Equal(0, codeModel.Methods.Count(m => m.Name == "GetSinglePageNext"));
                    Assert.Equal(1, codeModel.Methods.Count(m => m.Name == "PutSinglePage"));
                    Assert.Equal(1, codeModel.Methods.Count(m => m.Name == "PutSinglePageSpecialNext"));

                    Assert.Equal("Page<Product>", codeModel.Methods[0].ReturnType.Body.Name);
                    Assert.Equal("object", codeModel.Methods[1].ReturnType.Body.Name.ToLowerInvariant());
                    Assert.Equal("Page1<Product>", codeModel.Methods[1].Responses.ElementAt(0).Value.Body.Name);
                    Assert.Equal("string",
                        codeModel.Methods[1].Responses.ElementAt(1).Value.Body.Name.ToLowerInvariant());
                    Assert.Equal("object", codeModel.Methods[2].ReturnType.Body.Name.ToLowerInvariant());
                    Assert.Equal("Page1<Product>", codeModel.Methods[2].Responses.ElementAt(0).Value.Body.Name);
                    Assert.Equal("Page1<Product>", codeModel.Methods[2].Responses.ElementAt(1).Value.Body.Name);
                    Assert.Equal("object", codeModel.Methods[3].ReturnType.Body.Name.ToLowerInvariant());
                    Assert.Equal("Page1<Product>", codeModel.Methods[3].Responses.ElementAt(0).Value.Body.Name);
                    Assert.Equal("Page1<ProductChild>", codeModel.Methods[3].Responses.ElementAt(1).Value.Body.Name);
                    Assert.Equal(5, codeModel.ModelTypes.Count);
                    Assert.False(
                        codeModel.ModelTypes.Any(t => t.Name.EqualsIgnoreCase("ProducResult")));
                    Assert.False(
                        codeModel.ModelTypes.Any(t => t.Name.EqualsIgnoreCase("ProducResult2")));
                    Assert.False(
                        codeModel.ModelTypes.Any(t => t.Name.EqualsIgnoreCase("ProducResult3")));
                }
            }
        }
    }
}
