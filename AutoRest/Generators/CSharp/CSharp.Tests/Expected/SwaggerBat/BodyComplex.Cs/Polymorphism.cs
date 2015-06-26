namespace Fixtures.SwaggerBatBodyComplex
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

    internal partial class Polymorphism : IServiceOperations<AutoRestComplexTestService>, IPolymorphism
    {
        /// <summary>
        /// Initializes a new instance of the Polymorphism class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        internal Polymorphism(AutoRestComplexTestService client)
        {
            this.Client = client;
        }

        /// <summary>
        /// Gets a reference to the AutoRestComplexTestService
        /// </summary>
        public AutoRestComplexTestService Client { get; private set; }

        /// <summary>
        /// Get complex types that are polymorphic
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse<Fish>> GetValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "GetValid", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//complex/polymorphism/valid";
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
            var result = new HttpOperationResponse<Fish>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            // Deserialize Response
            if (statusCode == (HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), "OK"))
            {
                result.Body = JsonConvert.DeserializeObject<Fish>(responseContent, this.Client.DeserializationSettings);
            }
            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }

        /// <summary>
        /// Put complex types that are polymorphic
        /// </summary>
        /// <param name='complexBody'>
        /// Please put a salmon that looks like this:
        /// {
        /// &apos;dtype&apos;:&apos;Salmon&apos;,
        /// &apos;location&apos;:&apos;alaska&apos;,
        /// &apos;iswild&apos;:true,
        /// &apos;species&apos;:&apos;king&apos;,
        /// &apos;length&apos;:1.0,
        /// &apos;siblings&apos;:[
        /// {
        /// &apos;dtype&apos;:&apos;Shark&apos;,
        /// &apos;age&apos;:6,
        /// &apos;birthday&apos;: &apos;2012-01-05T01:00:00Z&apos;,
        /// &apos;length&apos;:20.0,
        /// &apos;species&apos;:&apos;predator&apos;,
        /// },
        /// {
        /// &apos;dtype&apos;:&apos;Sawshark&apos;,
        /// &apos;age&apos;:105,
        /// &apos;birthday&apos;: &apos;1900-01-05T01:00:00Z&apos;,
        /// &apos;length&apos;:10.0,
        /// &apos;picture&apos;: new Buffer([255, 255, 255, 255,
        /// 254]).toString(&apos;base64&apos;),
        /// &apos;species&apos;:&apos;dangerous&apos;,
        /// }
        /// ]
        /// };
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> PutValidWithOperationResponseAsync(Fish complexBody, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (complexBody == null)
            {
                throw new ArgumentNullException("complexBody");
            }
            if (complexBody != null)
            {
                complexBody.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("complexBody", complexBody);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "PutValid", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//complex/polymorphism/valid";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(complexBody, this.Client.SerializationSettings);
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
        /// Put complex types that are polymorphic, attempting to omit required
        /// &apos;birthday&apos; field - the request should not be allowed from the
        /// client
        /// </summary>
        /// <param name='complexBody'>
        /// Please attempt put a sawshark that looks like this, the client should not
        /// allow this data to be sent:
        /// {
        /// &quot;dtype&quot;: &quot;sawshark&quot;,
        /// &quot;species&quot;: &quot;snaggle toothed&quot;,
        /// &quot;length&quot;: 18.5,
        /// &quot;age&quot;: 2,
        /// &quot;birthday&quot;: &quot;2013-06-01T01:00:00Z&quot;,
        /// &quot;location&quot;: &quot;alaska&quot;,
        /// &quot;picture&quot;: base64(FF FF FF FF FE),
        /// &quot;siblings&quot;: [
        /// {
        /// &quot;dtype&quot;: &quot;shark&quot;,
        /// &quot;species&quot;: &quot;predator&quot;,
        /// &quot;birthday&quot;: &quot;2012-01-05T01:00:00Z&quot;,
        /// &quot;length&quot;: 20,
        /// &quot;age&quot;: 6
        /// },
        /// {
        /// &quot;dtype&quot;: &quot;sawshark&quot;,
        /// &quot;species&quot;: &quot;dangerous&quot;,
        /// &quot;picture&quot;: base64(FF FF FF FF FE),
        /// &quot;length&quot;: 10,
        /// &quot;age&quot;: 105
        /// }
        /// ]
        /// }
        /// </param>    
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        public async Task<HttpOperationResponse> PutValidMissingRequiredWithOperationResponseAsync(Fish complexBody, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (complexBody == null)
            {
                throw new ArgumentNullException("complexBody");
            }
            if (complexBody != null)
            {
                complexBody.Validate();
            }
            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("complexBody", complexBody);
                tracingParameters.Add("cancellationToken", cancellationToken);
                ServiceClientTracing.Enter(invocationId, this, "PutValidMissingRequired", tracingParameters);
            }
            // Construct URL
            string url = this.Client.BaseUri.AbsoluteUri + 
                         "//complex/polymorphism/missingrequired/invalid";
            // trim all duplicate forward slashes in the url
            url = Regex.Replace(url, "([^:]/)/+", "$1");
            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = new HttpMethod("PUT");
            httpRequest.RequestUri = new Uri(url);
            // Set Headers
            // Serialize Request  
            string requestContent = JsonConvert.SerializeObject(complexBody, this.Client.SerializationSettings);
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

    }
}
