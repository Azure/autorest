namespace Fixtures.SwaggerBatBodyInteger
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IIntModel
    {
        /// <summary>
        /// Get null Int value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<int?>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid Int value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<int?>> GetInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get overflow Int32 value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<int?>> GetOverflowInt32WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get underflow Int32 value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<int?>> GetUnderflowInt32WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get overflow Int64 value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<long?>> GetOverflowInt64WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get underflow Int64 value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<long?>> GetUnderflowInt64WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put max int32 value
        /// </summary>
        /// <param name='intBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutMax32WithOperationResponseAsync(int? intBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put max int64 value
        /// </summary>
        /// <param name='intBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutMax64WithOperationResponseAsync(long? intBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put min int32 value
        /// </summary>
        /// <param name='intBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutMin32WithOperationResponseAsync(int? intBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put min int64 value
        /// </summary>
        /// <param name='intBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutMin64WithOperationResponseAsync(long? intBody, CancellationToken cancellationToken = default(CancellationToken));
    }
}
