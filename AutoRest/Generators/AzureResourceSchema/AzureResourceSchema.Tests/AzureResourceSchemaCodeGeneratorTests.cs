// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using System;
using Xunit;

namespace Microsoft.Rest.Generator.AzureResourceSchema.Tests
{
    [Collection("AutoRest Tests")]
    public class AzureResourceSchemaCodeGeneratorTests
    {
        [Fact]
        public void DescriptionThrowsException()
        {
            Assert.Equal("Azure Resource Schema generator", CreateGenerator().Description);
        }

        [Fact]
        public void ImplementationFileExtensionThrowsException()
        {
            Assert.Equal(".json", CreateGenerator().ImplementationFileExtension);
        }

        [Fact]
        public void NameThrowsException()
        {
            Assert.Equal("AzureResourceSchema", CreateGenerator().Name);
        }

        [Fact]
        public void UsageInstructionsThrowsException()
        {
            Assert.Equal("MOCK USAGE INSTRUCTIONS", CreateGenerator().UsageInstructions);
        }

        [Fact]
        public void GenerateThrowsException()
        {
            ServiceClient serviceClient = new ServiceClient();
            Assert.Throws<NotImplementedException>(() => { CreateGenerator().Generate(serviceClient); });
        }

        [Fact]
        public void NormalizeClientModelThrowsException()
        {
            ServiceClient serviceClient = new ServiceClient();
            Assert.Throws<NotImplementedException>(() => { CreateGenerator().NormalizeClientModel(serviceClient); });
        }

        private static AzureResourceSchemaCodeGenerator CreateGenerator()
        {
            return new AzureResourceSchemaCodeGenerator(new Settings());
        }
    }
}
