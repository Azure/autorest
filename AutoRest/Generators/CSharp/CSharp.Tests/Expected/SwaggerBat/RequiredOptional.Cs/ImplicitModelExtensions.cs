namespace Fixtures.SwaggerBatRequiredOptional
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class ImplicitModelExtensions
    {
            /// <summary>
            /// Test implicitly required path parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='pathParameter'>
            /// </param>
            public static Error GetRequiredPath(this IImplicitModel operations, string pathParameter)
            {
                return Task.Factory.StartNew(s => ((IImplicitModel)s).GetRequiredPathAsync(pathParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test implicitly required path parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='pathParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> GetRequiredPathAsync( this IImplicitModel operations, string pathParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.GetRequiredPathWithOperationResponseAsync(pathParameter, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test implicitly optional query parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='queryParameter'>
            /// </param>
            public static void PutOptionalQuery(this IImplicitModel operations, string queryParameter = default(string))
            {
                Task.Factory.StartNew(s => ((IImplicitModel)s).PutOptionalQueryAsync(queryParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test implicitly optional query parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='queryParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutOptionalQueryAsync( this IImplicitModel operations, string queryParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutOptionalQueryWithOperationResponseAsync(queryParameter, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test implicitly optional header parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='queryParameter'>
            /// </param>
            public static void PutOptionalHeader(this IImplicitModel operations, string queryParameter = default(string))
            {
                Task.Factory.StartNew(s => ((IImplicitModel)s).PutOptionalHeaderAsync(queryParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test implicitly optional header parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='queryParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutOptionalHeaderAsync( this IImplicitModel operations, string queryParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutOptionalHeaderWithOperationResponseAsync(queryParameter, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test implicitly optional body parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PutOptionalBody(this IImplicitModel operations, string bodyParameter = default(string))
            {
                Task.Factory.StartNew(s => ((IImplicitModel)s).PutOptionalBodyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test implicitly optional body parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutOptionalBodyAsync( this IImplicitModel operations, string bodyParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutOptionalBodyWithOperationResponseAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test implicitly required path parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='requiredGlobalPath'>
            /// number of items to skip
            /// </param>
            public static Error GetRequiredGlobalPath(this IImplicitModel operations, string requiredGlobalPath)
            {
                return Task.Factory.StartNew(s => ((IImplicitModel)s).GetRequiredGlobalPathAsync(requiredGlobalPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test implicitly required path parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='requiredGlobalPath'>
            /// number of items to skip
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> GetRequiredGlobalPathAsync( this IImplicitModel operations, string requiredGlobalPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.GetRequiredGlobalPathWithOperationResponseAsync(requiredGlobalPath, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test implicitly required query parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='requiredGlobalQuery'>
            /// number of items to skip
            /// </param>
            public static Error GetRequiredGlobalQuery(this IImplicitModel operations, string requiredGlobalQuery)
            {
                return Task.Factory.StartNew(s => ((IImplicitModel)s).GetRequiredGlobalQueryAsync(requiredGlobalQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test implicitly required query parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='requiredGlobalQuery'>
            /// number of items to skip
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> GetRequiredGlobalQueryAsync( this IImplicitModel operations, string requiredGlobalQuery, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.GetRequiredGlobalQueryWithOperationResponseAsync(requiredGlobalQuery, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test implicitly optional query parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='optionalGlobalQuery'>
            /// number of items to skip
            /// </param>
            public static Error GetOptionalGlobalQuery(this IImplicitModel operations, int? optionalGlobalQuery = default(int?))
            {
                return Task.Factory.StartNew(s => ((IImplicitModel)s).GetOptionalGlobalQueryAsync(optionalGlobalQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test implicitly optional query parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='optionalGlobalQuery'>
            /// number of items to skip
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> GetOptionalGlobalQueryAsync( this IImplicitModel operations, int? optionalGlobalQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.GetOptionalGlobalQueryWithOperationResponseAsync(optionalGlobalQuery, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
