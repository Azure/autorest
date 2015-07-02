namespace Fixtures.SwaggerBatRequiredOptional
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

    internal partial class ImplicitModel : IServiceOperations<AutoRestRequiredOptionalTestService>, IImplicitModel
    {
        /// <summary>
        /// Initializes a new instance of the ImplicitModel class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        internal ImplicitModel(AutoRestRequiredOptionalTestService client)
        {
            this.Client = client;
        }

        /// <summary>
        /// Gets a reference to the AutoRestRequiredOptionalTestService
        /// </summary>
        public AutoRestRequiredOptionalTestService Client { get; private set; }

        /// <summary>
        /// Test implicitly required path parameter
        /// </summary>
        /// <param name='pathParameter'>
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> GetRequiredPathWithOperationResponseAsync(string pathParameter, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (pathParameter == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "pathParameter");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("pathParameter", pathParameter);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetRequiredPath", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//reqopt/implicit/required/path/{pathParameter}";
            url = url.Replace("{pathParameter}", Uri.EscapeDataString(pathParameter));
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
        /// Test implicitly optional query parameter
        /// </summary>
        /// <param name='queryParameter'>
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> PutOptionalQueryWithOperationResponseAsync(string queryParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("queryParameter", queryParameter);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "PutOptionalQuery", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//reqopt/implicit/optional/query";
            List<string> queryParameters = new List<string>();
            if (queryParameter != null)
            {
                queryParameters.Add(string.Format("queryParameter={0}", Uri.EscapeDataString(queryParameter)));
            }
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
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
        /// Test implicitly optional header parameter
        /// </summary>
        /// <param name='queryParameter'>
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> PutOptionalHeaderWithOperationResponseAsync(string queryParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("queryParameter", queryParameter);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "PutOptionalHeader", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//reqopt/implicit/optional/header";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            if (queryParameter != null)
            {
                httpRequest.Headers.Add("queryParameter", queryParameter);
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
        /// Test implicitly optional body parameter
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> PutOptionalBodyWithOperationResponseAsync(string bodyParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("bodyParameter", bodyParameter);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "PutOptionalBody", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//reqopt/implicit/optional/body";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(bodyParameter, this.Client.SerializationSettings);
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
        /// Test implicitly required path parameter
        /// </summary>
        /// <param name='requiredGlobalPath'>
        /// number of items to skip
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> GetRequiredGlobalPathWithOperationResponseAsync(string requiredGlobalPath, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (requiredGlobalPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "requiredGlobalPath");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("requiredGlobalPath", requiredGlobalPath);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetRequiredGlobalPath", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//reqopt/global/required/path/{required-global-path}";
            url = url.Replace("{requiredGlobalPath}", Uri.EscapeDataString(requiredGlobalPath));
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
        /// Test implicitly required query parameter
        /// </summary>
        /// <param name='requiredGlobalQuery'>
        /// number of items to skip
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> GetRequiredGlobalQueryWithOperationResponseAsync(string requiredGlobalQuery, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (requiredGlobalQuery == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "requiredGlobalQuery");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("requiredGlobalQuery", requiredGlobalQuery);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetRequiredGlobalQuery", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//reqopt/global/required/query";
            List<string> queryParameters = new List<string>();
            if (requiredGlobalQuery != null)
            {
                queryParameters.Add(string.Format("required_global_query={0}", Uri.EscapeDataString(requiredGlobalQuery)));
            }
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
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
        /// Test implicitly optional query parameter
        /// </summary>
        /// <param name='optionalGlobalQuery'>
        /// number of items to skip
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Error>> GetOptionalGlobalQueryWithOperationResponseAsync(int? optionalGlobalQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("optionalGlobalQuery", optionalGlobalQuery);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetOptionalGlobalQuery", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//reqopt/global/optional/query";
            List<string> queryParameters = new List<string>();
            if (optionalGlobalQuery != null)
            {
                queryParameters.Add(string.Format("optional_global_query={0}", Uri.EscapeDataString(JsonConvert.SerializeObject(optionalGlobalQuery, this.Client.SerializationSettings).Trim('"'))));
            }
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
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

    }
}
