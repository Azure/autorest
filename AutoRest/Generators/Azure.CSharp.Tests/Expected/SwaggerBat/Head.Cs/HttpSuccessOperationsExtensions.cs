namespace Fixtures.Azure.SwaggerBatHead
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;

    public static partial class HttpSuccessOperationsExtensions
    {
            /// <summary>
            /// Return 204 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static bool? Head204(this IHttpSuccessOperations operations)
            {
                return Task.Factory.StartNew(s => ((IHttpSuccessOperations)s).Head204Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 204 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<bool?> Head204Async( this IHttpSuccessOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<bool?> result = await operations.Head204WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Return 404 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static bool? Head404(this IHttpSuccessOperations operations)
            {
                return Task.Factory.StartNew(s => ((IHttpSuccessOperations)s).Head404Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 404 status code if successful
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<bool?> Head404Async( this IHttpSuccessOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<bool?> result = await operations.Head404WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
