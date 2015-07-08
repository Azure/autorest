namespace Fixtures.Azure.SwaggerBatHead
{
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using Microsoft.Azure;

    internal partial class HttpSuccessOperations : IServiceOperations<AutoRestHeadTestService>, IHttpSuccessOperations
    {
        /// <summary>
        /// Initializes a new instance of the HttpSuccessOperations class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        internal HttpSuccessOperations(AutoRestHeadTestService client)
        {
            this.Client = client;
        }

        /// <summary>
        /// Gets a reference to the AutoRestHeadTestService
        /// </summary>
        public AutoRestHeadTestService Client { get; private set; }

        /// <summary>
        /// Return 204 status code if successful
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<bool?>> Head204WithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Head204", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/success/204";
            List<string> queryParameters = new List<string>();
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("HEAD");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (customHeaders != null)
            {
                foreach(var header in customHeaders)
                {
                    httpRequest.Headers.Add(header.Key, header.Value);
                }
            }

            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "NoContent") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "NotFound")))
            {
                var ex = new CloudException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
                CloudError errorBody = JsonConvert.DeserializeObject<CloudError>(responseContent, this.Client.DeserializationSettings);
                if (errorBody != null)
                {
                    ex = new CloudException(errorBody.Message);
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
            var result = new AzureOperationResponse<bool?>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = (statusCode == HttpStatusCode.NoContent);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 404 status code if successful
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<bool?>> Head404WithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Head404", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/success/404";
            List<string> queryParameters = new List<string>();
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("HEAD");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (customHeaders != null)
            {
                foreach(var header in customHeaders)
                {
                    httpRequest.Headers.Add(header.Key, header.Value);
                }
            }

            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "NoContent") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "NotFound")))
            {
                var ex = new CloudException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
                CloudError errorBody = JsonConvert.DeserializeObject<CloudError>(responseContent, this.Client.DeserializationSettings);
                if (errorBody != null)
                {
                    ex = new CloudException(errorBody.Message);
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
            var result = new AzureOperationResponse<bool?>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = (statusCode == HttpStatusCode.NoContent);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

    }
}
