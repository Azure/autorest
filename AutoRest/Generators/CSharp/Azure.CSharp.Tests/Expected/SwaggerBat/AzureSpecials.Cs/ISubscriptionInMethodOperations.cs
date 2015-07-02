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
        /// subscription id = '1234-5678-9012-3456' to succeed
        /// </summary>
        /// <param name='subscriptionId'>
        /// This should appear as a method parameter, use value
        /// '1234-5678-9012-3456'
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostMethodLocalValidWithOperationResponseAsync(string subscriptionId, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in the method.  pass in
        /// subscription id = null, client-side validation should prevent you
        /// from making this call
        /// </summary>
        /// <param name='subscriptionId'>
        /// This should appear as a method parameter, use value null,
        /// client-side validation should prvenet the call
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostMethodLocalNullWithOperationResponseAsync(string subscriptionId, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in the method.  pass in
        /// subscription id = '1234-5678-9012-3456' to succeed
        /// </summary>
        /// <param name='subscriptionId'>
        /// Should appear as a method parameter -use value
        /// '1234-5678-9012-3456'
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostPathLocalValidWithOperationResponseAsync(string subscriptionId, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// POST method with subscriptionId modeled in the method.  pass in
        /// subscription id = '1234-5678-9012-3456' to succeed
        /// </summary>
        /// <param name='subscriptionId'>
        /// The subscriptionId, which appears in the path, the value is always
        /// '1234-5678-9012-3456'
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostSwaggerLocalValidWithOperationResponseAsync(string subscriptionId, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
