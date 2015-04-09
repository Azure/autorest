// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Rest.ClientRuntime.Tests.Fakes
{
    public class FakeServiceClient : ServiceClient<FakeServiceClient>
    {
        private ServiceClientCredentials _clientCredentials;

        public FakeServiceClient()
        {
            // Prevent base constructor from executing
        }

        public FakeServiceClient(HttpClientHandler httpMessageHandler, params DelegatingHandler[] handlers)
            : base(httpMessageHandler, handlers)
        {
        }

        public FakeServiceClient(
                        HttpClientHandler httpMessageHandler, 
                        ServiceClientCredentials credentials, 
                        params DelegatingHandler[] handlers)
                            : this(httpMessageHandler, handlers)
        {
            _clientCredentials = credentials;
        }


        public async Task<HttpResponseMessage> DoStuff(string content = null)
        {
            // Construct URL
            string url = "http://www.microsoft.com";

            // Create HTTP transport objects
            HttpRequestMessage httpRequest = null;

            httpRequest = new HttpRequestMessage();
            httpRequest.Method = HttpMethod.Get;
            httpRequest.RequestUri = new Uri(url);

            // Set content
            if (content != null)
            {
                httpRequest.Content = new StringContent(content);
            }

            // Set Headers
            httpRequest.Headers.Add("x-ms-version", "2013-11-01");

            // Set Credentials
            var cancellationToken = new CancellationToken();
            if (_clientCredentials != null)
            {
                await _clientCredentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            }
            cancellationToken.ThrowIfCancellationRequested();
            return await this.HttpClient.SendAsync(httpRequest, cancellationToken).ConfigureAwait(false);
        }

        public void DoStuffSync()
        {
            Task.Factory.StartNew(() =>
            {
                return DoStuff();
            }).Unwrap().GetAwaiter().GetResult();
        }
    }
}
