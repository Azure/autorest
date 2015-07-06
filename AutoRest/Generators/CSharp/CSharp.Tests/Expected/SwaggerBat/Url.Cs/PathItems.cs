namespace Fixtures.SwaggerBatUrl
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

    internal partial class PathItems : IServiceOperations<AutoRestUrlTestService>, IPathItems
    {
        /// <summary>
        /// Initializes a new instance of the PathItems class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        internal PathItems(AutoRestUrlTestService client)
        {
            this.Client = client;
        }

        /// <summary>
        /// Gets a reference to the AutoRestUrlTestService
        /// </summary>
        public AutoRestUrlTestService Client { get; private set; }

        /// <summary>
        /// send globalStringPath='globalStringPath',
        /// pathItemStringPath='pathItemStringPath',
        /// localStringPath='localStringPath', globalStringQuery='globalStringQuery',
        /// pathItemStringQuery='pathItemStringQuery',
        /// localStringQuery='localStringQuery'
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value 'localStringPath'
        /// </param>    
        /// <param name='pathItemStringPath'>
        /// A string value 'pathItemStringPath' that appears in the path
        /// </param>    
        /// <param name='globalStringPath'>
        /// A string value 'globalItemStringPath' that appears in the path
        /// </param>    
        /// <param name='localStringQuery'>
        /// should contain value 'localStringQuery'
        /// </param>    
        /// <param name='pathItemStringQuery'>
        /// A string value 'pathItemStringQuery' that appears as a query parameter
        /// </param>    
        /// <param name='globalStringQuery'>
        /// should contain value null
        /// </param>    
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> GetAllWithValuesWithHttpMessagesAsync(string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (localStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "localStringPath");
            }
            if (pathItemStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "pathItemStringPath");
            }
            if (globalStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "globalStringPath");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("localStringPath", localStringPath);
                tracingParameters.Add("pathItemStringPath", pathItemStringPath);
                tracingParameters.Add("globalStringPath", globalStringPath);
                tracingParameters.Add("localStringQuery", localStringQuery);
                tracingParameters.Add("pathItemStringQuery", pathItemStringQuery);
                tracingParameters.Add("globalStringQuery", globalStringQuery);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetAllWithValues", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/pathItemStringQuery/localStringQuery";
            url = url.Replace("{localStringPath}", Uri.EscapeDataString(localStringPath));
            url = url.Replace("{pathItemStringPath}", Uri.EscapeDataString(pathItemStringPath));
            url = url.Replace("{globalStringPath}", Uri.EscapeDataString(globalStringPath));
            List<string> queryParameters = new List<string>();
            if (localStringQuery != null)
            {
                queryParameters.Add(string.Format("localStringQuery={0}", Uri.EscapeDataString(localStringQuery)));
            }
            if (pathItemStringQuery != null)
            {
                queryParameters.Add(string.Format("pathItemStringQuery={0}", Uri.EscapeDataString(pathItemStringQuery)));
            }
            if (globalStringQuery != null)
            {
                queryParameters.Add(string.Format("globalStringQuery={0}", Uri.EscapeDataString(globalStringQuery)));
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
            if (customHeaders != null)
            {
                foreach(var header in customHeaders)
                {
                    httpRequest.Headers.Add(header.Key, header.Value);
                }
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
        /// send globalStringPath='globalStringPath',
        /// pathItemStringPath='pathItemStringPath',
        /// localStringPath='localStringPath', globalStringQuery=null,
        /// pathItemStringQuery='pathItemStringQuery',
        /// localStringQuery='localStringQuery'
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value 'localStringPath'
        /// </param>    
        /// <param name='pathItemStringPath'>
        /// A string value 'pathItemStringPath' that appears in the path
        /// </param>    
        /// <param name='globalStringPath'>
        /// A string value 'globalItemStringPath' that appears in the path
        /// </param>    
        /// <param name='localStringQuery'>
        /// should contain value 'localStringQuery'
        /// </param>    
        /// <param name='pathItemStringQuery'>
        /// A string value 'pathItemStringQuery' that appears as a query parameter
        /// </param>    
        /// <param name='globalStringQuery'>
        /// should contain value null
        /// </param>    
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> GetGlobalQueryNullWithHttpMessagesAsync(string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (localStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "localStringPath");
            }
            if (pathItemStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "pathItemStringPath");
            }
            if (globalStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "globalStringPath");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("localStringPath", localStringPath);
                tracingParameters.Add("pathItemStringPath", pathItemStringPath);
                tracingParameters.Add("globalStringPath", globalStringPath);
                tracingParameters.Add("localStringQuery", localStringQuery);
                tracingParameters.Add("pathItemStringQuery", pathItemStringQuery);
                tracingParameters.Add("globalStringQuery", globalStringQuery);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetGlobalQueryNull", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/localStringQuery";
            url = url.Replace("{localStringPath}", Uri.EscapeDataString(localStringPath));
            url = url.Replace("{pathItemStringPath}", Uri.EscapeDataString(pathItemStringPath));
            url = url.Replace("{globalStringPath}", Uri.EscapeDataString(globalStringPath));
            List<string> queryParameters = new List<string>();
            if (localStringQuery != null)
            {
                queryParameters.Add(string.Format("localStringQuery={0}", Uri.EscapeDataString(localStringQuery)));
            }
            if (pathItemStringQuery != null)
            {
                queryParameters.Add(string.Format("pathItemStringQuery={0}", Uri.EscapeDataString(pathItemStringQuery)));
            }
            if (globalStringQuery != null)
            {
                queryParameters.Add(string.Format("globalStringQuery={0}", Uri.EscapeDataString(globalStringQuery)));
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
            if (customHeaders != null)
            {
                foreach(var header in customHeaders)
                {
                    httpRequest.Headers.Add(header.Key, header.Value);
                }
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
        /// send globalStringPath=globalStringPath,
        /// pathItemStringPath='pathItemStringPath',
        /// localStringPath='localStringPath', globalStringQuery=null,
        /// pathItemStringQuery='pathItemStringQuery', localStringQuery=null
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value 'localStringPath'
        /// </param>    
        /// <param name='pathItemStringPath'>
        /// A string value 'pathItemStringPath' that appears in the path
        /// </param>    
        /// <param name='globalStringPath'>
        /// A string value 'globalItemStringPath' that appears in the path
        /// </param>    
        /// <param name='localStringQuery'>
        /// should contain null value
        /// </param>    
        /// <param name='pathItemStringQuery'>
        /// A string value 'pathItemStringQuery' that appears as a query parameter
        /// </param>    
        /// <param name='globalStringQuery'>
        /// should contain value null
        /// </param>    
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> GetGlobalAndLocalQueryNullWithHttpMessagesAsync(string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (localStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "localStringPath");
            }
            if (pathItemStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "pathItemStringPath");
            }
            if (globalStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "globalStringPath");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("localStringPath", localStringPath);
                tracingParameters.Add("pathItemStringPath", pathItemStringPath);
                tracingParameters.Add("globalStringPath", globalStringPath);
                tracingParameters.Add("localStringQuery", localStringQuery);
                tracingParameters.Add("pathItemStringQuery", pathItemStringQuery);
                tracingParameters.Add("globalStringQuery", globalStringQuery);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetGlobalAndLocalQueryNull", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/null";
            url = url.Replace("{localStringPath}", Uri.EscapeDataString(localStringPath));
            url = url.Replace("{pathItemStringPath}", Uri.EscapeDataString(pathItemStringPath));
            url = url.Replace("{globalStringPath}", Uri.EscapeDataString(globalStringPath));
            List<string> queryParameters = new List<string>();
            if (localStringQuery != null)
            {
                queryParameters.Add(string.Format("localStringQuery={0}", Uri.EscapeDataString(localStringQuery)));
            }
            if (pathItemStringQuery != null)
            {
                queryParameters.Add(string.Format("pathItemStringQuery={0}", Uri.EscapeDataString(pathItemStringQuery)));
            }
            if (globalStringQuery != null)
            {
                queryParameters.Add(string.Format("globalStringQuery={0}", Uri.EscapeDataString(globalStringQuery)));
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
            if (customHeaders != null)
            {
                foreach(var header in customHeaders)
                {
                    httpRequest.Headers.Add(header.Key, header.Value);
                }
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
        /// send globalStringPath='globalStringPath',
        /// pathItemStringPath='pathItemStringPath',
        /// localStringPath='localStringPath', globalStringQuery='globalStringQuery',
        /// pathItemStringQuery=null, localStringQuery=null
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value 'localStringPath'
        /// </param>    
        /// <param name='pathItemStringPath'>
        /// A string value 'pathItemStringPath' that appears in the path
        /// </param>    
        /// <param name='globalStringPath'>
        /// A string value 'globalItemStringPath' that appears in the path
        /// </param>    
        /// <param name='localStringQuery'>
        /// should contain value null
        /// </param>    
        /// <param name='pathItemStringQuery'>
        /// should contain value null
        /// </param>    
        /// <param name='globalStringQuery'>
        /// should contain value null
        /// </param>    
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> GetLocalPathItemQueryNullWithHttpMessagesAsync(string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (localStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "localStringPath");
            }
            if (pathItemStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "pathItemStringPath");
            }
            if (globalStringPath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "globalStringPath");
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("localStringPath", localStringPath);
                tracingParameters.Add("pathItemStringPath", pathItemStringPath);
                tracingParameters.Add("globalStringPath", globalStringPath);
                tracingParameters.Add("localStringQuery", localStringQuery);
                tracingParameters.Add("pathItemStringQuery", pathItemStringQuery);
                tracingParameters.Add("globalStringQuery", globalStringQuery);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetLocalPathItemQueryNull", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/null/null";
            url = url.Replace("{localStringPath}", Uri.EscapeDataString(localStringPath));
            url = url.Replace("{pathItemStringPath}", Uri.EscapeDataString(pathItemStringPath));
            url = url.Replace("{globalStringPath}", Uri.EscapeDataString(globalStringPath));
            List<string> queryParameters = new List<string>();
            if (localStringQuery != null)
            {
                queryParameters.Add(string.Format("localStringQuery={0}", Uri.EscapeDataString(localStringQuery)));
            }
            if (pathItemStringQuery != null)
            {
                queryParameters.Add(string.Format("pathItemStringQuery={0}", Uri.EscapeDataString(pathItemStringQuery)));
            }
            if (globalStringQuery != null)
            {
                queryParameters.Add(string.Format("globalStringQuery={0}", Uri.EscapeDataString(globalStringQuery)));
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
            if (customHeaders != null)
            {
                foreach(var header in customHeaders)
                {
                    httpRequest.Headers.Add(header.Key, header.Value);
                }
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
