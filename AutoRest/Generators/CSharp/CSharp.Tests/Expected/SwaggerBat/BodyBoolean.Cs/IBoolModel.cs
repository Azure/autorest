namespace Fixtures.SwaggerBatBodyBoolean
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
    public partial interface IBoolModel
    {
        /// <summary>
        /// Get true Boolean value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<bool?>> GetTrueWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set Boolean value true
        /// </summary>
        /// <param name='boolBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutTrueWithOperationResponseAsync(bool? boolBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get false Boolean value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<bool?>> GetFalseWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set Boolean value false
        /// </summary>
        /// <param name='boolBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutFalseWithOperationResponseAsync(bool? boolBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null Boolean value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<bool?>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid Boolean value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<bool?>> GetInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
