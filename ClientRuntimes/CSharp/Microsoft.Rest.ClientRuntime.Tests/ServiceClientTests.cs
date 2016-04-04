// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Rest.ClientRuntime.Tests.Fakes;
using Microsoft.Rest.TransientFaultHandling;
using Xunit;

namespace Microsoft.Rest.ClientRuntime.Tests
{
    public class ServiceClientTests
    {
        [Fact]
        public void ClientAddHandlerToPipelineAddsHandler()
        {
            var fakeClient = new FakeServiceClient(new HttpClientHandler(), new BadResponseDelegatingHandler());
            var result2 = fakeClient.DoStuffSync();
            Assert.Equal(HttpStatusCode.InternalServerError, result2.StatusCode);
        }

        [Fact]
        public void ClientAddHandlersToPipelineAddSingleHandler()
        {
            var fakeClient = new FakeServiceClient(new HttpClientHandler(),
                new BadResponseDelegatingHandler()
                );

            var result2 = fakeClient.DoStuffSync();
            Assert.Equal(HttpStatusCode.InternalServerError, result2.StatusCode);
        }

        [Fact]
        public void ClientAddHandlersToPipelineAddMultipleHandler()
        {
            var fakeClient = new FakeServiceClient(new HttpClientHandler(),
                new AddHeaderResponseDelegatingHandler("foo", "bar"),
                new BadResponseDelegatingHandler()
                );

            var result2 = fakeClient.DoStuffSync();
            Assert.Equal(result2.Headers.GetValues("foo").FirstOrDefault(), "bar");
            Assert.Equal(HttpStatusCode.InternalServerError, result2.StatusCode);
        }

        [Fact]
        public void ClientAddHandlersToPipelineChainsEmptyHandler()
        {
            var handlerA = new AppenderDelegatingHandler("A");
            var handlerB = new AppenderDelegatingHandler("B");
            var handlerC = new AppenderDelegatingHandler("C");

            var fakeClient = new FakeServiceClient(new HttpClientHandler(),
                handlerA, handlerB, handlerC,
                new MirrorDelegatingHandler());

            var response = fakeClient.DoStuffSync("Text").Content.ReadAsStringAsync().ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal("Text+A+B+C", response);
        }

        [Fact]
        public void ClientAddHandlersToPipelineChainsNestedHandler()
        {
            var handlerA = new AppenderDelegatingHandler("A");
            var handlerB = new AppenderDelegatingHandler("B");
            var handlerC = new AppenderDelegatingHandler("C");
            handlerA.InnerHandler = handlerB;
            handlerB.InnerHandler = handlerC;
            var handlerD = new AppenderDelegatingHandler("D");
            var handlerE = new AppenderDelegatingHandler("E");
            handlerD.InnerHandler = handlerE;
            handlerE.InnerHandler = new MirrorMessageHandler("F");

            var fakeClient = new FakeServiceClient(new HttpClientHandler(),
                handlerA, handlerD,
                new MirrorDelegatingHandler());

            var response = fakeClient.DoStuffSync("Text").Content.ReadAsStringAsync().ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal("Text+A+B+C+D+E", response);
        }

        [Fact]
        public void ClientWithoutHandlerWorks()
        {
            var fakeClient = new FakeServiceClient(new HttpClientHandler(),
                new MirrorDelegatingHandler());

            var response = fakeClient.DoStuffSync("Text").Content.ReadAsStringAsync().ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal("Text", response);
        }

