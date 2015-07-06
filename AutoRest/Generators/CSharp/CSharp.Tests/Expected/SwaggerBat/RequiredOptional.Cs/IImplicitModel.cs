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
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> GetRequiredPathWithHttpMessagesAsync(string pathParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly optional query parameter
        /// </summary>
        /// <param name='queryParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutOptionalQueryWithHttpMessagesAsync(string queryParameter = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly optional header parameter
        /// </summary>
        /// <param name='queryParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutOptionalHeaderWithHttpMessagesAsync(string queryParameter = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly optional body parameter
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutOptionalBodyWithHttpMessagesAsync(string bodyParameter = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly required path parameter
        /// </summary>
        /// <param name='requiredGlobalPath'>
        /// number of items to skip
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> GetRequiredGlobalPathWithHttpMessagesAsync(string requiredGlobalPath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly required query parameter
        /// </summary>
        /// <param name='requiredGlobalQuery'>
        /// number of items to skip
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> GetRequiredGlobalQueryWithHttpMessagesAsync(string requiredGlobalQuery, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test implicitly optional query parameter
        /// </summary>
        /// <param name='optionalGlobalQuery'>
        /// number of items to skip
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> GetOptionalGlobalQueryWithHttpMessagesAsync(int? optionalGlobalQuery = default(int?), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
