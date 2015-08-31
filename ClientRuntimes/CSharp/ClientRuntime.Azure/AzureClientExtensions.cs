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
using Microsoft.Rest.Azure.Properties;
using Microsoft.Rest;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest.Azure
{
    public static class AzureClientExtensions
    {
        /// <summary>
        /// Gets operation result for PUT and PATCH operations.
        /// </summary>
        /// <typeparam name="T">Type of the resource</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Response with created resource</returns>
        public static async Task<AzureOperationResponse<T>> GetPutOrPatchOperationResultAsync<T>(
            this IAzureClient client, 
            AzureOperationResponse<T> response,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken) where T : class
        {
            if (response == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "response");
            }
            if (response.Response.StatusCode != HttpStatusCode.OK &&
                response.Response.StatusCode != HttpStatusCode.Accepted &&
                response.Response.StatusCode != HttpStatusCode.Created)
            {
                throw new CloudException(string.Format(Resources.UnexpectedPollingStatus, response.Response.StatusCode));
            }

            var pollingState = new PollingState<T>(response, client.LongRunningOperationRetryTimeout);
            Uri getOperationUrl = response.Request.RequestUri;

            // Check provisioning state
            while (!AzureAsyncOperation.TerminalStatuses.Any(s => s.Equals(pollingState.Status,
                StringComparison.OrdinalIgnoreCase)))
            {
                await PlatformTask.Delay(pollingState.DelayInMilliseconds, cancellationToken).ConfigureAwait(false);

                if (!string.IsNullOrEmpty(pollingState.AzureAsyncOperationHeaderLink))
                {
                    await UpdateStateFromAzureAsyncOperationHeader(client, pollingState, customHeaders, false, cancellationToken);
                }
                else if (!string.IsNullOrEmpty(pollingState.LocationHeaderLink))
                {
                    await UpdateStateFromLocationHeaderOnPut(client, pollingState, customHeaders, cancellationToken);
                }
                else
                {
                    await UpdateStateFromGetResourceOperation(client, pollingState, getOperationUrl, 
                        customHeaders, cancellationToken);
                }
            }

            if (AzureAsyncOperation.SuccessStatus.Equals(pollingState.Status, StringComparison.OrdinalIgnoreCase) &&
                pollingState.Resource == null)
            {
                await UpdateStateFromGetResourceOperation(client, pollingState, getOperationUrl,
                        customHeaders, cancellationToken);
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
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation response</returns>
        public static async Task<AzureOperationResponse<T>> GetPostOrDeleteOperationResultAsync<T>(
            this IAzureClient client,
            AzureOperationResponse<T> response,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken) where T : class
        {
            if (response == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "response");
            }

            if (response.Response == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "response.Response");
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

                if (!string.IsNullOrEmpty(pollingState.AzureAsyncOperationHeaderLink))
                {
                    await UpdateStateFromAzureAsyncOperationHeader(client, pollingState, customHeaders,true, cancellationToken);
                }
                else if (!string.IsNullOrEmpty(pollingState.LocationHeaderLink))
                {
                    await UpdateStateFromLocationHeaderOnPostOrDelete(client, pollingState, customHeaders, cancellationToken);
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
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation response</returns>
        public static async Task<AzureOperationResponse> GetPostOrDeleteOperationResultAsync(
            this IAzureClient client,
            AzureOperationResponse response,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken)
        {
            var newResponse = new AzureOperationResponse<object>
            {
                Request = response.Request,
                Response = response.Response,
                RequestId = response.RequestId
            };

            var azureOperationResponse = await client.GetPostOrDeleteOperationResultAsync(
                newResponse, customHeaders, cancellationToken);

            return new AzureOperationResponse
            {
                Request = azureOperationResponse.Request,
                Response = azureOperationResponse.Response,
                RequestId = azureOperationResponse.RequestId
            };
        }

        /// <summary>
        /// Updates PollingState from GET operations.
        /// </summary>
        /// <typeparam name="T">Type of the resource.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="getOperationUri">Uri for the get operation</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromGetResourceOperation<T>(
            IAzureClient client,
            PollingState<T> pollingState,
            Uri getOperationUri,
            Dictionary<string, List<string>> customHeaders,
            CancellationToken cancellationToken)
            where T : class
        {
            AzureOperationResponse<JObject> responseWithResource = await GetRawAsync(client,
                getOperationUri.AbsoluteUri, customHeaders, cancellationToken).ConfigureAwait(false);

            if (responseWithResource.Body == null)
            {
                throw new CloudException(Resources.NoBody);
            }

            // In 202 pattern on PUT ProvisioningState may not be present in 
            // the response. In that case the assumption is the status is Succeeded.
            var resource = responseWithResource.Body;
            if (resource["properties"] != null && resource["properties"]["provisioningState"] != null)
            {
                pollingState.Status = (string)resource["properties"]["provisioningState"];
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
            pollingState.Resource = responseWithResource.Body.ToObject<T>(JsonSerializer
                .Create(client.DeserializationSettings));
        }

        /// <summary>
        /// Updates PollingState from Location header on Put operations.
        /// </summary>
        /// <typeparam name="T">Type of the resource.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromLocationHeaderOnPut<T>(
            IAzureClient client,
            PollingState<T> pollingState,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken) 
            where T : class
        {
            AzureOperationResponse<JObject> responseWithResource = await client.GetRawAsync(
                pollingState.LocationHeaderLink,
                customHeaders,
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
                var resource = responseWithResource.Body;
                if (resource["properties"] != null && resource["properties"]["provisioningState"] != null)
                {
                    pollingState.Status = (string)resource["properties"]["provisioningState"];
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
                pollingState.Resource = responseWithResource.Body.ToObject<T>(JsonSerializer
                .Create(client.DeserializationSettings));
            }
        }

        /// <summary>
        /// Updates PollingState from Location header on Post or Delete operations.
        /// </summary>
        /// <typeparam name="T">Type of the resource.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromLocationHeaderOnPostOrDelete<T>(
            IAzureClient client,
            PollingState<T> pollingState,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken) 
            where T : class
        {
            AzureOperationResponse<T> responseWithResource = await client.GetAsync<T>(
                pollingState.LocationHeaderLink,
                customHeaders,
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
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="postOrDelete">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromAzureAsyncOperationHeader<T>(
            IAzureClient client,
            PollingState<T> pollingState,
            Dictionary<string, List<string>> customHeaders, 
            bool postOrDelete,
            CancellationToken cancellationToken) 
            where T : class
        {
            AzureOperationResponse<AzureAsyncOperation> asyncOperationResponse =
                await client.GetAsync<AzureAsyncOperation>(
                    pollingState.AzureAsyncOperationHeaderLink,
                    customHeaders,
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
            if (postOrDelete)
            {
                //Try to de-serialize to the response model. (Not required for "PutOrPatch" 
                //which has the fallback of invoking generic "resource get".)
                string responseContent = await pollingState.Response.Content.ReadAsStringAsync().ConfigureAwait(false);
                try
                {
                    pollingState.Resource = 
                        JObject.Parse(responseContent).ToObject<T>(JsonSerializer.Create(client.DeserializationSettings));
                }
                catch { };
            }
        }

        /// <summary>
        /// Gets a resource from the specified URL.
        /// </summary>
        /// <param name="client">IAzureClient</param>
        /// <param name="operationUrl">URL of the resource.</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns></returns>
        private static async Task<AzureOperationResponse<T>> GetAsync<T>(
            this IAzureClient client,
            string operationUrl,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken) where T : class
        {
            var result = await GetRawAsync(client, operationUrl, customHeaders, cancellationToken);

            T body = null;
            if (result.Body != null)
            {
                body = result.Body.ToObject<T>(JsonSerializer.Create(client.DeserializationSettings));
            }

            return new AzureOperationResponse<T>
            {
                Request = result.Request,
                Response = result.Response,
                Body = body
            };
        }

        /// <summary>
        /// Gets a resource from the specified URL.
        /// </summary>
        /// <param name="client">IAzureClient</param>
        /// <param name="operationUrl">URL of the resource.</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns></returns>
        private static async Task<AzureOperationResponse<JObject>> GetRawAsync(
            this IAzureClient client,
            string operationUrl,
            Dictionary<string, List<string>> customHeaders,
            CancellationToken cancellationToken)
        {
            // Validate
            if (operationUrl == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "operationUrl");
            }

            // Tracing
            bool shouldTrace = ServiceClientTracing.IsEnabled;
            string invocationId = null;
            if (shouldTrace)
            {
                invocationId = ServiceClientTracing.NextInvocationId.ToString();
                var tracingParameters = new Dictionary<string, object>();
                tracingParameters.Add("operationUrl", operationUrl);
                ServiceClientTracing.Enter(invocationId, client, "GetAsync", tracingParameters);
            }

            // Construct URL
            string url = operationUrl.Replace(" ", "%20");

            // Create HTTP transport objects
            HttpRequestMessage httpRequest = new HttpRequestMessage();
            httpRequest.Method = HttpMethod.Get;
            httpRequest.RequestUri = new Uri(url);

            // Set Headers
            if (customHeaders != null)
            {
                foreach (var header in customHeaders)
                {
                    httpRequest.Headers.Add(header.Key, header.Value);
                }
            }

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
                CloudError errorBody = JsonConvert.DeserializeObject<CloudError>(responseContent, client.DeserializationSettings);
                throw new CloudException(string.Format(CultureInfo.InvariantCulture,
                    Resources.LongRunningOperationFailed, statusCode))
                {
                    Body = errorBody,
                    Request = httpRequest,
                    Response = httpResponse
                };
            }

            JObject body = null;
            if (!string.IsNullOrWhiteSpace(responseContent))
            {
                try
                {
                    body = JObject.Parse(responseContent);
                }
                catch
                {
                    // failed to deserialize, return empty body
                }
            }

            return new AzureOperationResponse<JObject>
            {
                Request = httpRequest,
                Response = httpResponse,
                Body = body
            };
        }
    }
}
