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
    public partial interface ISubscriptionInMethodOperations
    {
        /// <summary>
        /// POST method with subscriptionId modeled in the method.  pass in
        /// subscription id = &apos;1234-5678-9012-3456&apos; to succeed
        /// </summary>
        /// <param name='subscriptionId'>
        /// This should appear as a method parameter, use value
        /// &apos;1234-5678-9012-3456&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostMethodLocalValidWithOperationResponseAsync(string subscriptionId, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in the method.  pass in
        /// subscription id = null, client-side validation should prevent you
        /// from making this call
        /// </summary>
        /// <param name='subscriptionId'>
        /// This should appear as a method parameter, use value null,
        /// client-side validation should prvenet the call
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostMethodLocalNullWithOperationResponseAsync(string subscriptionId, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in the method.  pass in
        /// subscription id = &apos;1234-5678-9012-3456&apos; to succeed
        /// </summary>
        /// <param name='subscriptionId'>
        /// Should appear as a method parameter -use value
        /// &apos;1234-5678-9012-3456&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostPathLocalValidWithOperationResponseAsync(string subscriptionId, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in the method.  pass in
        /// subscription id = &apos;1234-5678-9012-3456&apos; to succeed
        /// </summary>
        /// <param name='subscriptionId'>
        /// The subscriptionId, which appears in the path, the value is always
        /// &apos;1234-5678-9012-3456&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostSwaggerLocalValidWithOperationResponseAsync(string subscriptionId, CancellationToken cancellationToken = default(CancellationToken));
    }
}
