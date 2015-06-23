namespace Fixtures.Azure.SwaggerBatPaging
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
    /// Long-running Operation for AutoRest
    /// </summary>
    public partial interface IPagingOperations
    {
        /// <summary>
        /// A paging operation that finishes on the first call without a
        /// nextlink
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetSinglePagesWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that includes a nextLink that has 10 pages
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that fails on the first call with 500 and then
        /// retries and then get a response including a nextLink that has 10
        /// pages
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesRetryFirstWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that includes a nextLink that has 10 pages, of
        /// which the 2nd call fails first with 500. The client should retry
        /// and finish all 10 pages eventually.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesRetrySecondWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that receives a 400 on the first call
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetSinglePagesFailureWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that receives a 400 on the second call
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesFailureWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that receives an invalid nextLink
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesFailureUriWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that finishes on the first call without a
        /// nextlink
        /// </summary>
        /// <param name='nextLink'>
        /// NextLink from the previous successful call to List operation.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetSinglePagesNextWithOperationResponseAsync(string nextLink, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that includes a nextLink that has 10 pages
        /// </summary>
        /// <param name='nextLink'>
        /// NextLink from the previous successful call to List operation.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesNextWithOperationResponseAsync(string nextLink, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that fails on the first call with 500 and then
        /// retries and then get a response including a nextLink that has 10
        /// pages
        /// </summary>
        /// <param name='nextLink'>
        /// NextLink from the previous successful call to List operation.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesRetryFirstNextWithOperationResponseAsync(string nextLink, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that includes a nextLink that has 10 pages, of
        /// which the 2nd call fails first with 500. The client should retry
        /// and finish all 10 pages eventually.
        /// </summary>
        /// <param name='nextLink'>
        /// NextLink from the previous successful call to List operation.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesRetrySecondNextWithOperationResponseAsync(string nextLink, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that receives a 400 on the first call
        /// </summary>
        /// <param name='nextLink'>
        /// NextLink from the previous successful call to List operation.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetSinglePagesFailureNextWithOperationResponseAsync(string nextLink, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that receives a 400 on the second call
        /// </summary>
        /// <param name='nextLink'>
        /// NextLink from the previous successful call to List operation.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesFailureNextWithOperationResponseAsync(string nextLink, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// A paging operation that receives an invalid nextLink
        /// </summary>
        /// <param name='nextLink'>
        /// NextLink from the previous successful call to List operation.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ProductResult>> GetMultiplePagesFailureUriNextWithOperationResponseAsync(string nextLink, CancellationToken cancellationToken = default(CancellationToken));
    }
}
