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
    public partial interface ISubscriptionInCredentialsOperations
    {
        /// <summary>
        /// POST method with subscriptionId modeled in credentials.  Set the
        /// credential subscriptionId to &apos;1234-5678-9012-3456&apos; to
        /// succeed
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostMethodGlobalValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in credentials.  Set the
        /// credential subscriptionId to null, and client-side validation
        /// should prevent you from making this call
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostMethodGlobalNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in credentials.  Set the
        /// credential subscriptionId to &apos;1234-5678-9012-3456&apos; to
        /// succeed
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostMethodGlobalNotProvidedValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in credentials.  Set the
        /// credential subscriptionId to &apos;1234-5678-9012-3456&apos; to
        /// succeed
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostPathGlobalValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in credentials.  Set the
        /// credential subscriptionId to &apos;1234-5678-9012-3456&apos; to
        /// succeed
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostSwaggerGlobalValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
