// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger;
using System;
using System.IO;
using System.Linq;
using Xunit;

namespace Microsoft.Rest.Generator.CSharp.Azure.Tests
{
    public class CSharpAzureCodeNamingFrameworkTests
    {
        [Fact]
        public void ConvertsPageResultsToPageTypeTest()
        {
            var settings = new Settings
            {
                Input = @"Swagger\azure-paging.json",
                Header = "NONE",
                Modeler = "Swagger"
            };
            settings.FileSystem = new MemoryFileSystem();
            settings.FileSystem.CreateDirectory(Path.GetDirectoryName(settings.Input));
            settings.FileSystem.WriteFile(settings.Input, File.ReadAllText(settings.Input));

            SwaggerModeler modeler = new SwaggerModeler(settings);
            var serviceClient = modeler.Build();
            var codeNamer = new AzureCSharpCodeNamer();

            codeNamer.NormalizePaginatedMethods(serviceClient);
            Assert.Equal("Page<Product>", serviceClient.Methods[0].ReturnType.Name);
            Assert.Equal("Object", serviceClient.Methods[1].ReturnType.Name);
            Assert.Equal("Page<Product>", serviceClient.Methods[1].Responses.ElementAt(0).Value.Name);
            Assert.Equal("String", serviceClient.Methods[1].Responses.ElementAt(1).Value.Name);
            Assert.Equal("Object", serviceClient.Methods[2].ReturnType.Name);
            Assert.Equal("Page<Product>", serviceClient.Methods[2].Responses.ElementAt(0).Value.Name);
            Assert.Equal("Page<Product>", serviceClient.Methods[2].Responses.ElementAt(1).Value.Name);
            Assert.Equal("Object", serviceClient.Methods[3].ReturnType.Name);
            Assert.Equal("Page<Product>", serviceClient.Methods[3].Responses.ElementAt(0).Value.Name);
            Assert.Equal("Page<ProductChild>", serviceClient.Methods[3].Responses.ElementAt(1).Value.Name);
            Assert.Equal(4, serviceClient.ModelTypes.Count);
            Assert.False(serviceClient.ModelTypes.Any(t => t.Name.Equals("ProducResult", StringComparison.OrdinalIgnoreCase)));
            Assert.False(serviceClient.ModelTypes.Any(t => t.Name.Equals("ProducResult2", StringComparison.OrdinalIgnoreCase)));
            Assert.False(serviceClient.ModelTypes.Any(t => t.Name.Equals("ProducResult3", StringComparison.OrdinalIgnoreCase)));
        }
    }
}
