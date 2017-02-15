// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.CSharp.Tests.Utilities;

namespace AutoRest.CSharp.Tests
{
    public class MappingExtensionsTests
    {
        [Fact]
        public void TestInputMapping()
        {
            using (NewContext)
            {
                var settings = new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "swagger-payload-flatten.json"),
                    PayloadFlatteningThreshold = 3,
                    OutputDirectory = Path.GetTempPath()
                };
                settings.FileSystem = new MemoryFileSystem();
                settings.FileSystem.CreateDirectory(Path.GetDirectoryName(settings.Input));
                settings.FileSystem.WriteFile(settings.Input, File.ReadAllText(settings.Input));
                
                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build();
                var plugin = new PluginCs();
                using (plugin.Activate())
                {
                    clientModel = plugin.Serializer.Load(clientModel);
                    clientModel = plugin.Transformer.TransformCodeModel(clientModel);
                    CodeGeneratorCs generator = new CodeGeneratorCs();

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
    }
}
