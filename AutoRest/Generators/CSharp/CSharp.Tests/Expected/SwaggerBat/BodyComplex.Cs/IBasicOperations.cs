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
    public partial interface IBasicOperations
    {
        /// <summary>
        /// Get complex type {id: 2, name: 'abc', color: 'YELLOW'}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Basic>> GetValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Please put {id: 2, name: 'abc', color: 'Magenta'}
        /// </summary>
        /// <param name='complexBody'>
        /// Please put {id: 2, name: 'abc', color: 'Magenta'}
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutValidWithOperationResponseAsync(Basic complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a basic complex type that is invalid for the local strong type
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Basic>> GetInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a basic complex type that is empty
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Basic>> GetEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a basic complex type whose properties are null
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Basic>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a basic complex type while the server doesn't provide a
        /// response payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Basic>> GetNotProvidedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
