// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsLro
{
    using Microsoft.Rest.Azure;
    using Models;

    /// <summary>
    /// LROsCustomHeaderOperations operations.
    /// </summary>
    public partial interface ILROsCustomHeaderOperations
    {
        /// <summary>
        /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is
        /// required message header for all requests. Long running put
        /// request, service returns a 200 to the initial request, with an
        /// entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="Microsoft.Rest.Azure.CloudException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.SerializationException">
        /// Thrown when unable to deserialize the response
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.Azure.AzureOperationResponse<ProductInner,LROsCustomHeaderPutAsyncRetrySucceededHeadersInner>> PutAsyncRetrySucceededWithHttpMessagesAsync(ProductInner product = default(ProductInner), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is
        /// required message header for all requests. Long running put
        /// request, service returns a 200 to the initial request, with an
        /// entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="Microsoft.Rest.Azure.CloudException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.SerializationException">
        /// Thrown when unable to deserialize the response
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.Azure.AzureOperationResponse<ProductInner,LROsCustomHeaderPutAsyncRetrySucceededHeadersInner>> BeginPutAsyncRetrySucceededWithHttpMessagesAsync(ProductInner product = default(ProductInner), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is
        /// required message header for all requests. Long running put
        /// request, service returns a 201 to the initial request, with an
        /// entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="Microsoft.Rest.Azure.CloudException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.SerializationException">
        /// Thrown when unable to deserialize the response
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.Azure.AzureOperationResponse<ProductInner>> Put201CreatingSucceeded200WithHttpMessagesAsync(ProductInner product = default(ProductInner), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is
        /// required message header for all requests. Long running put
        /// request, service returns a 201 to the initial request, with an
        /// entity that contains ProvisioningState=’Creating’.  Polls return
        /// this value until the last poll returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="Microsoft.Rest.Azure.CloudException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.SerializationException">
        /// Thrown when unable to deserialize the response
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.Azure.AzureOperationResponse<ProductInner>> BeginPut201CreatingSucceeded200WithHttpMessagesAsync(ProductInner product = default(ProductInner), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is
        /// required message header for all requests. Long running post
        /// request, service returns a 202 to the initial request, with
        /// 'Location' and 'Retry-After' headers, Polls return a 200 with a
        /// response body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="Microsoft.Rest.Azure.CloudException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.Azure.AzureOperationHeaderResponse<LROsCustomHeaderPost202Retry200HeadersInner>> Post202Retry200WithHttpMessagesAsync(ProductInner product = default(ProductInner), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is
        /// required message header for all requests. Long running post
        /// request, service returns a 202 to the initial request, with
        /// 'Location' and 'Retry-After' headers, Polls return a 200 with a
        /// response body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="Microsoft.Rest.Azure.CloudException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.Azure.AzureOperationHeaderResponse<LROsCustomHeaderPost202Retry200HeadersInner>> BeginPost202Retry200WithHttpMessagesAsync(ProductInner product = default(ProductInner), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is
        /// required message header for all requests. Long running post
        /// request, service returns a 202 to the initial request, with an
        /// entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="Microsoft.Rest.Azure.CloudException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.Azure.AzureOperationHeaderResponse<LROsCustomHeaderPostAsyncRetrySucceededHeadersInner>> PostAsyncRetrySucceededWithHttpMessagesAsync(ProductInner product = default(ProductInner), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is
        /// required message header for all requests. Long running post
        /// request, service returns a 202 to the initial request, with an
        /// entity that contains ProvisioningState=’Creating’. Poll the
        /// endpoint indicated in the Azure-AsyncOperation header for
        /// operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="Microsoft.Rest.Azure.CloudException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.Azure.AzureOperationHeaderResponse<LROsCustomHeaderPostAsyncRetrySucceededHeadersInner>> BeginPostAsyncRetrySucceededWithHttpMessagesAsync(ProductInner product = default(ProductInner), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
    }
}
