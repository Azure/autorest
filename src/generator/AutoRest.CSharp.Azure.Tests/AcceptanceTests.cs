// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

// TODO: file length is getting excessive.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Net;
using System.Net.Http;
using Fixtures.Azure.AcceptanceTestsAzureBodyDuration;
using Fixtures.Azure.AcceptanceTestsAzureParameterGrouping;
using Fixtures.Azure.AcceptanceTestsAzureParameterGrouping.Models;
using Fixtures.Azure.AcceptanceTestsAzureReport;
using Fixtures.Azure.AcceptanceTestsAzureSpecials;
using Fixtures.Azure.AcceptanceTestsAzureSpecials.Models;
using Fixtures.Azure.AcceptanceTestsCustomBaseUri;
using Fixtures.Azure.AcceptanceTestsHead;
using Fixtures.Azure.AcceptanceTestsHeadExceptions;
using Fixtures.Azure.AcceptanceTestsLro;
using Fixtures.Azure.AcceptanceTestsLro.Models;
using Fixtures.Azure.AcceptanceTestsPaging;
using Fixtures.Azure.AcceptanceTestsSubscriptionIdApiVersion;
using Xunit;
using AutoRest.CSharp.Tests.Utilities;
using AutoRest.CSharp.Tests;
using Microsoft.Rest;
using Microsoft.Rest.Azure;
using Microsoft.Rest.Azure.OData;
using System.Linq;
using ValidationException = Microsoft.Rest.ValidationException;

namespace AutoRest.CSharp.Azure.Tests
{
    [Collection("AutoRest Tests")]
    [TestCaseOrderer("AutoRest.CSharp.Tests.AcceptanceTestOrderer",
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
        public void AzureCustomBaseUriTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("custom-baseUrl.json"), ExpectedPath("CustomBaseUri"), generator: "Azure.CSharp");
            using (var client = new AutoRestParameterizedHostTestClient(new TokenCredentials(Guid.NewGuid().ToString())))
            {
                // small modification to the "host" portion to include the port and the '.'
                client.Host = string.Format(CultureInfo.InvariantCulture, "{0}:{1}", client.Host, Fixture.Port);
                Assert.Equal(HttpStatusCode.OK,
                    client.Paths.GetEmptyWithHttpMessagesAsync("local").Result.Response.StatusCode);
            }
        }

        [Fact]
        public void AzureCustomBaseUriNegativeTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("custom-baseUrl.json"), ExpectedPath("CustomBaseUri"), generator: "Azure.CSharp");
            using (var client = new AutoRestParameterizedHostTestClient(new TokenCredentials(Guid.NewGuid().ToString())))
            {
                // use a bad acct name
                Assert.Throws<HttpRequestException>(() =>
                    client.Paths.GetEmpty("bad"));

                // pass in null
                Assert.Throws<ValidationException>(() => client.Paths.GetEmpty(null));

                // set the global parameter incorrectly
                client.Host = "badSuffix";
                Assert.Throws<HttpRequestException>(() =>
                    client.Paths.GetEmpty("local"));
            }
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
        public void HeadExceptionTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("head-exceptions.json"), ExpectedPath("HeadExceptions"), generator: "Azure.CSharp");

            using (
                var client = new AutoRestHeadExceptionTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                client.HeadException.Head200();
                client.HeadException.Head204();
                Assert.Throws<CloudException>(() => client.HeadException.Head404());
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
                Assert.Equal("Succeeded", client.LROs.PutSubResource(new SubProduct().ProvisioningState).ProvisioningState);
                Assert.Equal("Succeeded", client.LROs.PutAsyncSubResource(new SubProduct().ProvisioningState).ProvisioningState);
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

                client.LRORetrys.DeleteProvisioning202Accepted200Succeeded();
                client.LRORetrys.Delete202Retry200();
                client.LRORetrys.DeleteAsyncRelativeRetrySucceeded();

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

                Assert.NotNull(client.LROsCustomHeader.Post202Retry200WithHttpMessagesAsync(
                                    new Product { Location = "West US" }, customHeaders).Result);
            }
        }
