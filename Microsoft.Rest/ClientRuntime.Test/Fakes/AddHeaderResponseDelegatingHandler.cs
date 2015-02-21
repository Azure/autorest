// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Net.Http;
using System.Threading.Tasks;

namespace Microsoft.Rest.Test.Fakes
{
    public class AddHeaderResponseDelegatingHandler : DelegatingHandler
    {
        public string HeaderName { get; set; }

        public string HeaderValue { get; set; }

        public AddHeaderResponseDelegatingHandler(string headerName, string headerValue)
        {
            HeaderName = headerName;
            HeaderValue = headerValue;
        }

        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, System.Threading.CancellationToken cancellationToken)
        {
            HttpResponseMessage response = await base.SendAsync(request, cancellationToken);
            response.Headers.Add(HeaderName, HeaderValue);
            return response;
        }
    }
}
