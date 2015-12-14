// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

// TODO: file length is getting excessive.
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using Fixtures.Azure.AcceptanceTestsAzureBodyDuration;
using Fixtures.Azure.AcceptanceTestsAzureReport;
using Fixtures.Azure.AcceptanceTestsAzureSpecials;
using Fixtures.Azure.AcceptanceTestsHead;
using Fixtures.Azure.AcceptanceTestsLro;
using Fixtures.Azure.AcceptanceTestsLro.Models;
using Fixtures.Azure.AcceptanceTestsPaging;
using Fixtures.Azure.AcceptanceTestsResourceFlattening;
using Fixtures.Azure.AcceptanceTestsResourceFlattening.Models;
using Fixtures.Azure.AcceptanceTestsSubscriptionIdApiVersion;
using Fixtures.Azure.AcceptanceTestsAzureParameterGrouping;
using Fixtures.Azure.AcceptanceTestsAzureParameterGrouping.Models;
using AutoRest.Generator.Azure.CSharp.Tests.Properties;
using Microsoft.Rest.Generator.CSharp.Tests;
using Xunit;
using Xunit.Abstractions;
using Microsoft.Rest.Azure;
using AutoRest.Generator.CSharp.Tests.Utilities;
using Microsoft.Framework.Logging;
using Microsoft.Rest.Azure.OData;
using Fixtures.Azure.AcceptanceTestsAzureSpecials.Models;

namespace Microsoft.Rest.Generator.CSharp.Azure.Tests
{
    [Collection("AutoRest Tests")]
    [TestCaseOrderer("Microsoft.Rest.Generator.CSharp.Tests.AcceptanceTestOrderer",
        "AutoRest.Generator.CSharp.Tests")]
    public class AcceptanceTests : IClassFixture<ServiceController>
    {
        private static readonly TestTracingInterceptor _interceptor;

        static AcceptanceTests()
        {
            _interceptor = new TestTracingInterceptor();
            ServiceClientTracing.AddTracingInterceptor(_interceptor);
        }

        public AcceptanceTests(ServiceController data)
        {
            this.Fixture = data;
            this.Fixture.TearDown = EnsureTestCoverage;
            ServiceClientTracing.IsEnabled = false;
        }

        public ServiceController Fixture { get; set; }

        private static string ExpectedPath(string file)
        {
            return Path.Combine("Expected", "AcceptanceTests", file);
        }

        private static string SwaggerPath(string file)
        {
            return Path.Combine("Swagger", file);
        }

        [Fact]
        public void AzureUrlTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("subscriptionId-apiVersion.json"), ExpectedPath("SubscriptionIdApiVersion"), generator: "Azure.CSharp");

