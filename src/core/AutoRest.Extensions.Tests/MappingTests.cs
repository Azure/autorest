// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.CSharp;
using AutoRest.Swagger;
using Xunit;

namespace AutoRest.Extensions.Tests
{
    public class MappingExtensionsTests
    {
        [Fact]
        public void TestInputMapping()
        {
            var settings = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-payload-flatten.json"),
                PayloadFlatteningThreshold = 3,
                OutputDirectory = Path.GetTempPath()
            };
            settings.FileSystem = new MemoryFileSystem();
            settings.FileSystem.WriteFile("AutoRest.json", File.ReadAllText("AutoRest.json"));
            settings.FileSystem.CreateDirectory(Path.GetDirectoryName(settings.Input));
            settings.FileSystem.WriteFile(settings.Input, File.ReadAllText(settings.Input));

            var modeler = new SwaggerModeler(settings);
            var clientModel = modeler.Build();
            CSharpCodeGenerator generator = new CSharpCodeGenerator(settings);
            generator.NormalizeClientModel(clientModel);
            generator.Generate(clientModel).GetAwaiter().GetResult();
            string body = settings.FileSystem.ReadFileAsText(Path.Combine(settings.OutputDirectory, "Payload.cs"));
            Assert.True(body.ContainsMultiline(@"
                MinProduct minProduct = new MinProduct();
                if (baseProductId != null || baseProductDescription != null || maxProductReference != null)
                {
                    minProduct.BaseProductId = baseProductId;
                    minProduct.BaseProductDescription = baseProductDescription;
                    minProduct.MaxProductReference = maxProductReference;
                }"));
        }
    }
}
