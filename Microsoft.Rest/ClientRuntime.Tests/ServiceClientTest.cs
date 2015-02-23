// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using System.Net;
using System.Net.Http;
using Microsoft.Rest.ClientRuntime.Tests.Fakes;
using Microsoft.Rest.TransientFaultHandling;
using Xunit;

namespace Microsoft.Rest.ClientRuntime.Tests
{
    public class ServiceClientTest
    {
        [Fact]
        public void ClientAddHandlerToPipelineAddsHandler()
        {
            var fakeClient = new FakeServiceClient(new WebRequestHandler());
            var result1 = fakeClient.DoStuff();
            Assert.Equal(HttpStatusCode.OK, result1.Result.StatusCode);

            fakeClient = new FakeServiceClient(new WebRequestHandler(), new BadResponseDelegatingHandler());

            var result2 = fakeClient.DoStuff();
            Assert.Equal(HttpStatusCode.InternalServerError, result2.Result.StatusCode);
        }

        [Fact]
        public void ClientAddHandlersToPipelineAddSingleHandler()
        {
            var fakeClient = new FakeServiceClient(new WebRequestHandler());
            var result1 = fakeClient.DoStuff();
            Assert.Equal(HttpStatusCode.OK, result1.Result.StatusCode);

            fakeClient = new FakeServiceClient(new WebRequestHandler(),
                new BadResponseDelegatingHandler()
            );

            var result2 = fakeClient.DoStuff();
            Assert.Equal(HttpStatusCode.InternalServerError, result2.Result.StatusCode);
        }

        [Fact]
        public void ClientAddHandlersToPipelineAddMultipleHandler()
        {
            var fakeClient = new FakeServiceClient(new WebRequestHandler());
            var result1 = fakeClient.DoStuff();
            Assert.Equal(HttpStatusCode.OK, result1.Result.StatusCode);

            fakeClient = new FakeServiceClient( new WebRequestHandler(), 
                 new AddHeaderResponseDelegatingHandler("foo", "bar"),
               new BadResponseDelegatingHandler()
            );

            var result2 = fakeClient.DoStuff();
            Assert.Equal(result2.Result.Headers.GetValues("foo").FirstOrDefault(), "bar");
            Assert.Equal(HttpStatusCode.InternalServerError, result2.Result.StatusCode);
        }

        [Fact]
        public void RetryHandlerRetriesWith500Errors()
        {
            var fakeClient = new FakeServiceClient(new FakeHttpHandler());
            int attemptsFailed = 0;

            fakeClient.SetRetryPolicy(new RetryPolicy<HttpStatusCodeErrorDetectionStrategy>(2));
            var retryHandler = fakeClient.GetHttpPipeline().OfType<RetryDelegatingHandler>().FirstOrDefault();
            retryHandler.Retrying += (sender, args) => { attemptsFailed++; };

            var result = fakeClient.DoStuff();
            Assert.Equal(HttpStatusCode.InternalServerError, result.Result.StatusCode);
            Assert.Equal(2, attemptsFailed);
        }

        [Fact]
        public void RetryHandlerRetriesWith500ErrorsAndSucceeds()
        {
            var fakeClient = new FakeServiceClient(new FakeHttpHandler() { NumberOfTimesToFail = 1 });
            int attemptsFailed = 0;

            fakeClient.SetRetryPolicy(new RetryPolicy<HttpStatusCodeErrorDetectionStrategy>(2));
            var retryHandler = fakeClient.GetHttpPipeline().OfType<RetryDelegatingHandler>().FirstOrDefault();
            retryHandler.Retrying += (sender, args) => { attemptsFailed++; };

            var result = fakeClient.DoStuff();
            Assert.Equal(HttpStatusCode.OK, result.Result.StatusCode);
            Assert.Equal(1, attemptsFailed);
        }

        [Fact]
        public void RetryHandlerDoesntRetryFor400Errors()
        {
            var fakeClient = new FakeServiceClient(new FakeHttpHandler() { StatusCodeToReturn = HttpStatusCode.Conflict });
            int attemptsFailed = 0;

            fakeClient.SetRetryPolicy(new RetryPolicy<HttpStatusCodeErrorDetectionStrategy>(2));
            var retryHandler = fakeClient.GetHttpPipeline().OfType<RetryDelegatingHandler>().FirstOrDefault();
            retryHandler.Retrying += (sender, args) => { attemptsFailed++; };

            var result = fakeClient.DoStuff();
            Assert.Equal(HttpStatusCode.Conflict, result.Result.StatusCode);
            Assert.Equal(0, attemptsFailed);
        }
    }
}
