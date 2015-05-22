// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Properties;
using Microsoft.Rest;
using Newtonsoft.Json;

namespace Microsoft.Azure
{
    public static class AzureClientExtensions
    {
        /// <summary>
        /// Gets operation result for PUT operations.
        /// </summary>
        /// <typeparam name="T">Type of the resource</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="getOperationAction">Delegate for the get operation</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Response with created resource</returns>
        public static async Task<AzureOperationResponse<T>> GetPutOperationResultAsync<T>(this IAzureClient client, 
            AzureOperationResponse<T> response,
            Func<Task<AzureOperationResponse<T>>> getOperationAction,
            CancellationToken cancellationToken) where T : Resource
        {
            if (response == null)
            {
                throw new ArgumentNullException("response");
            }
            if (getOperationAction == null)
            {
                throw new ArgumentNullException("getOperationAction");
            }
            if (response.Body == null)
            {
                throw new ArgumentNullException("response.Body");
            }

            AzureOperationResponse<T> responseWithResource = response;
            AzureOperationResponse<AzureAsyncOperation> responseWithOperationStatus = null;
            string status = response.Body.ProvisioningState;
            CloudError cloudError = null;
            int delayInSeconds = GetRetryAfter(client.LongRunningOperationInitialTimeout, response);

            // Check provisioning state
            while (!AzureAsyncOperation.TerminalStatuses.Any(s => s.Equals(status,
                StringComparison.OrdinalIgnoreCase)))
            {
                await PlatformTask.Delay(delayInSeconds * 1000, cancellationToken).ConfigureAwait(false);

                // Check Azure-AsyncOperation header
                if (response.Response.Headers.Contains("Azure-AsyncOperation"))
                {
                    // Reset operationResponse
                    responseWithResource = null;

                    string azureAsyncUrl = response.Response.Headers.GetValues("Azure-AsyncOperation").FirstOrDefault();
                    responseWithOperationStatus = await client.GetLongRunningOperationStatusAsync(azureAsyncUrl, 
                        cancellationToken).ConfigureAwait(false);

                    Debug.Assert(responseWithOperationStatus.Body != null);

                    status = responseWithOperationStatus.Body.Status;
                    cloudError = responseWithOperationStatus.Body.Error;
                }
                else
                {
                    // use get getOperationAction if Azure-AsyncOperation header is not present
                    responseWithResource = await getOperationAction().ConfigureAwait(false);

                    status = responseWithResource.Body.ProvisioningState;
                    cloudError = new CloudError()
                    {
                        Code = status,
                        Message = Resources.LongRunningOperationFailed
                    };
                }

                // Update delay
                delayInSeconds = GetRetryAfter(client.LongRunningOperationRetryTimeout, responseWithOperationStatus);
            }

            // Check if operation failed
            if (AzureAsyncOperation.FailedStatuses.Any(
                        s => s.Equals(status, StringComparison.OrdinalIgnoreCase)))
            {
                CloudException exception = new CloudException(Resources.LongRunningOperationFailed)
                {
                    Body = cloudError
                };

                if (responseWithOperationStatus != null)
                {
                    exception.Request = responseWithOperationStatus.Request;
                    exception.Response = responseWithOperationStatus.Response;
                }
                else if (responseWithResource != null)
                {
                    exception.Request = responseWithResource.Request;
                    exception.Response = responseWithResource.Response;
                }
                throw exception;
            }

            if (responseWithResource == null)
            {
                responseWithResource = await getOperationAction().ConfigureAwait(false);
            }

            return responseWithResource;
        }

        /// <summary>
        /// Gets operation result for DELETE and POST operations.
        /// </summary>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation response</returns>
        public static async Task<AzureOperationResponse> GetPostOrDeleteOperationResultAsync(this IAzureClient client,
            AzureOperationResponse response,
            CancellationToken cancellationToken)
        {
            if (response == null)
            {
                throw new ArgumentNullException("response");
            }

            if (response.Response == null)
            {
                throw new ArgumentNullException("response.Response");
            }

            if (response.Response.StatusCode != HttpStatusCode.OK &&
                response.Response.StatusCode != HttpStatusCode.Accepted &&
                response.Response.StatusCode != HttpStatusCode.NoContent)
            {
                throw new CloudException("Unexpected status code from long running operation: " + response.Response.StatusCode);
            }

            AzureOperationResponse operationResponse = response;
            string status = GetStatusFromHttpStatusCode(response.Response.StatusCode);
            CloudError cloudError = null;
            int delayInSeconds = GetRetryAfter(client.LongRunningOperationInitialTimeout, response);

            // Check provisioning state
            while (!AzureAsyncOperation.TerminalStatuses.Any(s => s.Equals(status,
                StringComparison.OrdinalIgnoreCase)))
            {
                await PlatformTask.Delay(delayInSeconds * 1000, cancellationToken).ConfigureAwait(false);

                string statusUrl;
                // Check Azure-AsyncOperation header
                if (response.Response.Headers.Contains("Azure-AsyncOperation"))
                {
                    statusUrl = response.Response.Headers.GetValues("Azure-AsyncOperation").FirstOrDefault();
                }
                else
                {
                    Debug.Assert(response.Response.Headers.Contains("Location"));
                    // use get Location header if Azure-AsyncOperation header is not present
                    statusUrl = response.Response.Headers.GetValues("Location").FirstOrDefault();
                }

                AzureOperationResponse<AzureAsyncOperation> responseWithOperationStatus =
                    await client.GetLongRunningOperationStatusAsync(statusUrl, cancellationToken).ConfigureAwait(false);

                status = responseWithOperationStatus.Body.Status;
                cloudError = responseWithOperationStatus.Body.Error;
                operationResponse = new AzureOperationResponse
                {
                    Request = responseWithOperationStatus.Request,
                    Response = responseWithOperationStatus.Response
                };

                // Update delay
                delayInSeconds = GetRetryAfter(client.LongRunningOperationRetryTimeout, responseWithOperationStatus);
            }

            if (AzureAsyncOperation.FailedStatuses.Any(
                    s => s.Equals(status, StringComparison.OrdinalIgnoreCase)))
            {
                CloudException exception = new CloudException(Resources.LongRunningOperationFailed)
                {
                    Body = cloudError
                };

                exception.Request = operationResponse.Request;
                exception.Response = operationResponse.Response;

                throw exception;
            }

            return operationResponse;
        }

