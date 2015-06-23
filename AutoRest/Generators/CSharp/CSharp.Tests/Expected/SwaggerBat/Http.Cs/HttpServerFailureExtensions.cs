namespace Fixtures.SwaggerBatHttp
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class HttpServerFailureExtensions
    {
            /// <summary>
            /// Return 501 status code - should be represented in the client as an error
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Error Head501(this IHttpServerFailure operations)
            {
                return Task.Factory.StartNew(s => ((IHttpServerFailure)s).Head501Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 501 status code - should be represented in the client as an error
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> Head501Async( this IHttpServerFailure operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.Head501WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Return 501 status code - should be represented in the client as an error
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Error Get501(this IHttpServerFailure operations)
            {
                return Task.Factory.StartNew(s => ((IHttpServerFailure)s).Get501Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 501 status code - should be represented in the client as an error
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> Get501Async( this IHttpServerFailure operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.Get501WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Return 505 status code - should be represented in the client as an error
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            public static Error Post505(this IHttpServerFailure operations, bool? booleanValue = default(bool?))
            {
                return Task.Factory.StartNew(s => ((IHttpServerFailure)s).Post505Async(booleanValue), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 505 status code - should be represented in the client as an error
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> Post505Async( this IHttpServerFailure operations, bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.Post505WithOperationResponseAsync(booleanValue, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Return 505 status code - should be represented in the client as an error
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            public static Error Delete505(this IHttpServerFailure operations, bool? booleanValue = default(bool?))
            {
                return Task.Factory.StartNew(s => ((IHttpServerFailure)s).Delete505Async(booleanValue), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 505 status code - should be represented in the client as an error
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> Delete505Async( this IHttpServerFailure operations, bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.Delete505WithOperationResponseAsync(booleanValue, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