#if PORTABLE
        [Fact(Skip = "Failing in CoreCLR - TODO: debug and fix")]
#else 
        [Fact]
#endif
        public void LroHappyPathTestsRest()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("lro.json"), ExpectedPath("Lro"), generator: "Azure.CSharp");
            using (
                var client = new AutoRestLongRunningOperationTestService(Fixture.Uri,
                    new TokenCredentials(Guid.NewGuid().ToString())))
            {
                client.LongRunningOperationRetryTimeout = 0;

                var customHeaders = new Dictionary<string, List<string>>
                {
                    {
                    "x-ms-client-request-id", new List<string> {"9C4D50EE-2D56-4CD3-8152-34347DC9F2B0"}
                    }
                };

                Assert.Equal("Succeeded",
                    client.LRORetrys.Put201CreatingSucceeded200(new Product { Location = "West US" }).ProvisioningState);
                Assert.Equal("Succeeded",
                    client.LRORetrys.PutAsyncRelativeRetrySucceeded(new Product { Location = "West US" }).ProvisioningState);
                client.LRORetrys.Post202Retry200(new Product { Location = "West US" });
                client.LRORetrys.PostAsyncRelativeRetrySucceeded(new Product { Location = "West US" });

                Assert.NotNull(client.LROsCustomHeader.Put201CreatingSucceeded200WithHttpMessagesAsync(
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
                    Assert.Throws<CloudException>(() => client.LROSADs.PutNonRetry201Creating400InvalidJson(new Product { Location = "West US" }));
                Assert.Null(exception.Body);
                Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
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
                
#if !PORTABLE
                Assert.Throws<SerializationException>(
                    () => client.LROSADs.PutAsyncRelativeRetryInvalidHeader(new Product {Location = "West US"}));
                
                // UriFormatException invalidHeader = null;
                var invalidHeader = Assert.Throws<SerializationException>(() => client.LROSADs.Delete202RetryInvalidHeader());
                Assert.NotNull(invalidHeader.Message);

                
                var invalidAsyncHeader =
                    Assert.Throws<SerializationException>(() => client.LROSADs.DeleteAsyncRelativeRetryInvalidHeader());
                Assert.NotNull(invalidAsyncHeader.Message);

                
                invalidHeader = Assert.Throws<SerializationException>(() => client.LROSADs.Post202RetryInvalidHeader());
                Assert.NotNull(invalidHeader.Message);
                
                invalidAsyncHeader =
                    Assert.Throws<SerializationException>(() => client.LROSADs.PostAsyncRelativeRetryInvalidHeader());
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

                result = client.Paging.GetOdataMultiplePages();
                Assert.NotNull(result.NextPageLink);
                count = 1;
                while (result.NextPageLink != null)
                {
                    result = client.Paging.GetOdataMultiplePagesNext(result.NextPageLink);
                    count++;
                }
                Assert.Equal(10, count);

                var options = new Fixtures.Azure.AcceptanceTestsPaging.Models.PagingGetMultiplePagesWithOffsetOptions();
                options.Offset = 100;
                result = client.Paging.GetMultiplePagesWithOffset(options, "client-id");
                Assert.NotNull(result.NextPageLink);
                count = 1;
                while (result.NextPageLink != null)
                {
                    result = client.Paging.GetMultiplePagesWithOffsetNext(result.NextPageLink);
                    count++;
                }
                Assert.Equal(10, count);
                Assert.Equal(110, result.LastOrDefault().Properties.Id);

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

                result = client.Paging.GetMultiplePagesFragmentNextLink("1.6", "test_user");
                Assert.NotNull(result.NextPageLink);
                count = 1;
                while (result.NextPageLink != null)
                {
                    result = client.Paging.NextFragment("1.6", "test_user", result.NextPageLink);
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
                float totalTests = report.Count - 6;
#else
                // TODO: This is fudging some numbers. Fixing the actual problem is a priority.
                float totalTests = report.Count;
#endif
                float executedTests = report.Values.Count(v => v > 0);
                if (executedTests < totalTests)
                {
                    foreach (var r in report.Where(r => r.Value == 0))
                    {
                        _interceptor.Information(string.Format(CultureInfo.CurrentCulture,
                            "{0}/{1}", r.Key, r.Value));
                    }
                    _interceptor.Information(string.Format(CultureInfo.CurrentCulture,
                        "The test coverage for Azure is {0}/{1}",
                        executedTests, totalTests));
                    Assert.Equal(totalTests,executedTests);
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
        public void AzureSpecialParametersTests()
        {
            var validSubscription = "1234-5678-9012-3456";
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
                client.ApiVersionLocal.GetMethodLocalValid();
                client.ApiVersionLocal.GetMethodLocalNull(null);
                client.ApiVersionLocal.GetPathLocalValid();
                client.ApiVersionLocal.GetSwaggerLocalValid();

                client.SkipUrlEncoding.GetMethodPathValid(unencodedPath);
                client.SkipUrlEncoding.GetPathPathValid(unencodedPath);
                client.SkipUrlEncoding.GetSwaggerPathValid();
                client.SkipUrlEncoding.GetMethodQueryValid(unencodedQuery);
                client.SkipUrlEncoding.GetPathQueryValid(unencodedQuery);
                client.SkipUrlEncoding.GetSwaggerQueryValid();
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
        public void XmsRequestClientIdInClientTest()
        {
            var validSubscription = "1234-5678-9012-3456";
            using (var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
                    new TokenCredentials(validSubscription, Guid.NewGuid().ToString()))
            { SubscriptionId = validSubscription })
            {
                client.GenerateClientRequestId = false;
                client.XMsClientRequestId.Get();
            }
        }

        [Fact]
        public void ClientRequestIdInExceptionTest()
        {
            var validSubscription = "1234-5678-9012-3456";
            using (var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
                    new TokenCredentials(validSubscription, Guid.NewGuid().ToString()))
            { SubscriptionId = validSubscription })
            {
                Dictionary<string, List<string>> customHeaders = new Dictionary<string, List<string>>();
                var exception = Assert.Throws<CloudException>(() => client.XMsClientRequestId.Get());
                Assert.Equal("123", exception.RequestId);                
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
        public void CustomNamedRequestIdParameterGroupingTest()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("azure-special-properties.json"), ExpectedPath("AzureSpecials"), generator: "Azure.CSharp");

            const string validSubscription = "1234-5678-9012-3456";
            const string expectedRequestId = "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0";

            using (var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
                new TokenCredentials(validSubscription, Guid.NewGuid().ToString())))
            {
                var group = new HeaderCustomNamedRequestIdParamGroupingParameters()
                    {
                        FooClientRequestId = expectedRequestId
                    };
                IAzureOperationResponse response = client.Header.CustomNamedRequestIdParamGroupingWithHttpMessagesAsync(group).Result;

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
                var secondGroup = new ParameterGroupingPostMultiParamGroupsSecondParamGroup
                {
                    HeaderTwo = "header2",
                    QueryTwo = 42
                };

                client.ParameterGrouping.PostMultiParamGroups(firstGroup, secondGroup);

                //Multiple grouped parameters -- some optional parameters omitted
                firstGroup = new FirstParameterGroup
                {
                    HeaderOne = headerParameter
                };
                secondGroup = new ParameterGroupingPostMultiParamGroupsSecondParamGroup
                {
                    QueryTwo = 42
                };

                client.ParameterGrouping.PostMultiParamGroups(firstGroup, secondGroup);

                client.ParameterGrouping.PostSharedParameterGroupObject(firstGroup);
            }
        }
    }
}
