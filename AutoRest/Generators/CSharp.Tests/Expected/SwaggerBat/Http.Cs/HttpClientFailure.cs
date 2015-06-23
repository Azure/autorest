namespace Fixtures.SwaggerBatHttp
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
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using Models;

    internal partial class HttpClientFailure : IServiceOperations<AutoRestHttpInfrastructureTestService>, IHttpClientFailure
    {
        /// <summary>
        /// Initializes a new instance of the HttpClientFailure class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        internal HttpClientFailure(AutoRestHttpInfrastructureTestService client)
        {
            this.Client = client;
        }

        /// <summary>
        /// Gets a reference to the AutoRestHttpInfrastructureTestService
        /// </summary>
        public AutoRestHttpInfrastructureTestService Client { get; private set; }

        /// <summary>
        /// Return 400 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Head400WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Head400", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/400";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("HEAD");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 400 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Get400WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get400", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/400";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 400 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Put400WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Put400", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/400";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 400 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Patch400WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Patch400", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/400";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PATCH");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 400 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Post400WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Post400", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/400";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 400 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Delete400WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Delete400", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/400";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 401 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Head401WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Head401", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/401";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("HEAD");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 402 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Get402WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get402", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/402";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 403 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Get403WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get403", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/403";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 404 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Put404WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Put404", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/404";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 405 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Patch405WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Patch405", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/405";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PATCH");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 406 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Post406WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Post406", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/406";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 407 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Delete407WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Delete407", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/407";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 409 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Put409WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Put409", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/409";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 410 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Head410WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Head410", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/410";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("HEAD");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 411 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Get411WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get411", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/411";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 412 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Get412WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get412", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/412";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 413 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Put413WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Put413", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/413";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 414 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Patch414WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Patch414", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/414";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PATCH");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 415 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Post415WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Post415", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/415";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 416 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Get416WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get416", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/416";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 417 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Delete417WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("booleanValue", booleanValue);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Delete417", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/417";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(booleanValue, this.Client.SerializationSettings);
            httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);
            httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json; charset=utf-8");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Return 429 status code - should be represented in the client as an error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> Head429WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Head429", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//http/failure/client/429";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("HEAD");
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
            if (!(httpResponse.IsSuccessStatusCode))
            {
                var ex = new HttpOperationException(string.Format("Operation returned an invalid status code '{0}'", statusCode));
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
            var result = new HttpOperationResponse<Error>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = JsonConvert.DeserializeObject<Error>(responseContent, this.Client.DeserializationSettings);
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

    }
}