            using (
                var client =
                    new MicrosoftAzureTestUrl(Fixture.Uri,
                        new TokenCredentials(Guid.NewGuid().ToString())))
            {
                client.SubscriptionId = Guid.NewGuid().ToString();
                var group = client.Group.GetSampleResourceGroup("testgroup101");
                Assert.Equal("testgroup101", group.Name);
                Assert.Equal("West US", group.Location);
            }
        }

        [Fact]
        public void HeadTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("head.json"), ExpectedPath("Head"), generator: "Azure.CSharp");

            using (
                var client = new AutoRestHeadTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                Assert.True(client.HttpSuccess.Head200());
                Assert.True(client.HttpSuccess.Head204());
                Assert.False(client.HttpSuccess.Head404());
            }
        }

        [Fact]
        public void LroHappyPathTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("lro.json"), ExpectedPath("Lro"), generator: "Azure.CSharp");
            using (
                var client = new AutoRestLongRunningOperationTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                client.LongRunningOperationRetryTimeout = 0;

                Assert.Equal("Succeeded",
                    client.LROs.Put201CreatingSucceeded200(new Product { Location = "West US" }).ProvisioningState);
                var exception =
                    Assert.Throws<CloudException>(
                        () => client.LROs.Put201CreatingFailed200(new Product { Location = "West US" }));

                Assert.Contains("Long running operation failed", exception.Message, StringComparison.Ordinal);
                Assert.Equal("Succeeded",
                    client.LROs.Put200UpdatingSucceeded204(new Product { Location = "West US" }).ProvisioningState);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROs.Put200Acceptedcanceled200(new Product { Location = "West US" }).ProvisioningState);
                Assert.Contains("Long running operation failed", exception.Message, StringComparison.Ordinal);
                Assert.Equal("Succeeded", client.LROs.PutNoHeaderInRetry(new Product { Location = "West US" }).ProvisioningState);
                Assert.Equal("Succeeded", client.LROs.PutAsyncNoHeaderInRetry(new Product { Location = "West US" }).ProvisioningState);
                Assert.Equal("Succeeded", client.LROs.PutSubResource(new SubProduct()).ProvisioningState);
                Assert.Equal("Succeeded", client.LROs.PutAsyncSubResource(new SubProduct()).ProvisioningState);
                Assert.Equal("100", client.LROs.PutNonResource(new Sku()).Id);
                Assert.Equal("100", client.LROs.PutAsyncNonResource(new Sku()).Id);
                client.LROs.Post202Retry200(new Product { Location = "West US" });
                Assert.Equal("Succeeded", client.LROs.Put200Succeeded(new Product { Location = "West US" }).ProvisioningState);
                Assert.Equal("100", client.LROs.Put200SucceededNoState(new Product { Location = "West US" }).Id);
                Assert.Equal("100", client.LROs.Put202Retry200(new Product { Location = "West US" }).Id);
                Assert.Equal("Succeeded",
                    client.LROs.PutAsyncRetrySucceeded(new Product { Location = "West US" }).ProvisioningState);
                Assert.Equal("Succeeded",
                    client.LROs.PutAsyncNoRetrySucceeded(new Product { Location = "West US" }).ProvisioningState);
                exception =
                    Assert.Throws<CloudException>(() => client.LROs.PutAsyncRetryFailed(new Product { Location = "West US" }));
                Assert.Contains("Long running operation failed", exception.Message, StringComparison.Ordinal);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROs.PutAsyncNoRetrycanceled(new Product { Location = "West US" }));
                Assert.Contains("Long running operation failed", exception.Message, StringComparison.Ordinal);
                client.LROs.Delete204Succeeded();
                client.LROs.Delete202Retry200();
                client.LROs.Delete202NoRetry204();
                client.LROs.DeleteAsyncNoRetrySucceeded();
                client.LROs.DeleteNoHeaderInRetry();
                client.LROs.DeleteAsyncNoHeaderInRetry();
                exception = Assert.Throws<CloudException>(() => client.LROs.DeleteAsyncRetrycanceled());
                Assert.Contains("Long running operation failed", exception.Message, StringComparison.Ordinal);
                exception = Assert.Throws<CloudException>(() => client.LROs.DeleteAsyncRetryFailed());
                Assert.Contains("Long running operation failed", exception.Message, StringComparison.Ordinal);
                client.LROs.DeleteAsyncRetrySucceeded();
                client.LROs.DeleteProvisioning202Accepted200Succeeded();
                client.LROs.DeleteProvisioning202Deletingcanceled200();
                client.LROs.DeleteProvisioning202DeletingFailed200();
                client.LROs.Post202NoRetry204(new Product { Location = "West US" });
                exception = Assert.Throws<CloudException>(() => client.LROs.PostAsyncRetryFailed());
                Assert.Contains("Long running operation failed with status 'Failed'", exception.Message,
                    StringComparison.Ordinal);
                Assert.NotNull(exception.Body);
                var error = exception.Body;
                Assert.NotNull(error.Code);
                Assert.NotNull(error.Message);
                exception = Assert.Throws<CloudException>(() => client.LROs.PostAsyncRetrycanceled());
                Assert.Contains("Long running operation failed with status 'Canceled'", exception.Message,
                    StringComparison.Ordinal);
                Product prod = client.LROs.PostAsyncRetrySucceeded();
                Assert.Equal("100", prod.Id);
                prod = client.LROs.PostAsyncNoRetrySucceeded();
                Assert.Equal("100", prod.Id);
                var sku = client.LROs.Post200WithPayload();
                Assert.Equal("1", sku.Id);
                // Retryable errors
                Assert.Equal("Succeeded",
                    client.LRORetrys.Put201CreatingSucceeded200(new Product { Location = "West US" }).ProvisioningState);
                Assert.Equal("Succeeded",
                    client.LRORetrys.PutAsyncRelativeRetrySucceeded(new Product { Location = "West US" }).ProvisioningState);
                client.LRORetrys.DeleteProvisioning202Accepted200Succeeded();
                client.LRORetrys.Delete202Retry200();
                client.LRORetrys.DeleteAsyncRelativeRetrySucceeded();
                client.LRORetrys.Post202Retry200(new Product { Location = "West US" });
                client.LRORetrys.PostAsyncRelativeRetrySucceeded(new Product { Location = "West US" });

                var customHeaders = new Dictionary<string, List<string>>
                {
                    {
                    "x-ms-client-request-id", new List<string> {"9C4D50EE-2D56-4CD3-8152-34347DC9F2B0"}
                    }
                };

                Assert.NotNull(client.LROsCustomHeader.PutAsyncRetrySucceededWithHttpMessagesAsync(
                                    new Product { Location = "West US" }, customHeaders).Result);

                Assert.NotNull(client.LROsCustomHeader.PostAsyncRetrySucceededWithHttpMessagesAsync(
                                    new Product { Location = "West US" }, customHeaders).Result);

                Assert.NotNull(client.LROsCustomHeader.Put201CreatingSucceeded200WithHttpMessagesAsync(
                                    new Product { Location = "West US" }, customHeaders).Result);

                Assert.NotNull(client.LROsCustomHeader.Post202Retry200WithHttpMessagesAsync(
                                    new Product { Location = "West US" }, customHeaders).Result);
            }
        }

        [Fact]
        public void LroSadPathTests()
        {
            using (
                var client = new AutoRestLongRunningOperationTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                client.LongRunningOperationRetryTimeout = 0;
                var exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PutNonRetry400(new Product {Location = "West US"}));
                Assert.Contains("Expected", exception.Message, StringComparison.Ordinal);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PutNonRetry201Creating400(new Product {Location = "West US"}));
                Assert.Equal("Error from the server", exception.Body.Message);
                Assert.NotNull(exception.Request);
                Assert.NotNull(exception.Response);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PutAsyncRelativeRetry400(new Product {Location = "West US"}));
                Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
                exception = Assert.Throws<CloudException>(() => client.LROSADs.DeleteNonRetry400());
                Assert.Contains("Expected", exception.Message, StringComparison.Ordinal);
                exception = Assert.Throws<CloudException>(() => client.LROSADs.Delete202NonRetry400());
                Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
                exception = Assert.Throws<CloudException>(() => client.LROSADs.DeleteAsyncRelativeRetry400());
                Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PostNonRetry400(new Product {Location = "West US"}));
                Assert.Equal("Expected bad request message", exception.Message);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.Post202NonRetry400(new Product {Location = "West US"}));
                Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PostAsyncRelativeRetry400(new Product {Location = "West US"}));
                Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PutError201NoProvisioningStatePayload(new Product {Location = "West US"}));
                Assert.Equal("The response from long running operation does not contain a body.", exception.Message);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PutAsyncRelativeRetryNoStatus(new Product {Location = "West US"}));
                Assert.Equal("The response from long running operation does not contain a body.", exception.Message);
                exception =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PutAsyncRelativeRetryNoStatusPayload(new Product {Location = "West US"}));
                Assert.Equal("The response from long running operation does not contain a body.", exception.Message);

                Assert.Throws<CloudException>(() => client.LROSADs.Put200InvalidJson(new Product {Location = "West US"}));

                Assert.Throws<CloudException>(
                    () => client.LROSADs.PutAsyncRelativeRetryInvalidJsonPolling(new Product {Location = "West US"}));
                // TODO: 4103936 Fix exception type
