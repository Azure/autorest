namespace Fixtures.SwaggerBatBodyComplex
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
    public partial interface IArray
    {
        /// <summary>
        /// Get complex types with array property
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<ArrayWrapper>> GetValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with array property
        /// </summary>
        /// <param name='complexBody'>
        /// Please put an array with 4 items: "1, 2, 3, 4", "", null,
        /// "&S#$(*Y", "The quick brown fox jumps over the lazy dog"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutValidWithOperationResponseAsync(ArrayWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with array property which is empty
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<ArrayWrapper>> GetEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with array property which is empty
        /// </summary>
        /// <param name='complexBody'>
        /// Please put an empty array
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutEmptyWithOperationResponseAsync(ArrayWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with array property while server doesn't provide
        /// a response payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<ArrayWrapper>> GetNotProvidedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
