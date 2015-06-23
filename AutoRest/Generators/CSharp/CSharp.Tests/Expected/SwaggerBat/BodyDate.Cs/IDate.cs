namespace Fixtures.SwaggerBatBodyDate
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
    public partial interface IDate
    {
        /// <summary>
        /// Get null date value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid date value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetInvalidDateWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get overflow date value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetOverflowDateWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get underflow date value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetUnderflowDateWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put max date value 9999-12-31
        /// </summary>
        /// <param name='dateBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutMaxDateWithOperationResponseAsync(DateTime? dateBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get max date value 9999-12-31
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetMaxDateWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put min date value 0000-01-01
        /// </summary>
        /// <param name='dateBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutMinDateWithOperationResponseAsync(DateTime? dateBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get min date value 0000-01-01
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetMinDateWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
