namespace Fixtures.SwaggerBatHeader
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

    internal partial class Header : IServiceOperations<AutoRestSwaggerBATHeaderService>, IHeader
    {
        /// <summary>
        /// Initializes a new instance of the Header class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        internal Header(AutoRestSwaggerBATHeaderService client)
        {
            this.Client = client;
        }

        /// <summary>
        /// Gets a reference to the AutoRestSwaggerBATHeaderService
        /// </summary>
        public AutoRestSwaggerBATHeaderService Client { get; private set; }

        /// <summary>
        /// Send a post request with header value "User-Agent": "overwrite"
        /// </summary>
        /// <param name='userAgent'>
        /// Send a post request with header value "User-Agent": "overwrite"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamExistingKeyWithOperationResponseAsync(string userAgent, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (userAgent == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "userAgent");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("userAgent", userAgent);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamExistingKey", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/existingkey";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (userAgent != null)
            {
                httpRequest.Headers.Add("User-Agent", userAgent);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header value "User-Agent": "overwrite"
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseExistingKeyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseExistingKey", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/existingkey";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header value "Content-Type": "text/html"
        /// </summary>
        /// <param name='contentType'>
        /// Send a post request with header value "Content-Type": "text/html"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamProtectedKeyWithOperationResponseAsync(string contentType, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (contentType == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "contentType");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("contentType", contentType);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamProtectedKey", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/protectedkey";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (contentType != null)
            {
                httpRequest.Headers.Add("Content-Type", contentType);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header value "Content-Type": "text/html"
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseProtectedKeyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseProtectedKey", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/protectedkey";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "positive", "value": 1
        /// or "scenario": "negative", "value": -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or "negative"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values 1 or -2
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamIntegerWithOperationResponseAsync(string scenario, int? value, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            if (value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "value");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamInteger", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/integer";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, this.Client.SerializationSettings).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header value "value": 1 or -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or "negative"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseIntegerWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseInteger", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/integer";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "positive", "value":
        /// 105 or "scenario": "negative", "value": -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or "negative"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values 105 or -2
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamLongWithOperationResponseAsync(string scenario, long? value, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            if (value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "value");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamLong", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/long";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, this.Client.SerializationSettings).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header value "value": 105 or -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or "negative"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseLongWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseLong", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/long";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "positive", "value":
        /// 0.07 or "scenario": "negative", "value": -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or "negative"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values 0.07 or -3.0
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamFloatWithOperationResponseAsync(string scenario, double? value, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            if (value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "value");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamFloat", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/float";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, this.Client.SerializationSettings).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header value "value": 0.07 or -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or "negative"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseFloatWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseFloat", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/float";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "positive", "value":
        /// 7e120 or "scenario": "negative", "value": -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or "negative"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values 7e120 or -3.0
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamDoubleWithOperationResponseAsync(string scenario, double? value, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            if (value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "value");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamDouble", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/double";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, this.Client.SerializationSettings).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header value "value": 7e120 or -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or "negative"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseDoubleWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseDouble", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/double";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "true", "value": true
        /// or "scenario": "false", "value": false
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "true" or "false"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values true or false
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamBoolWithOperationResponseAsync(string scenario, bool? value, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            if (value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "value");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamBool", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/bool";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, this.Client.SerializationSettings).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header value "value": true or false
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "true" or "false"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseBoolWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseBool", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/bool";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "valid", "value": "The
        /// quick brown fox jumps over the lazy dog" or "scenario": "null", "value":
        /// null or "scenario": "empty", "value": ""
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "null" or
        /// "empty"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values "The quick brown fox jumps over the
        /// lazy dog" or null or ""
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamStringWithOperationResponseAsync(string scenario, string value = default(string), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamString", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/string";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", value);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header values "The quick brown fox jumps over the lazy
        /// dog" or null or ""
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "null" or
        /// "empty"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseStringWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseString", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/string";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "valid", "value":
        /// "2010-01-01" or "scenario": "min", "value": "0001-01-01"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "min"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values "2010-01-01" or "0001-01-01"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamDateWithOperationResponseAsync(string scenario, DateTime? value, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            if (value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "value");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamDate", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/date";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, new DateJsonConverter()).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header values "2010-01-01" or "0001-01-01"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "min"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseDateWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseDate", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/date";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "valid", "value":
        /// "2010-01-01T12:34:56Z" or "scenario": "min", "value":
        /// "0001-01-01T00:00:00Z"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "min"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values "2010-01-01T12:34:56Z" or
        /// "0001-01-01T00:00:00Z"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamDatetimeWithOperationResponseAsync(string scenario, DateTime? value, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            if (value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "value");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamDatetime", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/datetime";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, this.Client.SerializationSettings).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header values "2010-01-01T12:34:56Z" or
        /// "0001-01-01T00:00:00Z"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "min"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseDatetimeWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseDatetime", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/datetime";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "valid", "value":
        /// "啊齄丂狛狜隣郎隣兀﨩"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values "啊齄丂狛狜隣郎隣兀﨩"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamByteWithOperationResponseAsync(string scenario, byte[] value, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            if (value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "value");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamByte", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/byte";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, this.Client.SerializationSettings).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header values "啊齄丂狛狜隣郎隣兀﨩"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseByteWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseByte", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/byte";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Send a post request with header values "scenario": "valid", "value":
        /// "GREY" or "scenario": "null", "value": null
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "null" or
        /// "empty"
        /// </param>    
        /// <param name='value'>
        /// Send a post request with header values 'GREY' . Possible values for this
        /// parameter include: 'White', 'black', 'GREY'
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ParamEnumWithOperationResponseAsync(string scenario, GreyscaleColors? value = default(GreyscaleColors?), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("value", value);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ParamEnum", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/param/prim/enum";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
            if (value != null)
            {
                httpRequest.Headers.Add("value", JsonConvert.SerializeObject(value, this.Client.SerializationSettings).Trim('"'));
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Get a response with header values "GREY" or null
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "null" or
        /// "empty"
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> ResponseEnumWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (scenario == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "scenario");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("scenario", scenario);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "ResponseEnum", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//header/response/prim/enum";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (scenario != null)
            {
                httpRequest.Headers.Add("scenario", scenario);
            }
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new HttpOperationResponse();
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
