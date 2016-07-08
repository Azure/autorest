// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;

namespace AutoRest.CSharp.Tests.Utilities
{
    public class MirroringHandler : DelegatingHandler
    {

        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            var responseCode = HttpStatusCode.OK;
            IEnumerable<string> headerValues = null;
            if (request.Headers.TryGetValues("response-code", out headerValues))
            {
                responseCode = headerValues.First().ToStatusCode();
            }

            var requestContent = await request.Content.ReadAsStringAsync();
            var response = new HttpResponseMessage(responseCode);
            response.Content = new StringContent(requestContent);
            return response;
        }
    }
}