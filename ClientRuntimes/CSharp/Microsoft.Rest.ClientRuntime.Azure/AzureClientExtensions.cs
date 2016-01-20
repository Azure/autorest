// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest.ClientRuntime.Azure.Properties;
using Microsoft.Rest.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest.Azure
{
    public static class AzureClientExtensions
    {
        /// <summary>
        /// Gets operation result for PUT and PATCH operations.
        /// </summary>
        /// <typeparam name="TBody">Type of the resource body</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Response with created resource</returns>
        public static async Task<AzureOperationResponse<TBody>> GetPutOrPatchOperationResultAsync<TBody>(
            this IAzureClient client,
            AzureOperationResponse<TBody> response,
            Dictionary<string, List<string>> customHeaders,
            CancellationToken cancellationToken) where TBody : class 
        {
            if (response == null)
            {
                throw new ArgumentNullException("response");
            }
            var headerlessResponse = new AzureOperationResponse<TBody, object>
            {
                Body = response.Body,
                Request = response.Request,
                RequestId = response.RequestId,
                Response = response.Response
            };
            var longRunningResponse = await GetPutOrPatchOperationResultAsync(client, headerlessResponse, customHeaders, cancellationToken);
            return new AzureOperationResponse<TBody>
            {
                Body = longRunningResponse.Body,
                Request = longRunningResponse.Request,
                RequestId = longRunningResponse.RequestId,
                Response = longRunningResponse.Response
            };
        }

        /// <summary>
        /// Gets operation result for PUT and PATCH operations.
        /// </summary>
        /// <typeparam name="TBody">Type of the resource body</typeparam>
        /// <typeparam name="THeader">Type of the resource header</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Response with created resource</returns>
        public static async Task<AzureOperationResponse<TBody, THeader>> GetPutOrPatchOperationResultAsync<TBody, THeader>(
            this IAzureClient client,
            AzureOperationResponse<TBody, THeader> response,
            Dictionary<string, List<string>> customHeaders,
            CancellationToken cancellationToken) where TBody : class where THeader : class
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

            var pollingState = new PollingState<TBody, THeader>(response, client.LongRunningOperationRetryTimeout);
            Uri getOperationUrl = response.Request.RequestUri;

            // Check provisioning state
            while (!AzureAsyncOperation.TerminalStatuses.Any(s => s.Equals(pollingState.Status,
                StringComparison.OrdinalIgnoreCase)))
            {
                await Task.Delay(pollingState.DelayInMilliseconds, cancellationToken).ConfigureAwait(false);

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
        /// <typeparam name="TBody">Type of the resource body</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation response</returns>
        public static async Task<AzureOperationResponse<TBody>> GetPostOrDeleteOperationResultAsync<TBody>(
            this IAzureClient client,
            AzureOperationResponse<TBody> response,
            Dictionary<string, List<string>> customHeaders,
            CancellationToken cancellationToken) where TBody : class
        {
            if (response == null)
            {
                throw new ArgumentNullException("response");
            }
            var headerlessResponse = new AzureOperationResponse<TBody, object>
            {
                Body = response.Body,
                Request = response.Request,
                RequestId = response.RequestId,
                Response = response.Response
            };
            var longRunningResponse = await GetPostOrDeleteOperationResultAsync(client, headerlessResponse, customHeaders, cancellationToken);
            return new AzureOperationResponse<TBody>
            {
                Body = longRunningResponse.Body,
                Request = longRunningResponse.Request,
                RequestId = longRunningResponse.RequestId,
                Response = longRunningResponse.Response
            };
        }

        /// <summary>
        /// Gets operation result for DELETE and POST operations.
        /// </summary>
        /// <typeparam name="THeader">Type of the resource headers</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation response</returns>
        public static async Task<AzureOperationHeaderResponse<THeader>> GetPostOrDeleteOperationResultAsync<THeader>(
            this IAzureClient client,
            AzureOperationHeaderResponse<THeader> response,
            Dictionary<string, List<string>> customHeaders,
            CancellationToken cancellationToken) where THeader : class
        {
            if (response == null)
            {
                throw new ArgumentNullException("response");
            }
            var headerlessResponse = new AzureOperationResponse<object, THeader>
            {
                Headers = response.Headers,
                Request = response.Request,
                RequestId = response.RequestId,
                Response = response.Response
            };
            var longRunningResponse = await GetPostOrDeleteOperationResultAsync(client, headerlessResponse, customHeaders, cancellationToken);
            return new AzureOperationHeaderResponse<THeader>
            {
                Headers = longRunningResponse.Headers,
                Request = longRunningResponse.Request,
                RequestId = longRunningResponse.RequestId,
                Response = longRunningResponse.Response
            };
        }

        /// <summary>
        /// Gets operation result for DELETE and POST operations.
        /// </summary>
        /// <typeparam name="TBody">Type of the resource body</typeparam>
        /// <typeparam name="THeader">Type of the resource header</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="response">Response from the begin operation</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation response</returns>
        public static async Task<AzureOperationResponse<TBody, THeader>> GetPostOrDeleteOperationResultAsync<TBody, THeader>(
            this IAzureClient client,
            AzureOperationResponse<TBody, THeader> response,
            Dictionary<string, List<string>> customHeaders,
            CancellationToken cancellationToken) where TBody : class where THeader : class
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

            var pollingState = new PollingState<TBody, THeader>(response, client.LongRunningOperationRetryTimeout);

            // Check provisioning state
            while (!AzureAsyncOperation.TerminalStatuses.Any(s => s.Equals(pollingState.Status,
                StringComparison.OrdinalIgnoreCase)))
            {
                await Task.Delay(pollingState.DelayInMilliseconds, cancellationToken).ConfigureAwait(false);

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
        /// <typeparam name="TBody">Type of the resource body.</typeparam>
        /// <typeparam name="THeader">Type of the resource header.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="getOperationUri">Uri for the get operation</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromGetResourceOperation<TBody, THeader>(
            IAzureClient client,
            PollingState<TBody, THeader> pollingState,
            Uri getOperationUri,
            Dictionary<string, List<string>> customHeaders,
            CancellationToken cancellationToken) where TBody : class where THeader : class
        {
            AzureOperationResponse<JObject, JObject> responseWithResource = await GetRawAsync(client,
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
            pollingState.Resource = responseWithResource.Body.ToObject<TBody>(JsonSerializer
                .Create(client.DeserializationSettings));
            pollingState.ResourceHeaders = responseWithResource.Headers.ToObject<THeader>(JsonSerializer
                .Create(client.DeserializationSettings));
        }

        /// <summary>
        /// Updates PollingState from Location header on Put operations.
        /// </summary>
        /// <typeparam name="TBody">Type of the resource body.</typeparam>
        /// <typeparam name="THeader">Type of the resource header.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromLocationHeaderOnPut<TBody, THeader>(
            IAzureClient client,
            PollingState<TBody, THeader> pollingState,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken) where TBody : class where THeader : class
        {
            AzureOperationResponse<JObject, JObject> responseWithResource = await client.GetRawAsync(
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
                pollingState.Resource = responseWithResource.Body.ToObject<TBody>(JsonSerializer
                    .Create(client.DeserializationSettings));
                pollingState.ResourceHeaders = responseWithResource.Headers.ToObject<THeader>(JsonSerializer
                    .Create(client.DeserializationSettings));
            }
        }

        /// <summary>
        /// Updates PollingState from Location header on Post or Delete operations.
        /// </summary>
        /// <typeparam name="TBody">Type of the resource body.</typeparam>
        /// <typeparam name="THeader">Type of the resource header.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromLocationHeaderOnPostOrDelete<TBody, THeader>(
            IAzureClient client,
            PollingState<TBody, THeader> pollingState,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken) where TBody : class where THeader : class
        {
            AzureOperationResponse<TBody, THeader> responseWithResource = await client.GetAsync<TBody, THeader>(
                pollingState.LocationHeaderLink,
                customHeaders,
                cancellationToken).ConfigureAwait(false);

            pollingState.Response = responseWithResource.Response;
            pollingState.Request = responseWithResource.Request;
            pollingState.ResourceHeaders = responseWithResource.Headers;

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
        /// <typeparam name="TBody">Type of the resource body.</typeparam>
        /// <typeparam name="THeader">Type of the resource header.</typeparam>
        /// <param name="client">IAzureClient</param>
        /// <param name="pollingState">Current polling state.</param>
        /// <param name="customHeaders">Headers that will be added to request</param>
        /// <param name="postOrDelete">Headers that will be added to request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task.</returns>
        private static async Task UpdateStateFromAzureAsyncOperationHeader<TBody, THeader>(
            IAzureClient client,
            PollingState<TBody, THeader> pollingState,
            Dictionary<string, List<string>> customHeaders, 
            bool postOrDelete,
            CancellationToken cancellationToken) where TBody : class where THeader : class
        {
            AzureOperationResponse<AzureAsyncOperation, object> asyncOperationResponse =
                await client.GetAsync<AzureAsyncOperation, object>(
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
                string responseContent = await pollingState.Response.Content.ReadAsStringAsync();
                var responseHeaders = pollingState.Response.Headers.ToJson();
                try
                {
                    pollingState.Resource = JObject.Parse(responseContent)
                        .ToObject<TBody>(JsonSerializer.Create(client.DeserializationSettings));
                    pollingState.ResourceHeaders =
                        responseHeaders.ToObject<THeader>(JsonSerializer.Create(client.DeserializationSettings));
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
        private static async Task<AzureOperationResponse<TBody, THeader>> GetAsync<TBody, THeader>(
            this IAzureClient client,
            string operationUrl,
            Dictionary<string, List<string>> customHeaders, 
            CancellationToken cancellationToken) where TBody : class where THeader : class
        {
            var result = await GetRawAsync(client, operationUrl, customHeaders, cancellationToken);

            TBody body = null;
            if (result.Body != null)
            {
                body = result.Body.ToObject<TBody>(JsonSerializer.Create(client.DeserializationSettings));
            }

            return new AzureOperationResponse<TBody, THeader>
            {
                Request = result.Request,
                Response = result.Response,
                Body = body,
                Headers = result.Headers.ToObject<THeader>(JsonSerializer.Create(client.DeserializationSettings))
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
        private static async Task<AzureOperationResponse<JObject, JObject>> GetRawAsync(
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
                CloudError errorBody = SafeJsonConvert.DeserializeObject<CloudError>(responseContent, client.DeserializationSettings);
                throw new CloudException(string.Format(CultureInfo.InvariantCulture,
                    Resources.LongRunningOperationFailed, statusCode))
                {
                    Body = errorBody,
                    Request = new HttpRequestMessageWrapper(httpRequest, null),
                    Response = new HttpResponseMessageWrapper(httpResponse, responseContent)
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

            return new AzureOperationResponse<JObject, JObject>
            {
                Request = httpRequest,
                Response = httpResponse,
                Body = body,
                Headers = httpResponse.Headers.ToJson()
            };
        }
    }
}
