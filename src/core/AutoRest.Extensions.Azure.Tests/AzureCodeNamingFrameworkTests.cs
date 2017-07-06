// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Extensions.Azure.Tests
{
    public class AzureCodeNamingFrameworkTests
    {
        [Fact]
        public void ConvertsPageResultsToPageTypeTest()
        {
            var input = Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "azure-paging.json");

            var modeler = new SwaggerModeler();
            var codeModel = modeler.Build(SwaggerParser.Parse(File.ReadAllText(input)));
            AzureExtensions.NormalizeAzureClientModel(codeModel);

            Assert.Equal(7, codeModel.Methods.Count);
            Assert.Equal(1, codeModel.Methods.Count(m => m.Name == "GetSinglePage"));
            Assert.Equal(0, codeModel.Methods.Count(m => m.Name == "GetSinglePageNext"));
            Assert.Equal(1, codeModel.Methods.Count(m => m.Name == "PutSinglePage"));
            Assert.Equal(1, codeModel.Methods.Count(m => m.Name == "PutSinglePageSpecialNext"));

            Assert.Equal("ProductResult", codeModel.Methods[0].ReturnType.Body.Name);
            Assert.Equal("object", codeModel.Methods[1].ReturnType.Body.Name.ToLowerInvariant());
            Assert.Equal("ProductResult", codeModel.Methods[1].Responses.ElementAt(0).Value.Body.Name);
            Assert.Equal("string",
                codeModel.Methods[1].Responses.ElementAt(1).Value.Body.Name.ToLowerInvariant());
            Assert.Equal("object", codeModel.Methods[2].ReturnType.Body.Name.ToLowerInvariant());
            Assert.Equal("ProductResult", codeModel.Methods[2].Responses.ElementAt(0).Value.Body.Name);
            Assert.Equal("ProductResult2", codeModel.Methods[2].Responses.ElementAt(1).Value.Body.Name);
            Assert.Equal("object", codeModel.Methods[3].ReturnType.Body.Name.ToLowerInvariant());
            Assert.Equal("ProductResult", codeModel.Methods[3].Responses.ElementAt(0).Value.Body.Name);
            Assert.Equal("ProductResult3", codeModel.Methods[3].Responses.ElementAt(1).Value.Body.Name);
            Assert.Equal(8, codeModel.ModelTypes.Count);
        }
    }
}
