namespace Fixtures.Azure.SwaggerBatPaging
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    public static partial class PagingOperationsExtensions
    {
            /// <summary>
            /// A paging operation that finishes on the first call without a nextlink
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ProductResult GetSinglePages(this IPagingOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetSinglePagesAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that finishes on the first call without a nextlink
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetSinglePagesAsync( this IPagingOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetSinglePagesWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that includes a nextLink that has 10 pages
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ProductResult GetMultiplePages(this IPagingOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that includes a nextLink that has 10 pages
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesAsync( this IPagingOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that fails on the first call with 500 and then retries
            /// and then get a response including a nextLink that has 10 pages
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ProductResult GetMultiplePagesRetryFirst(this IPagingOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesRetryFirstAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that fails on the first call with 500 and then retries
            /// and then get a response including a nextLink that has 10 pages
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesRetryFirstAsync( this IPagingOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesRetryFirstWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that includes a nextLink that has 10 pages, of which
            /// the 2nd call fails first with 500. The client should retry and finish all
            /// 10 pages eventually.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ProductResult GetMultiplePagesRetrySecond(this IPagingOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesRetrySecondAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that includes a nextLink that has 10 pages, of which
            /// the 2nd call fails first with 500. The client should retry and finish all
            /// 10 pages eventually.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesRetrySecondAsync( this IPagingOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesRetrySecondWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that receives a 400 on the first call
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ProductResult GetSinglePagesFailure(this IPagingOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetSinglePagesFailureAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that receives a 400 on the first call
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetSinglePagesFailureAsync( this IPagingOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetSinglePagesFailureWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that receives a 400 on the second call
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ProductResult GetMultiplePagesFailure(this IPagingOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesFailureAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that receives a 400 on the second call
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesFailureAsync( this IPagingOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesFailureWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that receives an invalid nextLink
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ProductResult GetMultiplePagesFailureUri(this IPagingOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesFailureUriAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that receives an invalid nextLink
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesFailureUriAsync( this IPagingOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesFailureUriWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that finishes on the first call without a nextlink
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            public static ProductResult GetSinglePagesNext(this IPagingOperations operations, string nextLink)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetSinglePagesNextAsync(nextLink), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that finishes on the first call without a nextlink
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetSinglePagesNextAsync( this IPagingOperations operations, string nextLink, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetSinglePagesNextWithOperationResponseAsync(nextLink, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that includes a nextLink that has 10 pages
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            public static ProductResult GetMultiplePagesNext(this IPagingOperations operations, string nextLink)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesNextAsync(nextLink), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that includes a nextLink that has 10 pages
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesNextAsync( this IPagingOperations operations, string nextLink, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesNextWithOperationResponseAsync(nextLink, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that fails on the first call with 500 and then retries
            /// and then get a response including a nextLink that has 10 pages
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            public static ProductResult GetMultiplePagesRetryFirstNext(this IPagingOperations operations, string nextLink)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesRetryFirstNextAsync(nextLink), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that fails on the first call with 500 and then retries
            /// and then get a response including a nextLink that has 10 pages
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesRetryFirstNextAsync( this IPagingOperations operations, string nextLink, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesRetryFirstNextWithOperationResponseAsync(nextLink, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that includes a nextLink that has 10 pages, of which
            /// the 2nd call fails first with 500. The client should retry and finish all
            /// 10 pages eventually.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            public static ProductResult GetMultiplePagesRetrySecondNext(this IPagingOperations operations, string nextLink)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesRetrySecondNextAsync(nextLink), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that includes a nextLink that has 10 pages, of which
            /// the 2nd call fails first with 500. The client should retry and finish all
            /// 10 pages eventually.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesRetrySecondNextAsync( this IPagingOperations operations, string nextLink, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesRetrySecondNextWithOperationResponseAsync(nextLink, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that receives a 400 on the first call
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            public static ProductResult GetSinglePagesFailureNext(this IPagingOperations operations, string nextLink)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetSinglePagesFailureNextAsync(nextLink), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that receives a 400 on the first call
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetSinglePagesFailureNextAsync( this IPagingOperations operations, string nextLink, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetSinglePagesFailureNextWithOperationResponseAsync(nextLink, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that receives a 400 on the second call
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            public static ProductResult GetMultiplePagesFailureNext(this IPagingOperations operations, string nextLink)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesFailureNextAsync(nextLink), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that receives a 400 on the second call
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesFailureNextAsync( this IPagingOperations operations, string nextLink, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesFailureNextWithOperationResponseAsync(nextLink, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// A paging operation that receives an invalid nextLink
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            public static ProductResult GetMultiplePagesFailureUriNext(this IPagingOperations operations, string nextLink)
            {
                return Task.Factory.StartNew(s => ((IPagingOperations)s).GetMultiplePagesFailureUriNextAsync(nextLink), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// A paging operation that receives an invalid nextLink
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='nextLink'>
            /// NextLink from the previous successful call to List operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ProductResult> GetMultiplePagesFailureUriNextAsync( this IPagingOperations operations, string nextLink, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ProductResult> result = await operations.GetMultiplePagesFailureUriNextWithOperationResponseAsync(nextLink, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
