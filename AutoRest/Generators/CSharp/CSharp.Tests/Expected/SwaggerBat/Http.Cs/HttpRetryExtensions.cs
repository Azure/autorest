namespace Fixtures.SwaggerBatHttp
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class HttpRetryExtensions
    {
            /// <summary>
            /// Return 408 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void Head408(this IHttpRetry operations)
            {
                Task.Factory.StartNew(s => ((IHttpRetry)s).Head408Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 408 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task Head408Async( this IHttpRetry operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Head408WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Return 500 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            public static void Put500(this IHttpRetry operations, bool? booleanValue = default(bool?))
            {
                Task.Factory.StartNew(s => ((IHttpRetry)s).Put500Async(booleanValue), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 500 status code, then 200 after retry
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
            public static async Task Put500Async( this IHttpRetry operations, bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Put500WithOperationResponseAsync(booleanValue, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Return 500 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            public static void Patch500(this IHttpRetry operations, bool? booleanValue = default(bool?))
            {
                Task.Factory.StartNew(s => ((IHttpRetry)s).Patch500Async(booleanValue), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 500 status code, then 200 after retry
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
            public static async Task Patch500Async( this IHttpRetry operations, bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Patch500WithOperationResponseAsync(booleanValue, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Return 502 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void Get502(this IHttpRetry operations)
            {
                Task.Factory.StartNew(s => ((IHttpRetry)s).Get502Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 502 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task Get502Async( this IHttpRetry operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Get502WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Return 503 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            public static void Post503(this IHttpRetry operations, bool? booleanValue = default(bool?))
            {
                Task.Factory.StartNew(s => ((IHttpRetry)s).Post503Async(booleanValue), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 503 status code, then 200 after retry
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
            public static async Task Post503Async( this IHttpRetry operations, bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Post503WithOperationResponseAsync(booleanValue, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Return 503 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            public static void Delete503(this IHttpRetry operations, bool? booleanValue = default(bool?))
            {
                Task.Factory.StartNew(s => ((IHttpRetry)s).Delete503Async(booleanValue), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 503 status code, then 200 after retry
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
            public static async Task Delete503Async( this IHttpRetry operations, bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Delete503WithOperationResponseAsync(booleanValue, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Return 504 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            public static void Put504(this IHttpRetry operations, bool? booleanValue = default(bool?))
            {
                Task.Factory.StartNew(s => ((IHttpRetry)s).Put504Async(booleanValue), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 504 status code, then 200 after retry
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
            public static async Task Put504Async( this IHttpRetry operations, bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Put504WithOperationResponseAsync(booleanValue, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Return 504 status code, then 200 after retry
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='booleanValue'>
            /// Simple boolean value true
            /// </param>
            public static void Patch504(this IHttpRetry operations, bool? booleanValue = default(bool?))
            {
                Task.Factory.StartNew(s => ((IHttpRetry)s).Patch504Async(booleanValue), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Return 504 status code, then 200 after retry
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
            public static async Task Patch504Async( this IHttpRetry operations, bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Patch504WithOperationResponseAsync(booleanValue, cancellationToken).ConfigureAwait(false);
            }

    }
}
