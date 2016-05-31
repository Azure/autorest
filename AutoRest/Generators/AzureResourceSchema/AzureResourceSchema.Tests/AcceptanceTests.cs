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
        public static void Batch()
        {
            RunSwaggerTest("Batch", "2015-12-01", "BatchManagement.json");
        }

        [Fact]
        public static void Cdn_2015_06_01()
        {
            RunSwaggerTest("CDN", "2015-06-01", "cdn.json");
        }

        [Fact]
        public static void Cdn_2016_04_02()
        {
            RunSwaggerTest("CDN", "2016-04-02", "cdn.json");
        }

        [Fact]
        public static void CognitiveServices_2016_02_01_preview()
        {
            RunSwaggerTest("CognitiveServices", "2016-02-01-preview", "cognitiveservices.json");
        }

        [Fact]
        public static void Compute_2015_06_15()
        {
            RunSwaggerTest("Compute", "2015-06-15", "compute.json");
        }

        [Fact]
        public static void Compute_2016_03_30()
        {
            RunSwaggerTest("Compute", "2016-03-30", "compute.json");
        }

        [Fact]
        public static void DataLakeAnalytics_2015_10_01_preview()
        {
            RunSwaggerTest("DataLakeAnalytics", "2015-10-01-preview", "account.json");
        }

        [Fact]
        public static void DataLakeStore_2015_10_01_preview()
        {
            RunSwaggerTest("DataLakeStore", "2015-10-01-preview", "account.json");
        }

        [Fact]
        public static void DevTestLabs_2015_05_21_preview()
        {
            RunSwaggerTest("DevTestLabs", "2015-05-21-preview", "DTL.json");
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
        public static void Network_2015_05_01_preview()
        {
            RunSwaggerTest("Network", "2015-05-01-preview", "network.json");
        }

        [Fact]
        public static void Network_2015_06_15()
        {
            RunSwaggerTest("Network", "2015-06-15", "network.json");
        }

        [Fact]
        public static void Network_2016_03_30()
        {
            RunSwaggerTest("Network", "2016-03-30", "network.json");
        }

        [Fact]
        public static void Storage_2015_05_01_preview()
        {
            RunSwaggerTest("Storage", "2015-05-01-preview", "storage.json");
        }

        [Fact]
        public static void Storage_2015_06_15()
        {
            RunSwaggerTest("Storage", "2015-06-15", "storage.json");
        }

        [Fact]
        public static void Storage_2016_01_01()
        {
            RunSwaggerTest("Storage", "2016-01-01", "storage.json");
        }

        [Fact]
        public static void Web()
        {
            RunSwaggerTest("Web", "2015-08-01", "web.json");
        }

        [Fact]
        public static void WebYaml()
        {
            // same test as Web(), but converted to YAML
            RunSwaggerTest("Web", "2015-08-01", "web.yaml");
        }

        private static void RunSwaggerTest(string resourceType, string apiVersion, string swaggerFileName)
        {
            SwaggerSpecHelper.RunTests<AzureResourceSchemaCodeGenerator>(
                Path.Combine("Swagger", resourceType, apiVersion, swaggerFileName),
                Path.Combine("Expected", resourceType, apiVersion));
        }
    }
}
