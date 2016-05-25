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
            RunSwaggerTest("Storage", "2016-01-01", "storage.json");
        }

        [Fact]
        public static void Batch()
        {
            RunSwaggerTest("Batch", "2015-12-01", "BatchManagement.json");
        }

        [Fact]
        public static void Cdn()
        {
            RunSwaggerTest("CDN", "2016-04-02", "cdn.json");
        }

        [Fact]
        public static void Compute()
        {
            RunSwaggerTest("Compute", "2016-03-30", "compute.json");
        }

        [Fact]
        public static void Dns_2015_05_04_preview()
        {
            RunSwaggerTest("DNS", "2015-05-04-preview", "dns.json");
        }

        [Fact]
        public static void Dns_2016_04_01()
        {
            RunSwaggerTest("DNS", "2016-04-01", "dns.json");
        }

        [Fact]
        public static void Network()
        {
            RunSwaggerTest("Network", "2016-03-30", "network.json");
        }

        [Fact]
        public static void Web()
        {
            RunSwaggerTest("Web", "2015-08-01", "web.json");
        }

        private static void RunSwaggerTest(string resourceType, string apiVersion, string swaggerFileName)
        {
            SwaggerSpecHelper.RunTests<AzureResourceSchemaCodeGenerator>(
                Path.Combine("Swagger", resourceType, apiVersion, swaggerFileName),
                Path.Combine("Expected", resourceType, apiVersion));
        }
    }
}