        private static string GetStatusFromHttpStatusCode(HttpStatusCode statusCode)
        {
            string status;
            if (statusCode == HttpStatusCode.Accepted)
            {
                status = "InProgress";
            }
            else if (statusCode == HttpStatusCode.OK || statusCode == HttpStatusCode.Created)
            {
                status = "Succeeded";
            }
            else
            {
                status = "Failed";
            }

            return status;
        }

        /// <summary>
        /// Returns timeout value from either response header or client timeout.
        /// </summary>
        /// <param name="clientTimeout">Client defined timeout.</param>
        /// <param name="response">Http operation response</param>
        /// <returns>Timeout in seconds.</returns>
        private static int GetRetryAfter(int clientTimeout, HttpOperationResponse response)
        {
            if (clientTimeout >= 0)
            {
                return clientTimeout;
            }
            if (response != null && response.Response != null &&
                response.Response.Headers.Contains("Retry-After"))
            {
                return int.Parse(response.Response.Headers.GetValues("Retry-After").FirstOrDefault(),
                    CultureInfo.InvariantCulture);
            }
            return AzureAsyncOperation.DefaultDelay;
        }

        /// <summary>
        /// Gets long running operation status from specified URL.
        /// </summary>
        /// <param name="client">IAzureClient</param>
        /// <param name="operationUrl">URL specified via Location or Azure-AsyncOperation header.</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns></returns>
        public static async Task<AzureOperationResponse<AzureAsyncOperation>> GetLongRunningOperationStatusAsync(
            this IAzureClient client,
            string operationUrl, 
            CancellationToken cancellationToken)
        {
            // Validate
            if (operationUrl == null)
            {
                throw new ArgumentNullException("operationUrl");
            }

            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("operationUrl", operationUrl);
                ServiceClientTracing.Enter(invocationId, client, "GetLongRunningOperationStatusAsync", tracingParameters);
            }

            // Construct URL
            string url = "";
            url = url + operationUrl;
            url = url.Replace(" ", "%20");

            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = HttpMethod.Get;
            httpRequest.RequestUri = new Uri(url);

            // Set Credentials
            if (client.Credentials != null)
            {
                cancellationToken.ThrowIfCancellationRequested();
                await client.Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            }

            // Send Request
            if (shouldTrace)
            {
                ServiceClientTracing.SendRequest(invocationId, httpRequest);
            }
            cancellationToken.ThrowIfCancellationRequested();
            HttpResponseMessage httpResponse = await client.HttpClient.SendAsync(httpRequest, cancellationToken).ConfigureAwait(false);
            if (shouldTrace)
            {
                ServiceClientTracing.ReceiveResponse(invocationId, httpResponse);
            }
            HttpStatusCode statusCode = httpResponse.StatusCode;
            cancellationToken.ThrowIfCancellationRequested();
            string responseContent = await httpResponse.Content.ReadAsStringAsync().ConfigureAwait(false);

            AzureAsyncOperation resultModel = new AzureAsyncOperation();
            if (!string.IsNullOrEmpty(responseContent))
            {
                resultModel = JsonConvert.DeserializeObject<AzureAsyncOperation>(responseContent, client.DeserializationSettings);
            }
            else
            {
                resultModel.Status = GetStatusFromHttpStatusCode(statusCode);
                if (resultModel.Status == "Failed")
                {
                    resultModel.Error = new CloudError
                    {
                        Message = Resources.LongRunningOperationFailed
                    };
                }
            }

            if (httpResponse.Headers.Contains("Retry-After"))
            {
                resultModel.RetryAfter = int.Parse(httpResponse.Headers.GetValues("Retry-After").FirstOrDefault(),
                    CultureInfo.InvariantCulture);
            }
            else
            {
                resultModel.RetryAfter = client.LongRunningOperationRetryTimeout;
            }

            if (resultModel.Status == "Failed")
            {
                string errorMessage = Resources.LongRunningOperationFailed;
                if (resultModel.Error != null && !string.IsNullOrWhiteSpace(resultModel.Error.Message))
                {
                    errorMessage = resultModel.Error.Message;
                }
                CloudException ex = new CloudException(errorMessage);
                ex.Request = httpRequest;
                ex.Response = httpResponse;
                ex.Body = resultModel.Error;
                if (shouldTrace)
                {
                    ServiceClientTracing.Error(invocationId, ex);
                }
                throw ex;
            }

            // Create Result
            AzureOperationResponse<AzureAsyncOperation> result = new AzureOperationResponse<AzureAsyncOperation>();
            result.Request = httpRequest;
            result.Response = httpResponse;
            result.Body = resultModel;

            if (shouldTrace)
            {
                ServiceClientTracing.Exit(invocationId, result);
            }
            return result;
        }
    }
}
