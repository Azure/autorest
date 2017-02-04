// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsHead
{
    using Azure;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for HttpSuccessOperations.
    /// </summary>
    public static partial class HttpSuccessOperationsExtensions
    {
            /// <summary>
            /// Return 200 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static bool Head200(this IHttpSuccessOperations operations)
            {
                return operations.Head200Async().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 200 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<bool> Head200Async(this IHttpSuccessOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.Head200WithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Return 204 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static bool Head204(this IHttpSuccessOperations operations)
            {
                return operations.Head204Async().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 204 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<bool> Head204Async(this IHttpSuccessOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.Head204WithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Return 404 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static bool Head404(this IHttpSuccessOperations operations)
            {
                return operations.Head404Async().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 404 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<bool> Head404Async(this IHttpSuccessOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.Head404WithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
