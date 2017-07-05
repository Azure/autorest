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
                var input = Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "swagger-payload-flatten.json");
                var modeler = new SwaggerModeler(new Settings { PayloadFlatteningThreshold = 3 });
                var clientModel = modeler.Build(SwaggerParser.Parse(File.ReadAllText(input)));
                var plugin = new PluginCs();
                using (plugin.Activate())
                {
                    clientModel = plugin.Serializer.Load(clientModel);
                    clientModel = plugin.Transformer.TransformCodeModel(clientModel);
                    CodeGeneratorCs generator = new CodeGeneratorCs();

                    generator.Generate(clientModel).GetAwaiter().GetResult();
                    string body = Settings.Instance.FileSystemOutput.ReadAllText(Path.Combine("Payload.cs"));
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