        [Fact]
        public async Task BatchHandlerWorks()
        {
            // instantiate batch handler to test and a mirror handler that will help with testing
            MirrorDelegatingHandler mirrorHandler = new MirrorDelegatingHandler();
            BatchDelegatingHandler batchHandler = new BatchDelegatingHandler(HttpMethod.Post, new Uri("http://localhost/batch"));

            // put them in order in an array
            DelegatingHandler[] handlers = new DelegatingHandler[2];
            handlers[0] = batchHandler;   // this will be the innder handler
            handlers[1] = mirrorHandler;  // this will be the outer handler; this is the last handler before the request goes to the server

            // instantiate the fake client with these handlers
            var fakeClient = new FakeServiceClient(new HttpClientHandler(), handlers);

            // add three requests to the batch queue
            Task<HttpResponseMessage> requestTask1 = fakeClient.DoStuff("one");
            Task<HttpResponseMessage> requestTask2 = fakeClient.DoStuff("two");
            Task<HttpResponseMessage> requestTask3 = fakeClient.DoStuff("three");

            // now issue the batch call
            await batchHandler.IssueBatch();

            // get the responses from the individual requests
            HttpResponseMessage response1 = await requestTask1;
            HttpResponseMessage response2 = await requestTask2;
            HttpResponseMessage response3 = await requestTask3;

            // check the response codes
            Assert.True(response1.IsSuccessStatusCode);
            Assert.True(response2.IsSuccessStatusCode);
            Assert.True(response3.IsSuccessStatusCode);

            // check the response bodies
            string responseBody1 = await response1.Content.ReadAsStringAsync();
            string responseBody2 = await response2.Content.ReadAsStringAsync();
            string responseBody3 = await response3.Content.ReadAsStringAsync();
            Assert.True(responseBody1.EndsWith("one"));
            Assert.True(responseBody2.EndsWith("two"));
            Assert.True(responseBody3.EndsWith("three"));
        }

        [Fact]
        public void RetryHandlerRetriesWith500Errors()
        {
            var fakeClient = new FakeServiceClient(new FakeHttpHandler());
            int attemptsFailed = 0;

            var retryPolicy = new RetryPolicy<HttpStatusCodeErrorDetectionStrategy>(2);
            fakeClient.SetRetryPolicy(retryPolicy);
            var retryHandler = fakeClient.HttpMessageHandlers.OfType<RetryDelegatingHandler>().FirstOrDefault();
            retryPolicy.Retrying += (sender, args) => { attemptsFailed++; };

            var result = fakeClient.DoStuffSync();
            Assert.Equal(HttpStatusCode.InternalServerError, result.StatusCode);
            Assert.Equal(2, attemptsFailed);
        }

        [Fact]
        public void RetryHandlerRetriesWith500ErrorsAndSucceeds()
        {
            var fakeClient = new FakeServiceClient(new FakeHttpHandler() {NumberOfTimesToFail = 1});
            int attemptsFailed = 0;

            var retryPolicy = new RetryPolicy<HttpStatusCodeErrorDetectionStrategy>(2);
            fakeClient.SetRetryPolicy(retryPolicy);
            var retryHandler = fakeClient.HttpMessageHandlers.OfType<RetryDelegatingHandler>().FirstOrDefault();
            retryPolicy.Retrying += (sender, args) => { attemptsFailed++; };

            var result = fakeClient.DoStuffSync();
            Assert.Equal(HttpStatusCode.OK, result.StatusCode);
            Assert.Equal(1, attemptsFailed);
        }

        [Fact]
        public void RetryHandlerDoesntRetryFor400Errors()
        {
            var fakeClient = new FakeServiceClient(new FakeHttpHandler() {StatusCodeToReturn = HttpStatusCode.Conflict});
            int attemptsFailed = 0;

            var retryPolicy = new RetryPolicy<HttpStatusCodeErrorDetectionStrategy>(2);
            fakeClient.SetRetryPolicy(retryPolicy);
            var retryHandler = fakeClient.HttpMessageHandlers.OfType<RetryDelegatingHandler>().FirstOrDefault();
            retryPolicy.Retrying += (sender, args) => { attemptsFailed++; };

            var result = fakeClient.DoStuffSync();
            Assert.Equal(HttpStatusCode.Conflict, result.StatusCode);
            Assert.Equal(0, attemptsFailed);
        }

        [Fact]
        public void HeadersAndPayloadAreNotDisposed()
        {
            FakeServiceClient fakeClient = null;
            try
            {
                fakeClient = new FakeServiceClient(new HttpClientHandler(),
                     new MirrorDelegatingHandler());
                var response = fakeClient.DoStuffAndThrowSync("Text");
                Assert.True(false);
            }
            catch (HttpOperationException ex)
            {
                fakeClient.Dispose();
                fakeClient = null;
                GC.Collect();
                Assert.NotNull(ex.Request);
                Assert.NotNull(ex.Response);
                Assert.Equal("2013-11-01", ex.Request.Headers["x-ms-version"].First());
                Assert.Equal("Text", ex.Response.Content);
            }
        }
    }
}