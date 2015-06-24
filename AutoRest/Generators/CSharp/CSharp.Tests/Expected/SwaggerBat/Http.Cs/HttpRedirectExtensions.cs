using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest;
using Fixtures.SwaggerBatHttp.Models;

namespace Fixtures.SwaggerBatHttp
{
    public static partial class HttpRedirectExtensions
    {
            /// <summary>
            /// Redirect get with 307
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void Get307(this IHttpRedirect operations)
            {
                Task.Factory.StartNew(s => ((IHttpRedirect)s).Get307Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Redirect get with 307
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task Get307Async( this IHttpRedirect operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Get307WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

    }
}
