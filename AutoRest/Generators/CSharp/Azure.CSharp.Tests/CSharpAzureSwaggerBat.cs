// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.


// TODO: file length is getting excessive.
using System;
using System.Net;
using System.Net.PeerToPeer;
using System.Threading.Tasks;
using System.Collections.Generic;
using Fixtures.Azure.SwaggerBatAzureSpecials;
using Fixtures.Azure.SwaggerBatLro.Models;
using Fixtures.Azure.SwaggerBatLro;
using Fixtures.Azure.SwaggerBatPaging;
using Fixtures.Azure.SwaggerBatReport;
using Microsoft.Azure;
using Microsoft.Rest.Generator.CSharp.Tests;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.Tests;
using Newtonsoft.Json;
using System.Diagnostics;
using System.Linq;
using Xunit;
using Xunit.Abstractions;
using Error = Fixtures.SwaggerBatHttp.Models.Error;
using Fixtures.Azure.SwaggerBatResourceFlattening;
using Fixtures.Azure.SwaggerBatResourceFlattening.Models;
using Fixtures.Azure.SwaggerBatHead;

namespace Microsoft.Rest.Generator.CSharp.Azure.Tests
{
    [Collection("AutoRest Tests")]
    [TestCaseOrderer("Microsoft.Rest.Generator.CSharp.Tests.SwaggerBatTestOrderer",
        "AutoRest.Generator.CSharp.Tests")]
    public class CSharpAzureSwaggerBat : IClassFixture<ServiceController>
    {
        private readonly ITestOutputHelper _output;

        public CSharpAzureSwaggerBat(ServiceController data, ITestOutputHelper output)
        {
            this.Fixture = data;
            _output = output;
        }

        public ServiceController Fixture { get; set; }

        [Fact]
        public void HeadTests()
        {
            SwaggerSpecHelper.RunTests<AzureCSharpCodeGenerator>(
                @"Swagger\head.json", @"Expected\SwaggerBat\Head.cs");

            var client = new AutoRestHeadTestService(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));
            Assert.True(client.HttpSuccess.Head204());
            Assert.False(client.HttpSuccess.Head404());
        }

        [Fact]
        public void LroHappyPathTests()
        {
            SwaggerSpecHelper.RunTests<AzureCSharpCodeGenerator>(
                @"Swagger\lro.json", @"Expected\SwaggerBat\Lro.cs");
            var client = new AutoRestLongRunningOperationTestService(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));
            client.LongRunningOperationRetryTimeout = 0;
            
            Assert.Equal("Succeeded", client.LROs.Put201CreatingSucceeded200(new Product { Location = "West US" }).ProvisioningState);
            var exception = Assert.Throws<CloudException>(() => client.LROs.Put201CreatingFailed200(new Product { Location = "West US" }));

