// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Net;
using System.Net.Http;
using Xunit;
using Xunit.Extensions;

namespace Microsoft.Rest.Test
{
    public class HttpOperationExceptionTest
    {
        private HttpResponseMessage notFoundResponse;
        private HttpResponseMessage serverErrorResponse;
        private HttpResponseMessage serverErrorResponseWithCamelCase;
        private HttpResponseMessage serverErrorResponseWithParent;
        private HttpResponseMessage serverErrorResponseWithParent2;
        private string genericMessageString = "{'key'='value'}";
        private string jsonErrorMessageString = @"{
                    'code': 'BadRequest',
                    'message': 'The provided database ‘foo’ has an invalid username.',
                    'target': 'query',
                    'details': [
                        {
                        'code': '301',
                        'target': '$search',
                        'message': '$search query option not supported.',
                        }
                    ]
                }";
        private string jsonErrorMessageStringWithCamelCase = @"{
                    'Code': 'BadRequest',
                    'Message': 'The provided database ‘foo’ has an invalid username.',
                    'Target': 'query',
                    'Details': [
                        {
                        'Code': '301',
                        'Target': '$search',
                        'Message': '$search query option not supported.',
                        }
                    ]
                }";
        private string jsonErrorMessageWithParent = @"{
                    'error' : {
                        'code': 'BadRequest',
                        'message': 'The provided database ‘foo’ has an invalid username.',
                        'target': 'query',
                        'details': [
                        {
                            'code': '301',
                            'target': '$search',
                            'message': '$search query option not supported.',
                        }
                        ]
                    }
                }";
        private string jsonErrorMessageWithParent2 = @"{'error':{'code':'ResourceGroupNotFound','message':
                'Resource group `ResourceGroup_crosoftAwillAofferAmoreAWebAservicemnopqrstuvwxyz1` could not be found.'}}";

        private HttpRequestMessage genericMessage;
        private HttpRequestMessage genericMessageWithoutBody;

        public HttpOperationExceptionTest()
        {
            genericMessage = new HttpRequestMessage(HttpMethod.Get, "http//test/url");
            genericMessage.Content = new StringContent(genericMessageString);
            genericMessageWithoutBody = new HttpRequestMessage(HttpMethod.Get, "http//test/url");
            notFoundResponse = new HttpResponseMessage(HttpStatusCode.NotFound);
            notFoundResponse.Headers.Add("x-ms-request-id", "content1");
            notFoundResponse.Headers.Add("x-ms-routing-request-id", "content2");

            notFoundResponse.Content = new StreamContent(new MemoryStream());
            serverErrorResponse = new HttpResponseMessage(HttpStatusCode.InternalServerError);
            serverErrorResponse.Content = new StringContent(jsonErrorMessageString);
            serverErrorResponseWithCamelCase = new HttpResponseMessage(HttpStatusCode.InternalServerError);
            serverErrorResponseWithCamelCase.Content = new StringContent(jsonErrorMessageStringWithCamelCase);
            serverErrorResponseWithParent = new HttpResponseMessage(HttpStatusCode.InternalServerError);
            serverErrorResponseWithParent.Content = new StringContent(jsonErrorMessageWithParent);
            serverErrorResponseWithParent2 = new HttpResponseMessage(HttpStatusCode.NotFound);
            serverErrorResponseWithParent2.Content = new StringContent(jsonErrorMessageWithParent2);
        }

        [Fact]
        public void ExceptionIsCreatedFromHeaderlessResponse()
        {
            var ex = HttpOperationException.Create(genericMessage, genericMessageString, notFoundResponse, "");

            Assert.Null(notFoundResponse.Content.Headers.ContentType);
            Assert.NotNull(ex);
        }

        [Fact]
        public void ExceptionIsCreatedFromNullResponseString()
        {
            var ex = HttpOperationException.Create(genericMessage, genericMessageString, notFoundResponse, null);

            Assert.Null(notFoundResponse.Content.Headers.ContentType);
            Assert.NotNull(ex);
        }

        [Fact]
        public void ExceptionContainsHttpStatusCodeIfBodyIsEmpty()
        {
            var ex = HttpOperationException.Create(genericMessage, genericMessageString, notFoundResponse, "");

            Assert.Equal("Not Found", ex.Message);
        }

        [Fact]
        public void JsonExceptionIsParsedCorrectlyWithLowerCase()
        {
            var ex = HttpOperationException.Create(genericMessage, genericMessageString, serverErrorResponse, jsonErrorMessageString);

            Assert.Equal(jsonErrorMessageString, ex.Message);
        }

        [Fact]
        public void JsonExceptionIsParsedCorrectlyWithCamelCase()
        {
            var ex = HttpOperationException.Create(genericMessage, genericMessageString, serverErrorResponseWithCamelCase,
                                           jsonErrorMessageStringWithCamelCase);

            Assert.Equal(jsonErrorMessageStringWithCamelCase, ex.Message);
        }

        [Fact]
        public void JsonExceptionIsParsedCorrectlyWithParent()
        {
            var ex = HttpOperationException.Create(genericMessage, genericMessageString, serverErrorResponseWithParent,
                                           jsonErrorMessageWithParent);

            Assert.Equal(jsonErrorMessageWithParent, ex.Message);
        }

        [Fact]
        public void JsonExceptionIsParsedCorrectlyWithoutMessageBody()
        {
            var ex = HttpOperationException.Create(genericMessageWithoutBody, null, serverErrorResponseWithParent2, jsonErrorMessageWithParent2);

            Assert.Equal(jsonErrorMessageWithParent2, ex.Message);
        }

        [Fact]
        public void ParseJsonErrorSupportsFlatErrors()
        {
            string message = @"{
                                    'code': 'BadRequest',
                                    'message': 'The provided database ‘foo’ has an invalid username.',
                                    'target': 'query',
                                    'details': [
                                      {
                                       'code': '301',
                                       'target': '$search',
                                       'message': '$search query option not supported.',
                                      }
                                    ]
                                }";

            var error = HttpOperationException.Create(message);

            Assert.Equal(message, error.Message);
        }

        [Fact]
        public void ParseJsonErrorDeepErrors()
        {
            string message = @"{
                                    'error' : {
                                        'code': 'BadRequest',
                                        'message': 'The provided database ‘foo’ has an invalid username.',
                                        'target': 'query',
                                        'details': [
                                        {
                                            'code': '301',
                                            'target': '$search',
                                            'message': '$search query option not supported.',
                                        }
                                        ]
                                    }
                                }";

            var error = HttpOperationException.Create(message);

            Assert.Equal(message, error.Message);
        }

        [Fact]
        public void ParseJsonErrorSupportsEmptyErrors()
        {
            Assert.Equal("Operation is not valid due to the current state of the object.", HttpOperationException.Create(string.Empty).Message);
        }

        [Theory]
        [InlineData(@"{'some error' : {'some message': 'The provided database ‘foo’ has an invalid username.',}}")]
        [InlineData(@"{'error' : {'some message': 'The provided database ‘foo’ has an invalid username.',}}")]
        [InlineData(@"{'error' : {'some message': 'The provided database ‘foo’ has an invalid username.'")]
        public void ParseJsonErrorSupportsIncorrectlyFormattedJsonErrors(string message)
        {
            var error = HttpOperationException.Create(message);

            Assert.Equal(message, error.Message);
        }

        [Fact]
        public void ParseXmlErrorSupportsErrorsWithCamelCase()
        {
            string message = @"<Error>
                                        <Code>BadRequest</Code>
                                        <Message>The provided database ‘foo’ has an invalid username.</Message>
                                    </Error>";

            var error = HttpOperationException.Create(message);
            Assert.Equal(message, error.Message);
        }

        [Fact]
        public void ParseXmlErrorSupportsErrorsWithLowerCase()
        {
            string message = @"<error>
                                        <code>BadRequest</code>
                                        <message>The provided database ‘foo’ has an invalid username.</message>
                                    </error>";

            var error = HttpOperationException.Create(message);
            Assert.Equal(message, error.Message);
        }

        [Fact]
        public void ParseXmlErrorSupportsEmptyErrors()
        {
            Assert.Equal("Operation is not valid due to the current state of the object.", 
                HttpOperationException.Create(null).Message);
            Assert.Equal("Operation is not valid due to the current state of the object.", 
                HttpOperationException.Create(string.Empty).Message);
        }

        [Fact]
        public void ParseXmlErrorIgnoresParentElement()
        {
            string xmlErrorMessageWithBadParent = @"<SomeError>
                                        <Code>BadRequest</Code>
                                        <Message>The provided database ‘foo’ has an invalid username.</Message>
                                    </SomeError>";

            Assert.Equal(xmlErrorMessageWithBadParent, HttpOperationException.Create(xmlErrorMessageWithBadParent).Message);
        }

        [Theory]
        [InlineData("<error><some-message>The provided database ‘foo’ has an invalid username.</some-message></error>")]
        [InlineData("<some-error><some-message>The provided database ‘foo’ has an invalid username.</some-message></some-error>")]
        [InlineData("<some-error><some-message>The provided database ‘foo’ has an invalid username.")]
        [InlineData(@"<Error><SomeCode>BadRequest</SomeCode><SomeMessage>The provided database ‘foo’ has an invalid username.</SomeMode></Error>}")]
        public void ParseXmlErrorSupportsIncorrectlyFormattedXmlErrors(string message)
        {
            var error = HttpOperationException.Create(message);
            Assert.Equal(message, error.Message);
        }
    }
}
