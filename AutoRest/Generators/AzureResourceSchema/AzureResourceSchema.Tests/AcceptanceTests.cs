// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.AzureResourceSchema;
using Microsoft.Rest.Modeler.Swagger.Tests;
using System.IO;
using Xunit;

namespace AutoRest.Generator.AzureResourceSchema.Tests
{
    [Collection("AutoRest Azure Resource Schema Tests")]
    public static class AcceptanceTests
    {
        [Fact]
        public static void Storage()
        {
            RunSwaggerTest("storage.json", "Storage");
        }

        [Fact]
        public static void Batch()
        {
            RunSwaggerTest("BatchManagement.json", "Batch");
        }

        [Fact]
        public static void Cdn()
        {
            RunSwaggerTest("cdn.json", "CDN");
        }

        [Fact]
        public static void Compute()
        {
            RunSwaggerTest("compute.json", "Compute");
        }

        [Fact]
        public static void Network()
        {
            RunSwaggerTest("network.json", "Network");
        }

        private static void RunSwaggerTest(string swaggerFileName, string expectedFolderName)
        {
            SwaggerSpecHelper.RunTests<AzureResourceSchemaCodeGenerator>(
                Path.Combine("Swagger", swaggerFileName),
                Path.Combine("Expected", expectedFolderName));
        }
    }
}