            Assert.Contains("Long running operation failed", exception.Message);
            Assert.Equal("Succeeded", client.LROs.Put200UpdatingSucceeded204(new Product { Location = "West US" }).ProvisioningState);
            exception = Assert.Throws<CloudException>(() => client.LROs.Put200Acceptedcanceled200(new Product { Location = "West US" }).ProvisioningState);
            Assert.Contains("Long running operation failed", exception.Message);
            client.LROs.Post202Retry200(new Product {Location = "West US"});
            Assert.Equal("Succeeded", client.LROs.Put200Succeeded(new Product { Location = "West US" }).ProvisioningState);
            Assert.Equal("100", client.LROs.Put200SucceededNoState(new Product { Location = "West US" }).Id);
            Assert.Equal("100", client.LROs.Put202Retry200(new Product { Location = "West US" }).Id);
            Assert.Equal("Succeeded", client.LROs.PutAsyncRetrySucceeded(new Product { Location = "West US" }).ProvisioningState);
            Assert.Equal("Succeeded", client.LROs.PutAsyncNoRetrySucceeded(new Product { Location = "West US" }).ProvisioningState);
            exception = Assert.Throws<CloudException>(() => client.LROs.PutAsyncRetryFailed(new Product { Location = "West US" }));
            Assert.Contains("Long running operation failed", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROs.PutAsyncNoRetrycanceled(new Product { Location = "West US" }));
            Assert.Contains("Long running operation failed", exception.Message);
            client.LROs.Delete204Succeeded();
            client.LROs.Delete202Retry200();
            client.LROs.Delete202NoRetry204();
            client.LROs.DeleteAsyncNoRetrySucceeded();
            exception = Assert.Throws<CloudException>(() => client.LROs.DeleteAsyncRetrycanceled());
            Assert.Contains("Long running operation failed", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROs.DeleteAsyncRetryFailed());
            Assert.Contains("Long running operation failed", exception.Message);
            client.LROs.DeleteAsyncRetrySucceeded();
            client.LROs.DeleteProvisioning202Accepted200Succeeded();
            client.LROs.DeleteProvisioning202Deletingcanceled200();
            client.LROs.DeleteProvisioning202DeletingFailed200();
            client.LROs.Post202NoRetry204(new Product { Location = "West US" });
            exception = Assert.Throws<CloudException>(() => client.LROs.PostAsyncRetryFailed());
            Assert.Contains("Long running operation failed with status 'Failed'", exception.Message);
            Assert.NotNull(exception.Body);
            var error = exception.Body;
            Assert.NotNull(error.Code);
            Assert.NotNull(error.Message);
            exception = Assert.Throws<CloudException>(() => client.LROs.PostAsyncRetrycanceled());
            Assert.Contains("Long running operation failed with status 'Canceled'", exception.Message);
            client.LROs.PostAsyncRetrySucceeded();
            client.LROs.PostAsyncNoRetrySucceeded();
            client.LROs.PostAsyncNoRetrySucceeded();
            var sku = client.LROs.Post200WithPayload();
            Assert.Equal("1", sku.Id);
            // Retryable errors
            Assert.Equal("Succeeded", client.LRORetrys.Put201CreatingSucceeded200(new Product { Location = "West US" }).ProvisioningState);
            Assert.Equal("Succeeded", client.LRORetrys.PutAsyncRelativeRetrySucceeded(new Product { Location = "West US" }).ProvisioningState);
            client.LRORetrys.DeleteProvisioning202Accepted200Succeeded();
            client.LRORetrys.Delete202Retry200();
            client.LRORetrys.DeleteAsyncRelativeRetrySucceeded();
            client.LRORetrys.Post202Retry200(new Product { Location = "West US" });
            client.LRORetrys.PostAsyncRelativeRetrySucceeded(new Product { Location = "West US" });
        }

        [Fact]
        public void LroSadPathTests()
        {
            var client = new AutoRestLongRunningOperationTestService(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));
            client.LongRunningOperationRetryTimeout = 0;
            var exception = Assert.Throws<CloudException>(() => client.LROSADs.PutNonRetry400(new Product { Location = "West US" }));
            Assert.Contains("Expected", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.PutNonRetry201Creating400(new Product { Location = "West US" }));
            Assert.Equal("Error from the server", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.PutAsyncRelativeRetry400(new Product { Location = "West US" }));
            Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.DeleteNonRetry400());
            Assert.Contains("Expected", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.Delete202NonRetry400());
            Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.DeleteAsyncRelativeRetry400());
            Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.PostNonRetry400(new Product { Location = "West US" }));
            Assert.Equal("Expected bad request message", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.Post202NonRetry400(new Product { Location = "West US" }));
            Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.PostAsyncRelativeRetry400(new Product { Location = "West US" }));
            Assert.Equal("Long running operation failed with status 'BadRequest'.", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.PutError201NoProvisioningStatePayload(new Product { Location = "West US" }));
            Assert.Equal("The response from long running operation does not contain a body.", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.PutAsyncRelativeRetryNoStatus(new Product { Location = "West US" }));
            Assert.Equal("The response from long running operation does not contain a body.", exception.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.PutAsyncRelativeRetryNoStatusPayload(new Product {Location = "West US"}));
            Assert.Equal("The response from long running operation does not contain a body.", exception.Message);
            
            Assert.Throws<CloudException>(() => client.LROSADs.Put200InvalidJson(new Product { Location = "West US" }));
            // TODO: 4103936 Fix exception type
            Assert.Throws<UriFormatException>(() => client.LROSADs.PutAsyncRelativeRetryInvalidHeader(new Product { Location = "West US" }));
            // TODO: 4103936 Fix exception type
            Assert.Throws<JsonSerializationException>(() => client.LROSADs.PutAsyncRelativeRetryInvalidJsonPolling(new Product { Location = "West US" }));
            // TODO: 4103936 Fix exception type
            var invalidHeader = Assert.Throws<UriFormatException>(() => client.LROSADs.Delete202RetryInvalidHeader());
            Assert.NotNull(invalidHeader.Message);
            // TODO: 4103936 Fix exception type
            var invalidAsyncHeader = Assert.Throws<UriFormatException>(() => client.LROSADs.DeleteAsyncRelativeRetryInvalidHeader());
            Assert.NotNull(invalidAsyncHeader.Message);
            // TODO: 4103936 Fix exception type
            var invalidPollingBody = Assert.Throws<JsonSerializationException>(() => client.LROSADs.DeleteAsyncRelativeRetryInvalidJsonPolling());
            Assert.NotNull(invalidPollingBody.Message);
            // TODO: 4103936 Fix exception type
            invalidHeader = Assert.Throws<UriFormatException>(() => client.LROSADs.Post202RetryInvalidHeader());
            Assert.NotNull(invalidHeader.Message);
            // TODO: 4103936 Fix exception type
            invalidAsyncHeader = Assert.Throws<UriFormatException>(() => client.LROSADs.PostAsyncRelativeRetryInvalidHeader());
            Assert.NotNull(invalidAsyncHeader.Message);
            // TODO: 4103936 Fix exception type
            invalidPollingBody = Assert.Throws<JsonSerializationException>(() => client.LROSADs.PostAsyncRelativeRetryInvalidJsonPolling());
            Assert.NotNull(invalidPollingBody.Message);

            client.LROSADs.Delete204Succeeded();
            var noStatusInPollingBody = Assert.Throws<CloudException>(() =>client.LROSADs.DeleteAsyncRelativeRetryNoStatus());
            Assert.Equal("The response from long running operation does not contain a body.", noStatusInPollingBody.Message);
            
            var invalidOperationEx = Assert.Throws<CloudException>(() => client.LROSADs.Post202NoLocation());
            Assert.Contains("Location header is missing from long running operation.", invalidOperationEx.Message);
            exception = Assert.Throws<CloudException>(() => client.LROSADs.PostAsyncRelativeRetryNoPayload());
            Assert.Equal("The response from long running operation does not contain a body.", exception.Message);
        }

        [Fact]
        public void PagingHappyPathTests()
        {
            SwaggerSpecHelper.RunTests<AzureCSharpCodeGenerator>(
                @"Swagger\paging.json", @"Expected\SwaggerBat\Paging.cs");
            var client = new AutoRestPagingTestService(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));
            
            Assert.Null(client.Paging.GetSinglePages().NextLink);

            var result = client.Paging.GetMultiplePages();
            Assert.NotNull(result.NextLink);
            int count = 1;
            while (result.NextLink != null)
            {
                result = client.Paging.GetMultiplePagesNext(result.NextLink);
                count++;
            }
            Assert.Equal(10, count);

            result = client.Paging.GetMultiplePagesRetryFirst();
            Assert.NotNull(result.NextLink);
            count = 1;
            while (result.NextLink != null)
            {
                result = client.Paging.GetMultiplePagesRetryFirstNext(result.NextLink);
                count++;
            }
            Assert.Equal(10, count);

            result = client.Paging.GetMultiplePagesRetrySecond();
            Assert.NotNull(result.NextLink);
            count = 1;
            while (result.NextLink != null)
            {
                result = client.Paging.GetMultiplePagesRetrySecondNext(result.NextLink);
                count++;
            }
            Assert.Equal(10, count);
        }

        [Fact]
        public void PagingSadPathTests()
        {
            var client = new AutoRestPagingTestService(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));
            
            Assert.Throws<CloudException>(() => client.Paging.GetSinglePagesFailure());

            var result = client.Paging.GetMultiplePagesFailure();
            Assert.NotNull(result.NextLink);
            Assert.Throws<CloudException>(() => client.Paging.GetMultiplePagesFailureNext(result.NextLink));

            result = client.Paging.GetMultiplePagesFailureUri();
            Assert.Throws<UriFormatException>(() => client.Paging.GetMultiplePagesFailureUriNext(result.NextLink));
        }

        /// <summary>
        /// This test should not be run standalone. It calculates test coverage and will fail if not executed after entire test suite. 
        /// </summary>
        [Trait("Report", "true")]
        [Fact]
        public void EnsureTestCoverage()
        {
            SwaggerSpecHelper.RunTests<AzureCSharpCodeGenerator>(
                @"Swagger\azure-report.json", @"Expected\SwaggerBat\Report.Cs");
            var client =
                new AutoRestReportServiceForAzure(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));
            var report = client.GetReport();
            float totalTests = report.Count;
            float executedTests = report.Values.Count(v => v > 0);
            if (executedTests < totalTests)
            {
                report.ForEach(r => _output.WriteLine(string.Format("{0}:{1}.", r.Key, r.Value)));
                _output.WriteLine(string.Format("The test coverage for Azure is {0}/{1}.", executedTests, totalTests));
                Assert.Equal(executedTests, totalTests);
            }
        }

        [Fact]
        public void ResourceFlatteningGenerationTest()
        {
            SwaggerSpecHelper.RunTests<AzureCSharpCodeGenerator>(
                @"Swagger\resource-flattening.json", @"Expected\SwaggerBat\ResourceFlattening.cs");
        }

        [Fact]
        public void ResourceFlatteningArrayTests()
        {
            var client = new AutoRestResourceFlatteningTestService(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));

            //Array
            var result = client.GetArray();
            Assert.Equal(3, result.Count);
            // Resource 1
            Assert.Equal("1", result[0].Id);
            Assert.Equal("OK", result[0].ProvisioningStateValues);
            Assert.Equal("Product1", result[0].Pname);
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

            var resourceArray = new List<Resource>();
            resourceArray.Add(new FlattenedProduct
            {
                Location = "West US",
                Tags = new Dictionary<string, string>() {
                    {"tag1", "value1"},
                    {"tag2", "value3"}
                },
                Pname = "Product1"
            });
            resourceArray.Add(new FlattenedProduct
            {
                Location = "Building 44",
                Pname = "Product2"
            });

            client.PutArray(resourceArray);
        }

        [Fact]
        public void ResourceFlatteningDictionaryTests()
        {
            var client = new AutoRestResourceFlatteningTestService(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));

            //Dictionary
            var resultDictionary = client.GetDictionary();
            Assert.Equal(3, resultDictionary.Count);
            // Resource 1
            Assert.Equal("1", resultDictionary["Product1"].Id);
            Assert.Equal("OK", resultDictionary["Product1"].ProvisioningStateValues);
            Assert.Equal("Product1", resultDictionary["Product1"].Pname);
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
                Tags = new Dictionary<string, string>() {
                    {"tag1", "value1"},
                    {"tag2", "value3"}
                },
                Pname = "Product1"
            });
            resourceDictionary.Add("Resource2", new FlattenedProduct
            {
                Location = "Building 44",
                Pname = "Product2"
            });

            client.PutDictionary(resourceDictionary);
        }

        [Fact]
        public void ResourceFlatteningComplexObjectTests()
        {
            var client = new AutoRestResourceFlatteningTestService(Fixture.Uri, new TokenCloudCredentials(Guid.NewGuid().ToString(), Guid.NewGuid().ToString()));
            
            //ResourceCollection
            var resultResource = client.GetResourceCollection();

            //Dictionaryofresources
            Assert.Equal(3, resultResource.Dictionaryofresources.Count);
            // Resource 1
            Assert.Equal("1", resultResource.Dictionaryofresources["Product1"].Id);
            Assert.Equal("OK", resultResource.Dictionaryofresources["Product1"].ProvisioningStateValues);
            Assert.Equal("Product1", resultResource.Dictionaryofresources["Product1"].Pname);
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
                Tags = new Dictionary<string, string>() {
                    {"tag1", "value1"},
                    {"tag2", "value3"}
                },
                Pname = "Product1"
            });
            resourceDictionary.Add("Resource2", new FlattenedProduct
            {
                Location = "Building 44",
                Pname = "Product2"
            });

            var resourceComplexObject = new ResourceCollection()
            {
                Dictionaryofresources = resourceDictionary,
                Arrayofresources = new List<FlattenedProduct>()
                {
                    new FlattenedProduct()
                    {
                        Location = "West US",
                        Tags = new Dictionary<string, string>() {
                            {"tag1", "value1"},
                            {"tag2", "value3"}
                        },
                        Pname = "Product1"
                    },
                    new FlattenedProduct()
                    {
                        Location = "East US",
                        Pname = "Product2"
                    }
                },
                Productresource = new FlattenedProduct()
                {
                    Location = "India",
                    Pname = "Azure"
                }
            };
            client.PutResourceCollection(resourceComplexObject);
        }

        [Fact]
        public void AzureSpecialParametersTests()
        {
            var validSubscription = "1234-5678-9012-3456";
            var validApiVersion = "2.0";
            var unencodedPath = "path1/path2/path3";
            var unencodedQuery = "value1&q2=value2&q3=value3";
            SwaggerSpecHelper.RunTests<AzureCSharpCodeGenerator>(
                @"Swagger\azure-special-properties.json", @"Expected\SwaggerBat\AzureSpecials.Cs");
            var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri, new TokenCloudCredentials(validSubscription, Guid.NewGuid().ToString()));
            client.SubscriptionInCredentials.PostMethodGlobalNotProvidedValid();
            client.SubscriptionInCredentials.PostMethodGlobalValid();
            client.SubscriptionInCredentials.PostPathGlobalValid();
            client.SubscriptionInCredentials.PostSwaggerGlobalValid();
            Assert.Throws<ArgumentNullException>(
                () =>
                    new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
                        new TokenCloudCredentials(null, Guid.NewGuid().ToString())));
            client.SubscriptionInMethod.PostMethodLocalValid(validSubscription);
            client.SubscriptionInMethod.PostPathLocalValid(validSubscription);
            client.SubscriptionInMethod.PostSwaggerLocalValid(validSubscription);
            Assert.Throws<ArgumentNullException>(() => client.SubscriptionInMethod.PostMethodLocalNull(null));

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

        private static void EnsureStatusCode(HttpStatusCode expectedStatusCode, Func<Task<HttpOperationResponse>> operation)
        {
            var response = operation().GetAwaiter().GetResult();
            Assert.Equal(response.Response.StatusCode, expectedStatusCode);
        }
        private void EnsureStatusCode<T>(HttpStatusCode expectedStatusCode, Func<Task<HttpOperationResponse<T>>> operation)
        {
            var response = operation().GetAwaiter().GetResult();
            Assert.Equal(response.Response.StatusCode, expectedStatusCode);
        }

        private static void EnsureThrowsWithStatusCode(HttpStatusCode expectedStatusCode,
            Action operation, Action<Error> errorValidator = null)
        {
            EnsureThrowsWithErrorModel<Error>(expectedStatusCode, operation, errorValidator);
        }

        private static void EnsureThrowsWithErrorModel<T>(HttpStatusCode expectedStatusCode,
            Action operation, Action<T> errorValidator = null) where T : class
        {
            try
            {
                operation();
                throw new InvalidOperationException("Operation did not throw as expected");
            }
            catch (HttpOperationException exception)
            {
                Assert.Equal(expectedStatusCode, exception.Response.StatusCode);
                if (errorValidator != null)
                {
                    errorValidator(exception.Body as T);
                }
            }
        }

        private static Action<Error> GetDefaultErrorValidator(int code, string message)
        {
            return (e) =>
            {
                Assert.Equal(code, e.Status);
                Assert.Equal(message, e.Message);
            };
        }

        private static void EnsureThrowsWithStatusCodeAndError(HttpStatusCode expectedStatusCode,
            Action operation, string expectedMessage)
        {
            EnsureThrowsWithStatusCode(expectedStatusCode, operation, GetDefaultErrorValidator((int)expectedStatusCode, expectedMessage));
        }
    }
}