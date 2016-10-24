// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using AutoRest.Swagger.Tests;
using Xunit;

namespace AutoRest.AzureResourceSchema.Tests
{
    [Collection("AutoRest Azure Resource Schema Tests")]
    public static class AzureResourceSchemaAcceptanceTests
    {
        [Fact]
        public static void ApiManagement_2016_07_07()
        {
            RunSwaggerTest("ApiManagement", "2016-07-07", "apimanagement.json");
        }

        [Fact]
        public static void ApiManagement_2016_07_07b()
        {
            RunSwaggerTest("ApiManagement", "2016-07-07b", "apimanagement.json");
        }

        [Fact]
        public static void Authorization_2015_07_01()
        {
            RunSwaggerTest("Authorization", "2015-07-01", "authorization.json");
        }

        [Fact]
        public static void Batch_2015_12_01()
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
        public static void ContainerService_2016_03_30()
        {
            RunSwaggerTest("ContainerService", "2016-03-30", "containerService.json");
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
        public static void Logic_2015_02_01_preview()
        {
            RunSwaggerTest("Logic", "2015-02-01-preview", "logic.json");
        }

        [Fact]
        public static void Logic_2016_06_01()
        {
            RunSwaggerTest("Logic", "2016-06-01", "logic.json");
        }

        [Fact]
        public static void MachineLearning_2016_05_01_preview()
        {
            RunSwaggerTest("MachineLearning", "2016-05-01-preview", "webservices.json");
        }

        [Fact]
        public static void MobileEngagement_2014_12_01()
        {
            RunSwaggerTest("MobileEngagement", "2014-12-01", "mobile-engagement.json");
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
        public static void Network_2016_09_01()
        {
            RunSwaggerTest("Network", "2016-09-01", "network.json");
        }

        [Fact]
        public static void NotificationHubs_2016_03_01()
        {
            RunSwaggerTest("NotificationHubs", "2016-03-01", "notificationhubs.json");
        }

        [Fact]
        public static void PowerBIEmbedded_2016_01_29()
        {
            RunSwaggerTest("PowerBIEmbedded", "2016-01-29", "powerbiembedded.json");
        }

        [Fact]
        public static void RecoveryServices_2016_06_01()
        {
            RunSwaggerTest("RecoveryServices", "2016-06-01", "recoveryservices.json");
        }

        [Fact]
        public static void Redis_2016_04_01()
        {
            RunSwaggerTest("Redis", "2016-04-01", "redis.json");
        }

        [Fact]
        public static void Resources_Features_2015_12_01()
        {
            RunSwaggerTest("Resources/Features", "2015-12-01", "features.json");
        }

        [Fact]
        public static void Resources_Locks_2016_09_01()
        {
            RunSwaggerTest("Resources/Locks", "2016-09-01", "locks.json");
        }

        [Fact]
        public static void Resources_Policy_2016_04_01()
        {
            RunSwaggerTest("Resources/Policy", "2016-04-01", "policy.json");
        }

        [Fact]
        public static void Resources_Resources_2016_09_01()
        {
            RunSwaggerTest("Resources/Resources", "2016-09-01", "resources.json");
        }

        [Fact]
        public static void Resources_Subscriptions_2016_06_01()
        {
            RunSwaggerTest("Resources/Subscriptions", "2016-06-01", "subscriptions.json");
        }

        [Fact]
        public static void Scheduler_2016_03_01()
        {
            RunSwaggerTest("Scheduler", "2016-03-01", "scheduler.json");
        }

        [Fact]
        public static void Search_2015_02_28()
        {
            RunSwaggerTest("Search", "2015-02-28", "search.json");
        }
        
        [Fact]
        public static void ServerManagement_2016_07_01()
        {
            RunSwaggerTest("ServerManagement", "2016-07-01-preview", "servermanagement.json");
        }

        [Fact]
        public static void ServiceBus_2015_08_01()
        {
            RunSwaggerTest("ServiceBus", "2015-08-01", "servicebus.json");
        }

        [Fact]
        public static void ServiceFabric_2016_01_28()
        {
            RunSwaggerTest("ServiceFabric", "2016-01-28", "servicefabric.json");
        }

        [Fact]
        public static void SQL_2015_05_01()
        {
            RunSwaggerTest("SQL", "2015-05-01", "sql.json");
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
        public static void TrafficManager_2015_11_01()
        {
            RunSwaggerTest("TrafficManager", "2015-11-01", "trafficmanager.json");
        }

        [Fact]
        public static void Web_2015_08_01()
        {
            RunSwaggerTest("Web", "2015-08-01", "web.json");
        }

        [Fact]
        public static void WebYaml_2015_08_01()
        {
            // same test as Web(), but converted to YAML
            RunSwaggerTest("Web", "2015-08-01", "web.yaml");
        }

        private static void RunSwaggerTest(string resourceType, string apiVersion, string swaggerFileName)
        {
            SwaggerSpecHelper.RunTests(
                Path.Combine("Swagger", resourceType, apiVersion, swaggerFileName),
                Path.Combine("Expected", resourceType, apiVersion),plugin:"AzureResourceSchema");
        }
    }
}