#if !PORTABLE
                Assert.Throws<RestException>(
                    () => client.LROSADs.PutAsyncRelativeRetryInvalidHeader(new Product {Location = "West US"}));
                // TODO: 4103936 Fix exception type
                // UriFormatException invalidHeader = null;
                var invalidHeader = Assert.Throws<UriFormatException>(() => client.LROSADs.Delete202RetryInvalidHeader());
                Assert.NotNull(invalidHeader.Message);

                // TODO: 4103936 Fix exception type
                var invalidAsyncHeader =
                    Assert.Throws<UriFormatException>(() => client.LROSADs.DeleteAsyncRelativeRetryInvalidHeader());
                Assert.NotNull(invalidAsyncHeader.Message);

                // TODO: 4103936 Fix exception type
                invalidHeader = Assert.Throws<UriFormatException>(() => client.LROSADs.Post202RetryInvalidHeader());
                Assert.NotNull(invalidHeader.Message);
                // TODO: 4103936 Fix exception type
                invalidAsyncHeader =
                    Assert.Throws<UriFormatException>(() => client.LROSADs.PostAsyncRelativeRetryInvalidHeader());
                Assert.NotNull(invalidAsyncHeader.Message);
#endif
                var invalidPollingBody =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.DeleteAsyncRelativeRetryInvalidJsonPolling());
                Assert.NotNull(invalidPollingBody.Message);

                invalidPollingBody =
                    Assert.Throws<CloudException>(
                        () => client.LROSADs.PostAsyncRelativeRetryInvalidJsonPolling());
                Assert.NotNull(invalidPollingBody.Message);

                client.LROSADs.Delete204Succeeded();
                var noStatusInPollingBody =
                    Assert.Throws<CloudException>(() => client.LROSADs.DeleteAsyncRelativeRetryNoStatus());
                Assert.Equal("The response from long running operation does not contain a body.",
                    noStatusInPollingBody.Message);

                var invalidOperationEx = Assert.Throws<CloudException>(() => client.LROSADs.Post202NoLocation());
                Assert.Contains("Location header is missing from long running operation.", invalidOperationEx.Message,
                    StringComparison.Ordinal);
                exception = Assert.Throws<CloudException>(() => client.LROSADs.PostAsyncRelativeRetryNoPayload());
                Assert.Equal("The response from long running operation does not contain a body.", exception.Message);
            }
        }

        [Fact]
        public void PagingHappyPathTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("paging.json"), ExpectedPath("Paging"), generator: "Azure.CSharp");
            using (
                var client = new AutoRestPagingTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                Assert.Null(client.Paging.GetSinglePages().NextPageLink);

                var result = client.Paging.GetMultiplePages();
                Assert.NotNull(result.NextPageLink);
                int count = 1;
                while (result.NextPageLink != null)
                {
                    result = client.Paging.GetMultiplePagesNext(result.NextPageLink);
                    count++;
                }
                Assert.Equal(10, count);

                result = client.Paging.GetMultiplePagesRetryFirst();
                Assert.NotNull(result.NextPageLink);
                count = 1;
                while (result.NextPageLink != null)
                {
                    result = client.Paging.GetMultiplePagesRetryFirstNext(result.NextPageLink);
                    count++;
                }
                Assert.Equal(10, count);

                result = client.Paging.GetMultiplePagesRetrySecond();
                Assert.NotNull(result.NextPageLink);
                count = 1;
                while (result.NextPageLink != null)
                {
                    result = client.Paging.GetMultiplePagesRetrySecondNext(result.NextPageLink);
                    count++;
                }
                Assert.Equal(10, count);
            }
        }

        [Fact]
        public void PagingSadPathTests()
        {
            using (
                var client = new AutoRestPagingTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                Assert.Throws<CloudException>(() => client.Paging.GetSinglePagesFailure());

                var result = client.Paging.GetMultiplePagesFailure();
                Assert.NotNull(result.NextPageLink);
                Assert.Throws<CloudException>(() => client.Paging.GetMultiplePagesFailureNext(result.NextPageLink));

                result = client.Paging.GetMultiplePagesFailureUri();
                Assert.Throws<UriFormatException>(() => client.Paging.GetMultiplePagesFailureUriNext(result.NextPageLink));
            }
        }

        public void EnsureTestCoverage()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("azure-report.json"), ExpectedPath("AzureReport"), generator: "Azure.CSharp");
            using (var client =
                new AutoRestReportServiceForAzure(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                var report = client.GetReport();
#if PORTABLE
                float totalTests = report.Count - 5;
#else
                float totalTests = report.Count;
#endif
                float executedTests = report.Values.Count(v => v > 0);
                if (executedTests < totalTests)
                {
                    foreach (var r in report)
                    {
                        _interceptor.Information(string.Format(CultureInfo.CurrentCulture,
                            Resources.TestCoverageReportItemFormat, r.Key, r.Value));
                    }
                    _interceptor.Information(string.Format(CultureInfo.CurrentCulture,
                        Resources.TestCoverageReportSummaryFormat,
                        executedTests, totalTests));
                    Assert.Equal(executedTests, totalTests);
                }
            }
        }

        [Fact]
        public void ResourceFlatteningGenerationTest()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("resource-flattening.json"), ExpectedPath("ResourceFlattening"), generator: "Azure.CSharp");
        }

        [Fact]
        public void ResourceFlatteningArrayTests()
        {
            using (
                var client = new AutoRestResourceFlatteningTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                //Array
                var result = client.GetArray();
                Assert.Equal(3, result.Count);
                // Resource 1
                Assert.Equal("1", result[0].Id);
                Assert.Equal("OK", result[0].ProvisioningStateValues);
                Assert.Equal("Product1", result[0].Pname);
                Assert.Equal("Flat", result[0].FlattenedProductType);
                Assert.Equal("Building 44", result[0].Location);
                Assert.Equal("Resource1", result[0].Name);
                Assert.Equal("Succeeded", result[0].ProvisioningState);
                Assert.Equal("Microsoft.Web/sites", result[0].Type);
                Assert.Equal("value1", result[0].Tags["tag1"]);
                Assert.Equal("value3", result[0].Tags["tag2"]);
                // Resource 2
                Assert.Equal("2", result[1].Id);
                Assert.Equal("Resource2", result[1].Name);
                Assert.Equal("Building 44", result[1].Location);
                // Resource 3
                Assert.Equal("3", result[2].Id);
                Assert.Equal("Resource3", result[2].Name);

                var resourceArray = new List<Fixtures.Azure.AcceptanceTestsResourceFlattening.Models.Resource>();
                resourceArray.Add(new FlattenedProduct
                {
                    Location = "West US",
                    Tags = new Dictionary<string, string>()
                    {
                        {"tag1", "value1"},
                        {"tag2", "value3"}
                    }
                });
                resourceArray.Add(new FlattenedProduct
                {
                    Location = "Building 44"
                });

                client.PutArray(resourceArray);
            }
        }

        [Fact]
        public void ResourceFlatteningDictionaryTests()
        {
            using (
                var client = new AutoRestResourceFlatteningTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                //Dictionary
                var resultDictionary = client.GetDictionary();
                Assert.Equal(3, resultDictionary.Count);
                // Resource 1
                Assert.Equal("1", resultDictionary["Product1"].Id);
                Assert.Equal("OK", resultDictionary["Product1"].ProvisioningStateValues);
                Assert.Equal("Product1", resultDictionary["Product1"].Pname);
                Assert.Equal("Flat", resultDictionary["Product1"].FlattenedProductType);
                Assert.Equal("Building 44", resultDictionary["Product1"].Location);
                Assert.Equal("Resource1", resultDictionary["Product1"].Name);
                Assert.Equal("Succeeded", resultDictionary["Product1"].ProvisioningState);
                Assert.Equal("Microsoft.Web/sites", resultDictionary["Product1"].Type);
                Assert.Equal("value1", resultDictionary["Product1"].Tags["tag1"]);
                Assert.Equal("value3", resultDictionary["Product1"].Tags["tag2"]);
                // Resource 2
                Assert.Equal("2", resultDictionary["Product2"].Id);
                Assert.Equal("Resource2", resultDictionary["Product2"].Name);
                Assert.Equal("Building 44", resultDictionary["Product2"].Location);
                // Resource 3
                Assert.Equal("3", resultDictionary["Product3"].Id);
                Assert.Equal("Resource3", resultDictionary["Product3"].Name);

                var resourceDictionary = new Dictionary<string, FlattenedProduct>();
                resourceDictionary.Add("Resource1", new FlattenedProduct
                {
                    Location = "West US",
                    Tags = new Dictionary<string, string>()
                    {
                        {"tag1", "value1"},
                        {"tag2", "value3"}
                    },
                    Pname = "Product1",
                    FlattenedProductType = "Flat"
                });
                resourceDictionary.Add("Resource2", new FlattenedProduct
                {
                    Location = "Building 44",
                    Pname = "Product2",
                    FlattenedProductType = "Flat"
                });

                client.PutDictionary(resourceDictionary);
            }
        }

        [Fact]
        public void ResourceFlatteningComplexObjectTests()
        {
            using (
                var client = new AutoRestResourceFlatteningTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                //ResourceCollection
                var resultResource = client.GetResourceCollection();

                //Dictionaryofresources
                Assert.Equal(3, resultResource.Dictionaryofresources.Count);
                // Resource 1
                Assert.Equal("1", resultResource.Dictionaryofresources["Product1"].Id);
                Assert.Equal("OK", resultResource.Dictionaryofresources["Product1"].ProvisioningStateValues);
                Assert.Equal("Product1", resultResource.Dictionaryofresources["Product1"].Pname);
                Assert.Equal("Flat", resultResource.Dictionaryofresources["Product1"].FlattenedProductType);
                Assert.Equal("Building 44", resultResource.Dictionaryofresources["Product1"].Location);
                Assert.Equal("Resource1", resultResource.Dictionaryofresources["Product1"].Name);
                Assert.Equal("Succeeded", resultResource.Dictionaryofresources["Product1"].ProvisioningState);
                Assert.Equal("Microsoft.Web/sites", resultResource.Dictionaryofresources["Product1"].Type);
                Assert.Equal("value1", resultResource.Dictionaryofresources["Product1"].Tags["tag1"]);
                Assert.Equal("value3", resultResource.Dictionaryofresources["Product1"].Tags["tag2"]);
                // Resource 2
                Assert.Equal("2", resultResource.Dictionaryofresources["Product2"].Id);
                Assert.Equal("Resource2", resultResource.Dictionaryofresources["Product2"].Name);
                Assert.Equal("Building 44", resultResource.Dictionaryofresources["Product2"].Location);
                // Resource 3
                Assert.Equal("3", resultResource.Dictionaryofresources["Product3"].Id);
                Assert.Equal("Resource3", resultResource.Dictionaryofresources["Product3"].Name);

                //Arrayofresources
                Assert.Equal(3, resultResource.Arrayofresources.Count);
                // Resource 1
                Assert.Equal("4", resultResource.Arrayofresources[0].Id);
                Assert.Equal("OK", resultResource.Arrayofresources[0].ProvisioningStateValues);
                Assert.Equal("Product4", resultResource.Arrayofresources[0].Pname);
                Assert.Equal("Flat", resultResource.Arrayofresources[0].FlattenedProductType);
                Assert.Equal("Building 44", resultResource.Arrayofresources[0].Location);
                Assert.Equal("Resource4", resultResource.Arrayofresources[0].Name);
                Assert.Equal("Succeeded", resultResource.Arrayofresources[0].ProvisioningState);
                Assert.Equal("Microsoft.Web/sites", resultResource.Arrayofresources[0].Type);
                Assert.Equal("value1", resultResource.Arrayofresources[0].Tags["tag1"]);
                Assert.Equal("value3", resultResource.Arrayofresources[0].Tags["tag2"]);
                // Resource 2
                Assert.Equal("5", resultResource.Arrayofresources[1].Id);
                Assert.Equal("Resource5", resultResource.Arrayofresources[1].Name);
                Assert.Equal("Building 44", resultResource.Arrayofresources[1].Location);
                // Resource 3
                Assert.Equal("6", resultResource.Arrayofresources[2].Id);
                Assert.Equal("Resource6", resultResource.Arrayofresources[2].Name);

                //productresource
                Assert.Equal("7", resultResource.Productresource.Id);
                Assert.Equal("Resource7", resultResource.Productresource.Name);

                var resourceDictionary = new Dictionary<string, FlattenedProduct>();
                resourceDictionary.Add("Resource1", new FlattenedProduct
                {
                    Location = "West US",
                    Tags = new Dictionary<string, string>()
                    {
                        {"tag1", "value1"},
                        {"tag2", "value3"}
                    },
                    Pname = "Product1",
                    FlattenedProductType = "Flat"
                });
                resourceDictionary.Add("Resource2", new FlattenedProduct
                {
                    Location = "Building 44",
                    Pname = "Product2",
                    FlattenedProductType = "Flat"
                });

                var resourceComplexObject = new ResourceCollection()
                {
                    Dictionaryofresources = resourceDictionary,
                    Arrayofresources = new List<FlattenedProduct>()
                    {
                        new FlattenedProduct()
                        {
                            Location = "West US",
                            Tags = new Dictionary<string, string>()
                            {
                                {"tag1", "value1"},
                                {"tag2", "value3"}
                            },
                            Pname = "Product1",
                            FlattenedProductType = "Flat"
                        },
                        new FlattenedProduct()
                        {
                            Location = "East US",
                            Pname = "Product2",
                            FlattenedProductType = "Flat"
                        }
                    },
                    Productresource = new FlattenedProduct()
                    {
                        Location = "India",
                        Pname = "Azure",
                        FlattenedProductType = "Flat"
                    }
                };
                client.PutResourceCollection(resourceComplexObject);
            }
        }

        [Fact]
        public void AzureSpecialParametersTests()
        {
            var validSubscription = "1234-5678-9012-3456";
            var validApiVersion = "2.0";
            var unencodedPath = "path1/path2/path3";
            var unencodedQuery = "value1&q2=value2&q3=value3";
            SwaggerSpecRunner.RunTests(
                SwaggerPath("azure-special-properties.json"), ExpectedPath("AzureSpecials"), generator: "Azure.CSharp");
            using (
                var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString()))
                    { SubscriptionId = validSubscription })
            {
                client.SubscriptionInCredentials.PostMethodGlobalNotProvidedValid();
                client.SubscriptionInCredentials.PostMethodGlobalValid();
                client.SubscriptionInCredentials.PostPathGlobalValid();
                client.SubscriptionInCredentials.PostSwaggerGlobalValid();
                client.SubscriptionInMethod.PostMethodLocalValid(validSubscription);
                client.SubscriptionInMethod.PostPathLocalValid(validSubscription);
                client.SubscriptionInMethod.PostSwaggerLocalValid(validSubscription);
                Assert.Throws<ValidationException>(() => client.SubscriptionInMethod.PostMethodLocalNull(null));

                client.ApiVersionDefault.GetMethodGlobalNotProvidedValid();
                client.ApiVersionDefault.GetMethodGlobalValid();
                client.ApiVersionDefault.GetPathGlobalValid();
                client.ApiVersionDefault.GetSwaggerGlobalValid();
                client.ApiVersionLocal.GetMethodLocalValid(validApiVersion);
                client.ApiVersionLocal.GetMethodLocalNull(null);
                client.ApiVersionLocal.GetPathLocalValid(validApiVersion);
                client.ApiVersionLocal.GetSwaggerLocalValid(validApiVersion);

                client.SkipUrlEncoding.GetMethodPathValid(unencodedPath);
                client.SkipUrlEncoding.GetPathPathValid(unencodedPath);
                client.SkipUrlEncoding.GetSwaggerPathValid(unencodedPath);
                client.SkipUrlEncoding.GetMethodQueryValid(unencodedQuery);
                client.SkipUrlEncoding.GetPathQueryValid(unencodedQuery);
                client.SkipUrlEncoding.GetSwaggerQueryValid(unencodedQuery);
                client.SkipUrlEncoding.GetMethodQueryNull();
                client.SkipUrlEncoding.GetMethodQueryNull(null);
            }
        }

        [Fact]
        public void AzureODataTests()
        {
            var validSubscription = "1234-5678-9012-3456";
            SwaggerSpecRunner.RunTests(
                SwaggerPath("azure-special-properties.json"), ExpectedPath("AzureSpecials"), generator: "Azure.CSharp");
            using (var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString()))
                { SubscriptionId = validSubscription })
            {
                var filter = new ODataQuery<OdataFilter>(f => f.Id > 5 && f.Name == "foo")
                {
                    Top = 10,
                    OrderBy = "id"
                };
                Assert.Equal("$filter=id gt 5 and name eq 'foo'&$orderby=id&$top=10", filter.ToString());
                client.Odata.GetWithFilter(filter);
            }
        }

        [Fact]
        public void XmsRequestClientIdTest()
        {
            var validSubscription = "1234-5678-9012-3456";
            var validClientId = "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0";
            using (var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
                    new TokenCredentials(validSubscription, Guid.NewGuid().ToString()))
                    { SubscriptionId = validSubscription })
            {
                Dictionary<string, List<string>> customHeaders = new Dictionary<string, List<string>>();
                customHeaders["x-ms-client-request-id"] = new List<string> { validClientId };
                var result1 = client.XMsClientRequestId.GetWithHttpMessagesAsync(customHeaders)
                    .ConfigureAwait(true).GetAwaiter().GetResult();
                Assert.Equal("123", result1.RequestId);

                var result2 = client.XMsClientRequestId.ParamGetWithHttpMessagesAsync(validClientId)
                    .ConfigureAwait(false).GetAwaiter().GetResult();
                Assert.Equal("123", result2.RequestId);
            }
        }

        [Fact]
        public void CustomNamedRequestIdTest()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("azure-special-properties.json"), ExpectedPath("AzureSpecials"), generator: "Azure.CSharp");
            
            const string validSubscription = "1234-5678-9012-3456";
            const string expectedRequestId = "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0";

            using (var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
                new TokenCredentials(validSubscription, Guid.NewGuid().ToString())))
            {
                IAzureOperationResponse response = client.Header.CustomNamedRequestIdWithHttpMessagesAsync(expectedRequestId).Result;

                Assert.Equal("123", response.RequestId);
            }
        }

        [Fact]
        public void DurationTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-duration.json"), ExpectedPath("AzureBodyDuration"), generator: "Azure.CSharp");
            const string validSubscription = "1234-5678-9012-3456";

            using (var client = new AutoRestDurationTestService(Fixture.Uri,
                new TokenCredentials(validSubscription, Guid.NewGuid().ToString())))
            {
                Assert.Null(client.Duration.GetNull());
                Assert.Throws<FormatException>(() => client.Duration.GetInvalid());

                client.Duration.GetPositiveDuration();
                client.Duration.PutPositiveDuration(new TimeSpan(123, 22, 14, 12, 11));
            }
        }
        
        [Fact]
        public void ParameterGroupingTests()
        {
            const int bodyParameter = 1234;
            const string headerParameter = "header";
            const int queryParameter = 21;
            const string pathParameter = "path";

            using (var client = new AutoRestParameterGroupingTestService(
                Fixture.Uri,
                new TokenCredentials(Guid.NewGuid().ToString())))
            {
                //Valid required parameters
                ParameterGroupingPostRequiredParameters requiredParameters = new ParameterGroupingPostRequiredParameters(bodyParameter, pathParameter)
                {
                    CustomHeader = headerParameter,
                    Query = queryParameter
                };

                client.ParameterGrouping.PostRequired(requiredParameters);

                //Required parameters but null optional parameters
                requiredParameters = new ParameterGroupingPostRequiredParameters(bodyParameter, pathParameter);

                client.ParameterGrouping.PostRequired(requiredParameters);

                //Required parameters object is not null, but a required property of the object is
                requiredParameters = new ParameterGroupingPostRequiredParameters(null, pathParameter);

                Assert.Throws<ValidationException>(() => client.ParameterGrouping.PostRequired(requiredParameters));

                //null required parameters
                Assert.Throws<ValidationException>(() => client.ParameterGrouping.PostRequired(null));

                //Valid optional parameters
                ParameterGroupingPostOptionalParameters optionalParameters = new ParameterGroupingPostOptionalParameters()
                {
                    CustomHeader = headerParameter,
                    Query = queryParameter
                };

                client.ParameterGrouping.PostOptional(optionalParameters);

                //null optional paramters
                client.ParameterGrouping.PostOptional(null);

                //Multiple grouped parameters
                FirstParameterGroup firstGroup = new FirstParameterGroup
                {
                    HeaderOne = headerParameter,
                    QueryOne = queryParameter
                };
                var secondGroup = new ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup
                {
                    HeaderTwo = "header2",
                    QueryTwo = 42
                };

                client.ParameterGrouping.PostMultipleParameterGroups(firstGroup, secondGroup);

                //Multiple grouped parameters -- some optional parameters omitted
                firstGroup = new FirstParameterGroup
                {
                    HeaderOne = headerParameter
                };
                secondGroup = new ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup
                {
                    QueryTwo = 42
                };

                client.ParameterGrouping.PostMultipleParameterGroups(firstGroup, secondGroup);

                client.ParameterGrouping.PostSharedParameterGroupObject(firstGroup);
            }
        }
    }
}
