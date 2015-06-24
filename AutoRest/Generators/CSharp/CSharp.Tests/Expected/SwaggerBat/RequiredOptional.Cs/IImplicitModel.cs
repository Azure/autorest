namespace Fixtures.SwaggerBatRequiredOptional
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
    public partial interface IImplicitModel
    {
        /// <summary>
        /// Test implicitly required path parameter
        /// </summary>
        /// <param name='pathParameter'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> GetRequiredPathWithOperationResponseAsync(string pathParameter, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly optional query parameter
        /// </summary>
        /// <param name='queryParameter'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutOptionalQueryWithOperationResponseAsync(string queryParameter = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly optional header parameter
        /// </summary>
        /// <param name='queryParameter'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutOptionalHeaderWithOperationResponseAsync(string queryParameter = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly optional body parameter
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutOptionalBodyWithOperationResponseAsync(string bodyParameter = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly required path parameter
        /// </summary>
        /// <param name='requiredGlobalPath'>
        /// number of items to skip
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> GetRequiredGlobalPathWithOperationResponseAsync(string requiredGlobalPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly required query parameter
        /// </summary>
        /// <param name='requiredGlobalQuery'>
        /// number of items to skip
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> GetRequiredGlobalQueryWithOperationResponseAsync(string requiredGlobalQuery, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly optional query parameter
        /// </summary>
        /// <param name='optionalGlobalQuery'>
        /// number of items to skip
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> GetOptionalGlobalQueryWithOperationResponseAsync(int? optionalGlobalQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken));
    }
}
