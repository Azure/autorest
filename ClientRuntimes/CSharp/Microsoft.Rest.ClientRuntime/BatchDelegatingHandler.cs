// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Rest
{
    /// <summary>
    /// HTTP batch handler.
    /// It expects the caller to dispose HttpRequestMessage and HttpResponseMessage.
    /// It assumes the web service is supporting batch requests as per this MSDN article:
    /// https://blogs.msdn.microsoft.com/webdev/2013/11/01/introducing-batch-support-in-web-api-and-web-api-odata/
    /// i.e. requests are batched into a single request inside the multipart content.
    /// </summary>
    public class BatchDelegatingHandler : DelegatingHandler
    {
        /// <summary>
        /// HTTP method (e.g. POST or PUT) to use in issuing a batch call
        /// </summary>
        private readonly HttpMethod batchMethod;

        /// <summary>
        /// URL to issue the batch call to
        /// </summary>
        private readonly Uri batchURL;

        /// <summary>
        /// List of operations to issue in a batch
        /// </summary>
        private List<HttpRequestMessage> requests;

        /// <summary>
        /// Array of HTTP content returned by the server in response to operations that are issued in a batch
        /// </summary>
        private HttpContent[] responses;

        /// <summary>
        /// Event that tells all tasks that they can proceed
        /// </summary>
        private ManualResetEvent batchCompleted;

        /// <summary>
        /// Initializes a new instance of the <see cref="BatchDelegatingHandler"/> class.
        /// </summary>
        /// <param name="method">the type of method that the Batch operation is</param>
        /// <param name="url">the URL that the Batch operation needs to hit</param>
        public BatchDelegatingHandler(HttpMethod method, Uri url)
        {
            this.batchMethod = method;
            this.batchURL = url;
            this.Reset();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BatchDelegatingHandler"/> class.
        /// </summary>
        /// <param name="method">the type of method that the Batch operation is</param>
        /// <param name="url">the URL that the Batch operation needs to hit</param>
        /// <param name="innerHandler">Inner HTTP handler</param>
        public BatchDelegatingHandler(HttpMethod method, Uri url, DelegatingHandler innerHandler)
            : base(innerHandler)
        {
            this.batchMethod = method;
            this.batchURL = url;
            this.Reset();
        }

        /// <summary>
        /// Resets the batch handler to accept a new set of batch requests
        /// </summary>
        public void Reset()
        {
            this.requests = new List<HttpRequestMessage>();
            this.responses = null;
            this.batchCompleted = new ManualResetEvent(false);
        }

        /// <summary>
        /// Send all the queued up requests as a single batch request to the inner handler.
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for the batch request</param>
        /// <param name="boundary">Optional string which will be used as the encapsulation boundary between each request in multipart content; if not specified, a random GUID will be used</param>
        /// <returns>Task for the batch</returns>
        public async Task IssueBatch(CancellationToken cancellationToken = default(CancellationToken), string boundary = null)
        {
            // There must be at least one request to issue
            if (this.requests.Count == 0)
            {
                throw new Exception("No queued requests to issue.");
            }

            // Sanity check. There must not be any queued responses from the server.
            if (this.responses != null)
            {
                throw new Exception("This batch handler instance has been reused without calling reset first.");
            }

            // Create a request to the batch URL
            HttpRequestMessage batchRequest = new HttpRequestMessage(this.batchMethod, this.batchURL);

            // Create the boundary
            if (string.IsNullOrEmpty(boundary))
            {
                boundary = "batch_" + Guid.NewGuid().ToString();
            }

            // Add a multipart content to the body of the request
            MultipartContent batchContent = new MultipartContent("mixed", boundary);
            batchRequest.Content = batchContent;

            // add each request to this batch request
            foreach (HttpRequestMessage message in this.requests)
            {
                batchContent.Add(new HttpMessageContent(message));
            }

            // send the batch request to the inner handler
            HttpResponseMessage batchResponse = await base.SendAsync(batchRequest, cancellationToken);

            // throw exceptions if the response is unexpected
            if (batchResponse == null)
            {
                throw new Exception("Batch request got back a null response.");
            }

            batchResponse.EnsureSuccessStatusCode();

            if (batchResponse.Content == null)
            {
                throw new Exception("Batch request got back a response with null content.");
            }

            if (!batchResponse.Content.IsMimeMultipartContent("mixed"))
            {
                throw new Exception("Batch response returned unexpected content type.");
            }

            // pull out the responses
            MultipartMemoryStreamProvider responseContents = await batchResponse.Content.ReadAsMultipartAsync();
            if (responseContents == null)
            {
                throw new Exception("Failed to convert response content into multipart components.");
            }

            if (responseContents.Contents.Count != this.requests.Count)
            {
                throw new Exception("Batch response returned " + responseContents.Contents.Count + " number of responses instead of the expected " + this.requests.Count + ".");
            }

            // copy the responses over into the array that is accessible by the tasks waiting for individual responses
            this.responses = new HttpContent[responseContents.Contents.Count];
            responseContents.Contents.CopyTo(this.responses, 0);

            // signal tasks that they can proceed with using the response
            this.batchCompleted.Set();
        }

        /// <summary>
        /// Queue an HTTP request that will be eventually sent to the inner handler when you call IssueBatch.
        /// DO NOT await nor access the result of the returned task until IssueBatch has been successfully awaited.
        /// </summary>
        /// <param name="request">HTTP request message to send to the server</param>
        /// <param name="cancellationToken">Not used</param>
        /// <returns>Task that when awaited will provide the HTTP response from the server</returns>
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            // Sanity check. There must not be any queued responses from the server.
            if (this.responses != null)
            {
                throw new Exception("This batch handler instance has been reused without calling reset first.");
            }

            // what is my queue position?
            int position = this.requests.Count;

            // add the request to the queue
            this.requests.Add(request);

            // send back a task that will return the appropriate value
            Task<HttpResponseMessage> task = Task<HttpResponseMessage>.Factory.StartNew(() => this.GetResponse(position));
            return task;
        }

        /// <summary>
        /// Wait for the batch call to finish and then return the requested response
        /// </summary>
        /// <param name="index">Which response to return</param>
        /// <returns>The HTTP response message inside the batch at the given index</returns>
        private HttpResponseMessage GetResponse(int index)
        {
            this.batchCompleted.WaitOne();
            return this.responses[index].ReadAsHttpResponseMessageAsync().Result;
        }
    }
}