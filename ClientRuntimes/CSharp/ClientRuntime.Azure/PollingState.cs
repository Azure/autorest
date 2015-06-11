// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using Microsoft.Azure.Properties;
using Microsoft.Rest;

namespace Microsoft.Azure
{
    /// <summary>
    /// Defines long running operation polling state.
    /// </summary>
    /// <typeparam name="T">Type of resource.</typeparam>
    internal class PollingState<T> where T : class
    {
        private int? _retryTimeout;

        /// <summary>
        /// Initializes an instance of PollingState from HttpOperationResponse.
        /// </summary>
        /// <param name="response">First operation response.</param>
        /// <param name="retryTimeout">Default timeout.</param>
        public PollingState(HttpOperationResponse response, int? retryTimeout)
        {
            Response = response.Response;
            Request = response.Request;
            _retryTimeout = retryTimeout;

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

        /// <summary>
        /// Initializes an instance of PollingState from generic HttpOperationResponse.
        /// </summary>
        /// <param name="response">First operation response.</param>
        /// <param name="retryTimeout">Default timeout.</param>
        public PollingState(HttpOperationResponse<T> response, int? retryTimeout)
            : this((HttpOperationResponse) response, retryTimeout)
        {
            if (Response.StatusCode != HttpStatusCode.Accepted)
            {
                if (response.Body == null)
                {
                    throw new CloudException(Resources.NoBody);
                }

                if (response.Body is Resource)
                {
                    Status = (response.Body as Resource).ProvisioningState;
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
        /// Gets or sets last operation response. 
        /// </summary>
        public HttpResponseMessage Response { get; set; }

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
                return AzureAsyncOperation.DefaultDelay;
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
