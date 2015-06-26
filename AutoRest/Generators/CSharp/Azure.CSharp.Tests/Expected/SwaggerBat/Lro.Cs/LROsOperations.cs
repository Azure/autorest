namespace Fixtures.Azure.SwaggerBatLro
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
    using Models;

    internal partial class LROsOperations : IServiceOperations<AutoRestLongRunningOperationTestService>, ILROsOperations
    {
        /// <summary>
        /// Initializes a new instance of the LROsOperations class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        internal LROsOperations(AutoRestLongRunningOperationTestService client)
        {
            this.Client = client;
        }

        /// <summary>
        /// Gets a reference to the AutoRestLongRunningOperationTestService
        /// </summary>
        public AutoRestLongRunningOperationTestService Client { get; private set; }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Put200SucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPut200SucceededWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => Get200SucceededWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPut200SucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPut200Succeeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/200/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "NoContent")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Get200SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get200Succeeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/200/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that does not contain ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Put200SucceededNoStateWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPut200SucceededNoStateWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => Get200SucceededNoStateWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that does not contain ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPut200SucceededNoStateWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPut200SucceededNoState", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/200/succeeded/nostate";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Get200SucceededNoStateWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get200SucceededNoState", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/200/succeeded/nostate";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 202 to the initial request,
        /// with a location header that points to a polling URL that returns a 200
        /// and an entity that doesn&apos;t contains ProvisioningState
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Put202Retry200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPut202Retry200WithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => GetPut202Retry200WithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 202 to the initial request,
        /// with a location header that points to a polling URL that returns a 200
        /// and an entity that doesn&apos;t contains ProvisioningState
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPut202Retry200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPut202Retry200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/202/retry/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> GetPut202Retry200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetPut202Retry200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/202/retry/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 201 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Put201CreatingSucceeded200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPut201CreatingSucceeded200WithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => Get201CreatingSucceeded200PollingWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 201 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPut201CreatingSucceeded200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPut201CreatingSucceeded200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/201/creating/succeeded/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Created")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Created"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Get201CreatingSucceeded200PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get201CreatingSucceeded200Polling", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/201/creating/succeeded/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 201 to the initial request,
        /// with an entity that contains ProvisioningState=’Updating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Put200UpdatingSucceeded204WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPut200UpdatingSucceeded204WithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => Get200CreatingSucceeded200PollWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 201 to the initial request,
        /// with an entity that contains ProvisioningState=’Updating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPut200UpdatingSucceeded204WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPut200UpdatingSucceeded204", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/200/updating/succeeded/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Polling endpoinnt for Long running put request, service returns a 200
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Get200CreatingSucceeded200PollWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get200CreatingSucceeded200Poll", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/200/updating/succeeded/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 201 to the initial request,
        /// with an entity that contains ProvisioningState=’Created’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Failed’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Put201CreatingFailed200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPut201CreatingFailed200WithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => Get201CreatingFailed200PollingWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 201 to the initial request,
        /// with an entity that contains ProvisioningState=’Created’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Failed’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPut201CreatingFailed200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPut201CreatingFailed200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/201/created/failed/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Created")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Created"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Get201CreatingFailed200PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get201CreatingFailed200Polling", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/201/created/failed/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 201 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Put200Acceptedcanceled200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPut200Acceptedcanceled200WithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => Get200Acceptedcanceled200PollWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 201 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPut200Acceptedcanceled200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPut200Acceptedcanceled200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/200/accepted/canceled/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Polling endpoinnt for Long running put request, service returns a 200
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Get200Acceptedcanceled200PollWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "Get200Acceptedcanceled200Poll", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/put/200/accepted/canceled/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> PutAsyncRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPutAsyncRetrySucceededWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => GetAsyncRetrySucceededWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPutAsyncRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPutAsyncRetrySucceeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/putasync/retry/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> GetAsyncRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetAsyncRetrySucceeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/putasync/retry/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> PutAsyncNoRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPutAsyncNoRetrySucceededWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => GetAsyncNoRetrySucceededWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPutAsyncNoRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPutAsyncNoRetrySucceeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/putasync/noretry/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> GetAsyncNoRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetAsyncNoRetrySucceeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/putasync/noretry/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> PutAsyncRetryFailedWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPutAsyncRetryFailedWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => GetAsyncRetryFailedWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPutAsyncRetryFailedWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPutAsyncRetryFailed", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/putasync/retry/failed";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> GetAsyncRetryFailedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetAsyncRetryFailed", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/putasync/retry/failed";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> PutAsyncNoRetrycanceledWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send Request
            AzureOperationResponse<Product> response = await BeginPutAsyncNoRetrycanceledWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPutOperationResultAsync<Product>(response, 
                () => GetAsyncNoRetrycanceledWithOperationResponseAsync(cancellationToken),
                cancellationToken);
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPutAsyncNoRetrycanceledWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPutAsyncNoRetrycanceled", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/putasync/noretry/canceled";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running put request, service returns a 200 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> GetAsyncNoRetrycanceledWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetAsyncNoRetrycanceled", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/putasync/noretry/canceled";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Accepted’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> DeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse<Product> response = await BeginDeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Accepted’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginDeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDeleteProvisioning202Accepted200Succeeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/delete/provisioning/202/accepted/200/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Failed’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> DeleteProvisioning202DeletingFailed200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse<Product> response = await BeginDeleteProvisioning202DeletingFailed200WithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Failed’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginDeleteProvisioning202DeletingFailed200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDeleteProvisioning202DeletingFailed200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/delete/provisioning/202/deleting/200/failed";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> DeleteProvisioning202Deletingcanceled200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse<Product> response = await BeginDeleteProvisioning202Deletingcanceled200WithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginDeleteProvisioning202Deletingcanceled200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDeleteProvisioning202Deletingcanceled200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/delete/provisioning/202/deleting/200/canceled";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete succeeds and returns right away
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> Delete204SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginDelete204SucceededWithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete succeeds and returns right away
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginDelete204SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDelete204Succeeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/delete/204/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "NoContent")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Polls return this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Delete202Retry200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse<Product> response = await BeginDelete202Retry200WithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Polls return this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginDelete202Retry200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDelete202Retry200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/delete/202/retry/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Polls return this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Delete202NoRetry204WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse<Product> response = await BeginDelete202NoRetry204WithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Polls return this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginDelete202NoRetry204WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDelete202NoRetry204", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/delete/202/noretry/204";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Poll the endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> DeleteAsyncRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginDeleteAsyncRetrySucceededWithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Poll the endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginDeleteAsyncRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDeleteAsyncRetrySucceeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/deleteasync/retry/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Poll the endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> DeleteAsyncNoRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginDeleteAsyncNoRetrySucceededWithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Poll the endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginDeleteAsyncNoRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDeleteAsyncNoRetrySucceeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/deleteasync/noretry/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Poll the endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> DeleteAsyncRetryFailedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginDeleteAsyncRetryFailedWithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Poll the endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginDeleteAsyncRetryFailedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDeleteAsyncRetryFailed", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/deleteasync/retry/failed";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Poll the endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> DeleteAsyncRetrycanceledWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginDeleteAsyncRetrycanceledWithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running delete request, service returns a 202 to the initial request.
        /// Poll the endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginDeleteAsyncRetrycanceledWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginDeleteAsyncRetrycanceled", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/deleteasync/retry/canceled";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("DELETE");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with &apos;Location&apos; header. Poll returns a 200 with a response body
        /// after success.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Sku>> Post200WithPayloadWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse<Sku> response = await BeginPost200WithPayloadWithOperationResponseAsync(
                cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with &apos;Location&apos; header. Poll returns a 200 with a response body
        /// after success.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Sku>> BeginPost200WithPayloadWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPost200WithPayload", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/post/payload/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted") || statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK")))
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
            var result = new AzureOperationResponse<Sku>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted"))
            {
                result.Body = JsonConvert.DeserializeObject<Sku>(responseContent, this.Client.DeserializationSettings);
            }
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Sku>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with &apos;Location&apos; and &apos;Retry-After&apos; headers, Polls
        /// return a 200 with a response body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> Post202Retry200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginPost202Retry200WithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with &apos;Location&apos; and &apos;Retry-After&apos; headers, Polls
        /// return a 200 with a response body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginPost202Retry200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPost202Retry200", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/post/202/retry/200";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with &apos;Location&apos; header, 204 with noresponse body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> Post202NoRetry204WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse<Product> response = await BeginPost202NoRetry204WithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with &apos;Location&apos; header, 204 with noresponse body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse<Product>> BeginPost202NoRetry204WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPost202NoRetry204", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/post/202/noretry/204";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse<Product>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted"))
            {
                result.Body = JsonConvert.DeserializeObject<Product>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> PostAsyncRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginPostAsyncRetrySucceededWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginPostAsyncRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPostAsyncRetrySucceeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/postasync/retry/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> PostAsyncNoRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginPostAsyncNoRetrySucceededWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginPostAsyncNoRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPostAsyncNoRetrySucceeded", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/postasync/noretry/succeeded";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> PostAsyncRetryFailedWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginPostAsyncRetryFailedWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginPostAsyncRetryFailedWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPostAsyncRetryFailed", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/postasync/retry/failed";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
            result.Request = httpRequest;
            result.Response = httpResponse;
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> PostAsyncRetrycanceledWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            // Send request
            AzureOperationResponse response = await BeginPostAsyncRetrycanceledWithOperationResponseAsync(
                product, cancellationToken);
            return await this.Client.GetPostOrDeleteOperationResultAsync(response, cancellationToken);
        }

        /// <summary>
        /// Long running post request, service returns a 202 to the initial request,
        /// with an entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<AzureOperationResponse> BeginPostAsyncRetrycanceledWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
        {
            if (product != null)
            {
                product.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("product", product);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "BeginPostAsyncRetrycanceled", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//lro/postasync/retry/canceled";
            List<string> queryParameters = new List<string>();
            queryParameters.Add(string.Format("api-version={0}", Uri.EscapeDataString(this.Client.ApiVersion)));
            if (queryParameters.Count > 0)
            {
                url += "?" + string.Join("&", queryParameters);
            }
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("POST");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Set Credentials
            cancellationToken.ThrowIfCancellationRequested();
            await this.Client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(product, this.Client.SerializationSettings);
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
            if (!(statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "Accepted")))
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
            var result = new AzureOperationResponse();
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
