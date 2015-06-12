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
        public static async Task<AzureOperationResponse<T>> GetPutOperationResultAsync<T>(
            this IAzureClient client, 
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
            if (response.Response.StatusCode != HttpStatusCode.OK &&
                response.Response.StatusCode != HttpStatusCode.Accepted &&
                response.Response.StatusCode != HttpStatusCode.Created)
            {
                throw new CloudException(string.Format(Resources.UnexpectedPollingStatus, response.Response.StatusCode));
            }

            var pollingState = new PollingState<T>(response, client.LongRunningOperationRetryTimeout);

            // Check provisioning state
            while (!AzureAsyncOperation.TerminalStatuses.Any(s => s.Equals(pollingState.Status,
                StringComparison.OrdinalIgnoreCase)))
            {
                await PlatformTask.Delay(pollingState.DelayInMilliseconds, cancellationToken).ConfigureAwait(false);

                if (pollingState.Response.Headers.Contains("Azure-AsyncOperation"))
                {
                    await UpdateStateFromAzureAsyncOperationHeader(client, pollingState, cancellationToken);
                }
                else if (pollingState.Response.Headers.Contains("Location"))
                {
                    await UpdateStateFromLocationHeaderOnPut(client, pollingState, cancellationToken);
                }
                else
                {
                    await UpdateStateFromGetResourceOperation(getOperationAction, pollingState);
                }
            }

            if (AzureAsyncOperation.SuccessStatus.Equals(pollingState.Status, StringComparison.OrdinalIgnoreCase) &&
                pollingState.Resource == null)
            {
                await UpdateStateFromGetResourceOperation(getOperationAction, pollingState);
            }

            // Check if operation failed
            if (AzureAsyncOperation.FailedStatuses.Any(
                        s => s.Equals(pollingState.Status, StringComparison.OrdinalIgnoreCase)))
            {
                throw pollingState.CloudException;
            }

            return pollingState.AzureOperationResponse;
        }

        /// <summary>
        /// Gets operation result for DELETE and POST operations.
        /// </summary>
        /// <typeparam name="T">Type of the resource</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation response</returns>
        public static async Task<AzureOperationResponse<T>> GetPostOrDeleteOperationResultAsync<T>(
            this IAzureClient client,
            AzureOperationResponse<T> response,
            CancellationToken cancellationToken) where T : class
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
                throw new CloudException(string.Format(Resources.UnexpectedPollingStatus, response.Response.StatusCode));
            }

            var pollingState = new PollingState<T>(response, client.LongRunningOperationRetryTimeout);

            // Check provisioning state
            while (!AzureAsyncOperation.TerminalStatuses.Any(s => s.Equals(pollingState.Status,
                StringComparison.OrdinalIgnoreCase)))
            {
                await PlatformTask.Delay(pollingState.DelayInMilliseconds, cancellationToken).ConfigureAwait(false);

                if (pollingState.Response.Headers.Contains("Azure-AsyncOperation"))
                {
                    await UpdateStateFromAzureAsyncOperationHeader(client, pollingState, cancellationToken);
                }
                else if (pollingState.Response.Headers.Contains("Location"))
                {
                    await UpdateStateFromLocationHeaderOnPostOrDelete(client, cancellationToken, pollingState);
                }
                else
                {
                    throw new CloudException(Resources.NoHeader);
                }
            }

            // Check if operation failed
            if (AzureAsyncOperation.FailedStatuses.Any(
                    s => s.Equals(pollingState.Status, StringComparison.OrdinalIgnoreCase)))
            {
                throw pollingState.CloudException;
            }

            return pollingState.AzureOperationResponse;
        }

        /// <summary>
        /// Gets operation result for DELETE and POST operations.
        /// </summary>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation response</returns>
        public static async Task<AzureOperationResponse> GetPostOrDeleteOperationResultAsync(
            this IAzureClient client,
            AzureOperationResponse response,
            CancellationToken cancellationToken)
        {
            var newResponse = new AzureOperationResponse<object>
            {
                Request = response.Request,
                Response = response.Response,
                RequestId = response.RequestId
            };

            var azureOperationResponse = await client.GetPostOrDeleteOperationResultAsync<object>(newResponse, cancellationToken);
            return new AzureOperationResponse
            {
                Request = azureOperationResponse.Request,
                Response = azureOperationResponse.Response,
                RequestId = azureOperationResponse.RequestId
            };
        }

        /// <summary>
        /// Updates PollingState from Get resource operation.
        /// </summary>
        /// <typeparam name="T">Type of the resource.</typeparam>
        /// <param name="getOperationAction">Delegate for the get operation.</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromGetResourceOperation<T>(
            Func<Task<AzureOperationResponse<T>>> getOperationAction, 
            PollingState<T> pollingState)
            where T : Resource
        {
            // use get getOperationAction if Azure-AsyncOperation header is not present
            AzureOperationResponse<T> responseWithResource = await getOperationAction().ConfigureAwait(false);
            if (responseWithResource.Body == null)
            {
                throw new CloudException(Resources.NoBody);
            }

            // In 202 pattern on PUT ProvisioningState may not be present in 
            // the response. In that case the assumption is the status is Succeeded.
            if (responseWithResource.Body.ProvisioningState != null)
            {
                pollingState.Status = responseWithResource.Body.ProvisioningState;
            }
            else
            {
                pollingState.Status = AzureAsyncOperation.SuccessStatus;
            }

            pollingState.Error = new CloudError()
            {
                Code = pollingState.Status,
                Message = string.Format(Resources.LongRunningOperationFailed, pollingState.Status)
            };
            pollingState.Response = responseWithResource.Response;
            pollingState.Request = responseWithResource.Request;
            pollingState.Resource = responseWithResource.Body;
        }

        /// <summary>
        /// Updates PollingState from Location header on Put operations.
        /// </summary>
        /// <typeparam name="T">Type of the resource.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromLocationHeaderOnPut<T>(
            IAzureClient client,
            PollingState<T> pollingState,
            CancellationToken cancellationToken) 
            where T : Resource
        {
            AzureOperationResponse<T> responseWithResource = await client.GetAsync<T>(
                pollingState.Response.Headers.GetValues("Location").FirstOrDefault(),
                cancellationToken).ConfigureAwait(false);

            pollingState.Response = responseWithResource.Response;
            pollingState.Request = responseWithResource.Request;

            var statusCode = responseWithResource.Response.StatusCode;
            if (statusCode == HttpStatusCode.Accepted)
            {
                pollingState.Status = AzureAsyncOperation.InProgressStatus;
            }
            else if (statusCode == HttpStatusCode.OK ||
                     statusCode == HttpStatusCode.Created)
            {
                if (responseWithResource.Body == null)
                {
                    throw new CloudException(Resources.NoBody);
                }

                // In 202 pattern on PUT ProvisioningState may not be present in 
                // the response. In that case the assumption is the status is Succeeded.
                if (responseWithResource.Body.ProvisioningState != null)
                {
                    pollingState.Status = responseWithResource.Body.ProvisioningState;
                }
                else
                {
                    pollingState.Status = AzureAsyncOperation.SuccessStatus;
                }

                pollingState.Error = new CloudError()
                {
                    Code = pollingState.Status,
                    Message = string.Format(Resources.LongRunningOperationFailed, pollingState.Status)
                };
                pollingState.Resource = responseWithResource.Body;
            }
        }

        /// <summary>
        /// Updates PollingState from Location header on Post or Delete operations.
        /// </summary>
        /// <typeparam name="T">Type of the resource.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromLocationHeaderOnPostOrDelete<T>(
            IAzureClient client,
            CancellationToken cancellationToken, 
            PollingState<T> pollingState) 
            where T : class
        {
            AzureOperationResponse<T> responseWithResource = await client.GetAsync<T>(
                pollingState.Response.Headers.GetValues("Location").FirstOrDefault(),
                cancellationToken).ConfigureAwait(false);

            pollingState.Response = responseWithResource.Response;
            pollingState.Request = responseWithResource.Request;

            var statusCode = responseWithResource.Response.StatusCode;
            if (statusCode == HttpStatusCode.Accepted)
            {
                pollingState.Status = AzureAsyncOperation.InProgressStatus;
            }
            else if (statusCode == HttpStatusCode.OK ||
                     statusCode == HttpStatusCode.Created ||
                     statusCode == HttpStatusCode.NoContent)
            {
                pollingState.Status = AzureAsyncOperation.SuccessStatus;
                pollingState.Resource = responseWithResource.Body;
            }
        }

        /// <summary>
        /// Updates PollingState from Azure-AsyncOperation header.
        /// </summary>
        /// <typeparam name="T">Type of the resource.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task  UpdateStateFromAzureAsyncOperationHeader<T>(
            IAzureClient client, 
            PollingState<T> pollingState,
            CancellationToken cancellationToken) 
            where T : class
        {
            var asyncOperationResponse = await client.GetAsync<AzureAsyncOperation>(
                pollingState.Response.Headers.GetValues("Azure-AsyncOperation").FirstOrDefault(),
                cancellationToken).ConfigureAwait(false);

            if (asyncOperationResponse.Body == null || asyncOperationResponse.Body.Status == null)
            {
                throw new CloudException(Resources.NoBody);
            }

            pollingState.Status = asyncOperationResponse.Body.Status;
            pollingState.Error = asyncOperationResponse.Body.Error;
            pollingState.Response = asyncOperationResponse.Response;
            pollingState.Request = asyncOperationResponse.Request;
            pollingState.Resource = null;
        }

        /// <summary>
        /// Gets a resource from the specified URL.
        /// </summary>
        /// <param name="client">IAzureClient</param>
        /// <param name="operationUrl">URL of the resource.</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns></returns>
        private static async Task<AzureOperationResponse<T>> GetAsync<T>(
            this IAzureClient client,
            string operationUrl,
            CancellationToken cancellationToken) where T : class
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
                ServiceClientTracing.Enter(invocationId, client, "GetAsync", tracingParameters);
            }

            // Construct URL
            string url = operationUrl.Replace(" ", "%20");

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
            cancellationToken.ThrowIfCancellationRequested();
            string responseContent = await httpResponse.Content.ReadAsStringAsync().ConfigureAwait(false);           
            HttpStatusCode statusCode = httpResponse.StatusCode;

            if (statusCode != HttpStatusCode.OK &&
                statusCode != HttpStatusCode.Accepted &&
                statusCode != HttpStatusCode.Created &&
                statusCode != HttpStatusCode.NoContent)
            {
                throw new CloudException(string.Format(CultureInfo.InvariantCulture, Resources.LongRunningOperationFailed, statusCode));
            }

            T body = null;
            if (!string.IsNullOrWhiteSpace(responseContent))
            {
                body = JsonConvert.DeserializeObject<T>(responseContent, client.DeserializationSettings);
            }

            return new AzureOperationResponse<T>
            {
                Request = httpRequest,
                Response = httpResponse,
                Body = body
            };
        }
    }
}
