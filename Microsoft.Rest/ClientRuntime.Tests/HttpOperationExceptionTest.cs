// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Net;
using System.Net.Http;
using Xunit;
using Xunit.Extensions;

namespace Microsoft.Rest.ClientRuntime.Tests
{
    public class HttpOperationExceptionTest
    {
        private HttpResponseMessage notFoundResponse;
        private string genericMessageString = "{'key'='value'}";
        private HttpRequestMessage genericMessage;

        public HttpOperationExceptionTest()
        {
            genericMessage = new HttpRequestMessage(HttpMethod.Get, "http//test/url");
            genericMessage.Content = new StringContent(genericMessageString);
            notFoundResponse = new HttpResponseMessage(HttpStatusCode.NotFound);
            notFoundResponse.Headers.Add("x-ms-request-id", "content1");
            notFoundResponse.Headers.Add("x-ms-routing-request-id", "content2");

            notFoundResponse.Content = new StreamContent(new MemoryStream());
        }

        [Fact]
        public void ExceptionIsCreatedFromHeaderlessResponse()
        {
            var ex = HttpOperationException<object>.Create(genericMessage, genericMessageString, notFoundResponse, "", null);

            Assert.Null(notFoundResponse.Content.Headers.ContentType);
            Assert.NotNull(ex);
        }

        [Fact]
        public void ExceptionIsCreatedFromNullResponseString()
        {
            var ex = HttpOperationException<object>.Create(genericMessage, genericMessageString, notFoundResponse, null, null);

            Assert.Null(notFoundResponse.Content.Headers.ContentType);
            Assert.NotNull(ex);
        }

        [Fact]
        public void ExceptionContainsHttpStatusCodeIfBodyIsEmpty()
        {
            var ex = HttpOperationException<object>.Create(genericMessage, genericMessageString, notFoundResponse, "", null);

            Assert.Equal("Not Found", ex.Message);
        }
    }
}
