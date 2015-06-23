using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest;
using Newtonsoft.Json;
using Fixtures.SwaggerBatHttp.Models;

namespace Fixtures.SwaggerBatHttp
{
    internal partial class HttpRedirect : IServiceOperations<AutoRestHttpInfrastructureTestService>, IHttpRedirect
    {
        /// <summary>
        /// Initializes a new instance of the HttpRedirect class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        internal HttpRedirect(AutoRestHttpInfrastructureTestService client)
        {
            this.Client = client;
        }

        /// <summary>
        /// Gets a reference to the AutoRestHttpInfrastructureTestService
        /// </summary>
        public AutoRestHttpInfrastructureTestService Client { get; private set; }

        /// <summary>
        /// Redirect get with 307
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> Get307WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get307", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri.TrimEnd('/') + 
                         "/http/redirect/307";
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("GET");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Send Request
            if (shouldTrace)
            {
                ServiceClientTracing.SendRequest(invocationId, httpRequest);
            }
            cancellationToken.ThrowIfCancellationRequested();
            HttpResponseMessage httpResponse = await this.Client.HttpClient.SendAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            if (shouldTrace)
            {
                ServiceClientTracing.ReceiveResponse(invocationId, httpResponse);
            }
            HttpStatusCode statusCode = httpResponse.StatusCode;
            cancellationToken.ThrowIfCancellationRequested();
            string responseContent = await httpResponse.Content.ReadAsStringAsync().ConfigureAwait(false);
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Redirect")))
            {
                HttpOperationException ex = new HttpOperationException(responseContent);
                Error errorBody = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
                if (errorBody != null)
                {
                    ex.Body = errorBody;
                }
                ex.Request = httpRequest;
                ex.Response = httpResponse;
                if (shouldTrace)
                {
                    ServiceClientTracing.Error(invocationId, ex);
                }
                throw ex;
            }
            // Create Result
            HttpOperationResponse result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

    }
}
