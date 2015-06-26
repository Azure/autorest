namespace Fixtures.Azure.SwaggerBatAzureSpecials
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    public static partial class ApiVersionDefaultOperationsExtensions
    {
            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void GetMethodGlobalValid(this IApiVersionDefaultOperations operations)
            {
                Task.Factory.StartNew(s => ((IApiVersionDefaultOperations)s).GetMethodGlobalValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetMethodGlobalValidAsync( this IApiVersionDefaultOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetMethodGlobalValidWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void GetMethodGlobalNotProvidedValid(this IApiVersionDefaultOperations operations)
            {
                Task.Factory.StartNew(s => ((IApiVersionDefaultOperations)s).GetMethodGlobalNotProvidedValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetMethodGlobalNotProvidedValidAsync( this IApiVersionDefaultOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetMethodGlobalNotProvidedValidWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void GetPathGlobalValid(this IApiVersionDefaultOperations operations)
            {
                Task.Factory.StartNew(s => ((IApiVersionDefaultOperations)s).GetPathGlobalValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetPathGlobalValidAsync( this IApiVersionDefaultOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetPathGlobalValidWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void GetSwaggerGlobalValid(this IApiVersionDefaultOperations operations)
            {
                Task.Factory.StartNew(s => ((IApiVersionDefaultOperations)s).GetSwaggerGlobalValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetSwaggerGlobalValidAsync( this IApiVersionDefaultOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetSwaggerGlobalValidWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

    }
}
