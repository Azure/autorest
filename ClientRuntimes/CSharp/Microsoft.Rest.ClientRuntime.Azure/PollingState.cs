// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using Microsoft.Rest.ClientRuntime.Azure.Properties;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest.Azure
{
    /// <summary>
    /// Defines long running operation polling state.
    /// </summary>
    /// <typeparam name="T">Type of resource.</typeparam>
    internal class PollingState<T> where T : class
    {
        /// <summary>
        /// Initializes an instance of PollingState.
        /// </summary>
        /// <param name="response">First operation response.</param>
        /// <param name="retryTimeout">Default timeout.</param>
        public PollingState(HttpOperationResponse<T> response, int? retryTimeout)
        {
            _retryTimeout = retryTimeout;
            Response = response.Response;
            Request = response.Request;
            Resource = response.Body;

            string raw = response.Response.Content.ReadAsStringAsync().ConfigureAwait(false)
                .GetAwaiter().GetResult();

            JObject resource = null;
            if (!string.IsNullOrEmpty(raw))
            {
                try
                {
                    resource = JObject.Parse(raw);
                }
                catch (JsonException)
                {
                    // failed to deserialize, return empty body
                }
            }

            if (resource != null && resource["properties"] != null && 
                resource["properties"]["provisioningState"] != null)
            {
                Status = (string)resource["properties"]["provisioningState"];
            }
            else
            {
                switch (Response.StatusCode)
                {
                    case HttpStatusCode.Accepted:
                        Status = AzureAsyncOperation.InProgressStatus;
                        break;

                    case HttpStatusCode.NoContent:
                    case HttpStatusCode.Created:
                    case HttpStatusCode.OK:
                        Status = AzureAsyncOperation.SuccessStatus;
                        break;

                    default:
                        Status = AzureAsyncOperation.FailedStatus;
                        break;
                }
            }
        }

        private string _status;

        /// <summary>
        /// Gets or sets polling status.
        /// </summary>
        public string Status {
            get
            {
                return _status;
            }
            set
            {
                if (value == null)
                {
                    throw new CloudException(Resources.NoProvisioningState);
                }
                _status = value;
            }
        }

        /// <summary>
        /// Gets or sets the latest value captured from Azure-AsyncOperation header.
        /// </summary>
        public string AzureAsyncOperationHeaderLink { get; set; }

        /// <summary>
        /// Gets or sets the latest value captured from Location header.
        /// </summary>
        public string LocationHeaderLink { get; set; }

        private HttpResponseMessage _response;

        /// <summary>
        /// Gets or sets last operation response. 
        /// </summary>
        public HttpResponseMessage Response
        {
            get { return _response; }
            set
            {
                _response = value;
                if (_response != null)
                {
                    if (_response.Headers.Contains("Azure-AsyncOperation"))
                    {
                        AzureAsyncOperationHeaderLink = _response.Headers
                            .GetValues("Azure-AsyncOperation").FirstOrDefault();
                    }

                    if (_response.Headers.Contains("Location"))
                    {
                        LocationHeaderLink = _response.Headers.GetValues("Location").FirstOrDefault();
                    }
                }
            }
        }

        /// <summary>
        /// Gets or sets last operation request.
        /// </summary>
        public HttpRequestMessage Request { get; set; }

        /// <summary>
        /// Gets or sets cloud error.
        /// </summary>
        public CloudError Error { get; set; }

        /// <summary>
        /// Gets or sets resource.
        /// </summary>
        public T Resource { get; set; }

        private int? _retryTimeout;

        /// <summary>
        /// Gets long running operation delay in milliseconds.
        /// </summary>
        public int DelayInMilliseconds
        {
            get
            {
                if (_retryTimeout != null)
                {
                    return _retryTimeout.Value * 1000;
                }
                if (Response != null && Response.Headers.Contains("Retry-After"))
                {
                    return int.Parse(Response.Headers.GetValues("Retry-After").FirstOrDefault(),
                        CultureInfo.InvariantCulture) * 1000;
                }
                return AzureAsyncOperation.DefaultDelay * 1000;
            }
        }

        /// <summary>
        /// Gets CloudException from current instance.  
        /// </summary>
        public CloudException CloudException
        {
            get
            {
                return new CloudException(string.Format(CultureInfo.InvariantCulture, 
                    Resources.LongRunningOperationFailed, Status))
                {
                    Body = Error,
                    Request = Request,
                    Response = Response
                };
            }
        }

        /// <summary>
        /// Gets AzureOperationResponse from current instance. 
        /// </summary>
        public AzureOperationResponse<T> AzureOperationResponse
        {
            get
            {
                return new AzureOperationResponse<T>
                {
                    Body = Resource,
                    Request = Request,
                    Response = Response
                };
            }
        }
    }
}
