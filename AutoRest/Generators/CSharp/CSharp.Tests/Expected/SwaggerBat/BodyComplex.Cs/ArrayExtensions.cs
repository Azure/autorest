namespace Fixtures.SwaggerBatBodyComplex
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class ArrayExtensions
    {
            /// <summary>
            /// Get complex types with array property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ArrayWrapper GetValid(this IArray operations)
            {
                return Task.Factory.StartNew(s => ((IArray)s).GetValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with array property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ArrayWrapper> GetValidAsync( this IArray operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<ArrayWrapper> result = await operations.GetValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put complex types with array property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='complexBody'>
            /// Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y",
            /// "The quick brown fox jumps over the lazy dog"
            /// </param>
            public static void PutValid(this IArray operations, ArrayWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IArray)s).PutValidAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with array property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='complexBody'>
            /// Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y",
            /// "The quick brown fox jumps over the lazy dog"
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutValidAsync( this IArray operations, ArrayWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutValidWithOperationResponseAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with array property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ArrayWrapper GetEmpty(this IArray operations)
            {
                return Task.Factory.StartNew(s => ((IArray)s).GetEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with array property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ArrayWrapper> GetEmptyAsync( this IArray operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<ArrayWrapper> result = await operations.GetEmptyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put complex types with array property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='complexBody'>
            /// Please put an empty array
            /// </param>
            public static void PutEmpty(this IArray operations, ArrayWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IArray)s).PutEmptyAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with array property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='complexBody'>
            /// Please put an empty array
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutEmptyAsync( this IArray operations, ArrayWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutEmptyWithOperationResponseAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with array property while server doesn't provide a
            /// response payload
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ArrayWrapper GetNotProvided(this IArray operations)
            {
                return Task.Factory.StartNew(s => ((IArray)s).GetNotProvidedAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with array property while server doesn't provide a
            /// response payload
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ArrayWrapper> GetNotProvidedAsync( this IArray operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<ArrayWrapper> result = await operations.GetNotProvidedWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
