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
            Settings settings = new Settings();
            AzureResourceSchemaCodeGenerator codeGen = new AzureResourceSchemaCodeGenerator(settings);
            Assert.Throws<NotImplementedException>(() => { string value = codeGen.Description; });
        }

        [Fact]
        public void ImplementationFileExtensionThrowsException()
        {
            Settings settings = new Settings();
            AzureResourceSchemaCodeGenerator codeGen = new AzureResourceSchemaCodeGenerator(settings);
            Assert.Throws<NotImplementedException>(() => { string value = codeGen.ImplementationFileExtension; });
        }

        [Fact]
        public void NameThrowsException()
        {
            Settings settings = new Settings();
            AzureResourceSchemaCodeGenerator codeGen = new AzureResourceSchemaCodeGenerator(settings);
            Assert.Throws<NotImplementedException>(() => { string value = codeGen.Name; });
        }

        [Fact]
        public void UsageInstructionsThrowsException()
        {
            Settings settings = new Settings();
            AzureResourceSchemaCodeGenerator codeGen = new AzureResourceSchemaCodeGenerator(settings);
            Assert.Throws<NotImplementedException>(() => { string value = codeGen.UsageInstructions; });
        }

        [Fact]
        public void GenerateThrowsException()
        {
            Settings settings = new Settings();
            AzureResourceSchemaCodeGenerator codeGen = new AzureResourceSchemaCodeGenerator(settings);

            ServiceClient serviceClient = new ServiceClient();
            Assert.Throws<NotImplementedException>(() => { codeGen.Generate(serviceClient); });
        }

        [Fact]
        public void NormalizeClientModelThrowsException()
        {
            Settings settings = new Settings();
            AzureResourceSchemaCodeGenerator codeGen = new AzureResourceSchemaCodeGenerator(settings);

            ServiceClient serviceClient = new ServiceClient();
            Assert.Throws<NotImplementedException>(() => { codeGen.NormalizeClientModel(serviceClient); });
        }
    }
}
