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
    public partial interface ISkipUrlEncodingOperations
    {
        /// <summary>
        /// Get method with unencoded path parameter with value
        /// &apos;path1/path2/path3&apos;
        /// </summary>
        /// <param name='unencodedPathParam'>
        /// Unencoded path parameter with value &apos;path1/path2/path3&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodPathValidWithOperationResponseAsync(string unencodedPathParam, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded path parameter with value
        /// &apos;path1/path2/path3&apos;
        /// </summary>
        /// <param name='unencodedPathParam'>
        /// Unencoded path parameter with value &apos;path1/path2/path3&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetPathPathValidWithOperationResponseAsync(string unencodedPathParam, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded path parameter with value
        /// &apos;path1/path2/path3&apos;
        /// </summary>
        /// <param name='unencodedPathParam'>
        /// An unencoded path parameter with value
        /// &apos;path1/path2/path3&apos;. Possible values for this parameter
        /// include: &apos;path1/path2/path3&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetSwaggerPathValidWithOperationResponseAsync(string unencodedPathParam, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded query parameter with value
        /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
        /// </summary>
        /// <param name='q1'>
        /// Unencoded query parameter with value
        /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodQueryValidWithOperationResponseAsync(string q1, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded query parameter with value null
        /// </summary>
        /// <param name='q1'>
        /// Unencoded query parameter with value null
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodQueryNullWithOperationResponseAsync(string q1 = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded query parameter with value
        /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
        /// </summary>
        /// <param name='q1'>
        /// Unencoded query parameter with value
        /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetPathQueryValidWithOperationResponseAsync(string q1, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded query parameter with value
        /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
        /// </summary>
        /// <param name='q1'>
        /// An unencoded query parameter with value
        /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;. Possible values
        /// for this parameter include:
        /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetSwaggerQueryValidWithOperationResponseAsync(string q1 = default(string), CancellationToken cancellationToken = default(CancellationToken));
    }
}
