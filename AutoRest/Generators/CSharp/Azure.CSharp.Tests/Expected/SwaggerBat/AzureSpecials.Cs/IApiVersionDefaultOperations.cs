namespace Fixtures.Azure.SwaggerBatAzureSpecials
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IApiVersionDefaultOperations
    {
        /// <summary>
        /// GET method with api-version modeled in global settings.
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodGlobalValidWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// GET method with api-version modeled in global settings.
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodGlobalNotProvidedValidWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// GET method with api-version modeled in global settings.
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetPathGlobalValidWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// GET method with api-version modeled in global settings.
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetSwaggerGlobalValidWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
