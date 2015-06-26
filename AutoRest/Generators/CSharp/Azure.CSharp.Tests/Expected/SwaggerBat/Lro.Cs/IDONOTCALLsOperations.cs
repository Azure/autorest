namespace Fixtures.Azure.SwaggerBatLro
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
    public partial interface IDONOTCALLsOperations
    {
        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetProvisioning202Accepted200SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with
        /// ProvisioningState=’Failed’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetProvisioning202Deleting200FailedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with
        /// ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetProvisioning202Deleting200canceledWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with no
        /// location header
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetDelete202Retry200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with no
        /// location header
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Get202NoRetry204WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request poller, service returns a ‘200’ with a
        /// Product.  Client should return with successf rom long-running
        /// operation
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Post202Retry200PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request poller, service returns a ‘204&apos;
        /// with no enetity body.  Client should return with success from
        /// long-running operation
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Post202NoRetry204PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a 500, then a
        /// ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetRetryProvisioning202Accepted200SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a 500, then a
        /// ‘200’ with no location header
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetRetry202Retry200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request poller, service returns a 500, then a
        /// ‘200’ with a Product.  Client should return with successf rom
        /// long-running operation
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> PostRetry202Retry200PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// DO NOT CALL THIS METHOD. For completion only
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetNonRetry400WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a 400 with an
        /// error body
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetRetry202NonRetry400WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request poller, service returns a 500, then a
        /// ‘200’ with a Product.  Client should return with successf rom
        /// long-running operation
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> PostRetry202Retry400PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request poller, service returns a 400 with an
        /// error body
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> PostRetry202NonRetry400PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
