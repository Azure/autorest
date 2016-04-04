// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace Microsoft.Rest.ClientRuntime.Tests.Fakes
{
    public class MirrorDelegatingHandler : DelegatingHandler
    {
        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,
            System.Threading.CancellationToken cancellationToken)
        {
            HttpStatusCode responseCode = HttpStatusCode.OK;
            IEnumerable<string> headerValues = null;
            if (request.Headers.TryGetValues("response-code", out headerValues))
            {
                Enum.TryParse(headerValues.First(), out responseCode);
            }

            var response = new HttpResponseMessage(responseCode);

            // multipart content
            if (request.Content.IsMimeMultipartContent("mixed"))
            {
                var requestContents = await request.Content.ReadAsMultipartAsync();
                string boundary = "mirror_" + Guid.NewGuid().ToString();
                var batchContent = new MultipartContent("mixed", boundary);
                for (int i = 0; i < requestContents.Contents.Count; i++)
                {
                    var innerResponse = new HttpResponseMessage(responseCode);
                    innerResponse.Content = new StringContent(await requestContents.Contents[i].ReadAsStringAsync());
                    batchContent.Add(new HttpMessageContent(innerResponse));
                }

                response.Content = batchContent;
            }
            // simple string content
            else
            {
                var requestContent = await request.Content.ReadAsStringAsync();
                response.Content = new StringContent(requestContent);
            }

            return response;
        }
    }
}