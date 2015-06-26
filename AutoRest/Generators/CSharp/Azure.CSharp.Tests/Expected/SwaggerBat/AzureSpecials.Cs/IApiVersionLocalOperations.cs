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
    public partial interface IApiVersionLocalOperations
    {
        /// <summary>
        /// Get method with api-version modeled in the method.  pass in
        /// api-version = '2.0' to succeed
        /// </summary>
        /// <param name='apiVersion'>
        /// This should appear as a method parameter, use value '2.0'.
        /// Possible values for this parameter include: '2.0'
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodLocalValidWithOperationResponseAsync(string apiVersion, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with api-version modeled in the method.  pass in
        /// api-version = null to succeed
        /// </summary>
        /// <param name='apiVersion'>
        /// This should appear as a method parameter, use value null, this
        /// should result in no serialized parameter
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodLocalNullWithOperationResponseAsync(string apiVersion = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with api-version modeled in the method.  pass in
        /// api-version = '2.0' to succeed
        /// </summary>
        /// <param name='apiVersion'>
        /// This should appear as a method parameter, use value '2.0'.
        /// Possible values for this parameter include: '2.0'
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetPathLocalValidWithOperationResponseAsync(string apiVersion, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with api-version modeled in the method.  pass in
        /// api-version = '2.0' to succeed
        /// </summary>
        /// <param name='apiVersion'>
        /// The api version, which appears in the query, the value is always
        /// '2.0'. Possible values for this parameter include: '2.0'
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetSwaggerLocalValidWithOperationResponseAsync(string apiVersion, CancellationToken cancellationToken = default(CancellationToken));
    }
}
