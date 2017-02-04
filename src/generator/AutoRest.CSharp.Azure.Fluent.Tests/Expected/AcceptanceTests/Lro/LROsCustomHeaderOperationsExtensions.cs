// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsLro
{
    using Azure;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for LROsCustomHeaderOperations.
    /// </summary>
    public static partial class LROsCustomHeaderOperationsExtensions
    {
            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running put request, service returns
            /// a 200 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static ProductInner PutAsyncRetrySucceeded(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner))
            {
                return operations.PutAsyncRetrySucceededAsync(product).GetAwaiter().GetResult();
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running put request, service returns
            /// a 200 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ProductInner> PutAsyncRetrySucceededAsync(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PutAsyncRetrySucceededWithHttpMessagesAsync(product, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running put request, service returns
            /// a 201 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’.  Polls return this value until the last poll
            /// returns a ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static ProductInner Put201CreatingSucceeded200(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner))
            {
                return operations.Put201CreatingSucceeded200Async(product).GetAwaiter().GetResult();
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running put request, service returns
            /// a 201 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’.  Polls return this value until the last poll
            /// returns a ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ProductInner> Put201CreatingSucceeded200Async(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.Put201CreatingSucceeded200WithHttpMessagesAsync(product, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running post request, service returns
            /// a 202 to the initial request, with 'Location' and 'Retry-After' headers,
            /// Polls return a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static LROsCustomHeaderPost202Retry200HeadersInner Post202Retry200(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner))
            {
                return operations.Post202Retry200Async(product).GetAwaiter().GetResult();
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running post request, service returns
            /// a 202 to the initial request, with 'Location' and 'Retry-After' headers,
            /// Polls return a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<LROsCustomHeaderPost202Retry200HeadersInner> Post202Retry200Async(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.Post202Retry200WithHttpMessagesAsync(product, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Headers;
                }
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running post request, service returns
            /// a 202 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static LROsCustomHeaderPostAsyncRetrySucceededHeadersInner PostAsyncRetrySucceeded(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner))
            {
                return operations.PostAsyncRetrySucceededAsync(product).GetAwaiter().GetResult();
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running post request, service returns
            /// a 202 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<LROsCustomHeaderPostAsyncRetrySucceededHeadersInner> PostAsyncRetrySucceededAsync(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostAsyncRetrySucceededWithHttpMessagesAsync(product, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Headers;
                }
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running put request, service returns
            /// a 200 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static ProductInner BeginPutAsyncRetrySucceeded(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner))
            {
                return operations.BeginPutAsyncRetrySucceededAsync(product).GetAwaiter().GetResult();
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running put request, service returns
            /// a 200 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ProductInner> BeginPutAsyncRetrySucceededAsync(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.BeginPutAsyncRetrySucceededWithHttpMessagesAsync(product, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running put request, service returns
            /// a 201 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’.  Polls return this value until the last poll
            /// returns a ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static ProductInner BeginPut201CreatingSucceeded200(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner))
            {
                return operations.BeginPut201CreatingSucceeded200Async(product).GetAwaiter().GetResult();
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running put request, service returns
            /// a 201 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’.  Polls return this value until the last poll
            /// returns a ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ProductInner> BeginPut201CreatingSucceeded200Async(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.BeginPut201CreatingSucceeded200WithHttpMessagesAsync(product, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running post request, service returns
            /// a 202 to the initial request, with 'Location' and 'Retry-After' headers,
            /// Polls return a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static LROsCustomHeaderPost202Retry200HeadersInner BeginPost202Retry200(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner))
            {
                return operations.BeginPost202Retry200Async(product).GetAwaiter().GetResult();
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running post request, service returns
            /// a 202 to the initial request, with 'Location' and 'Retry-After' headers,
            /// Polls return a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<LROsCustomHeaderPost202Retry200HeadersInner> BeginPost202Retry200Async(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.BeginPost202Retry200WithHttpMessagesAsync(product, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Headers;
                }
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running post request, service returns
            /// a 202 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static LROsCustomHeaderPostAsyncRetrySucceededHeadersInner BeginPostAsyncRetrySucceeded(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner))
            {
                return operations.BeginPostAsyncRetrySucceededAsync(product).GetAwaiter().GetResult();
            }

            /// <summary>
            /// x-ms-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0 is required
            /// message header for all requests. Long running post request, service returns
            /// a 202 to the initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<LROsCustomHeaderPostAsyncRetrySucceededHeadersInner> BeginPostAsyncRetrySucceededAsync(this ILROsCustomHeaderOperations operations, ProductInner product = default(ProductInner), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.BeginPostAsyncRetrySucceededWithHttpMessagesAsync(product, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Headers;
                }
            }

    }
}
