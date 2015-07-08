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
        /// 'path1/path2/path3'
        /// </summary>
        /// <param name='unencodedPathParam'>
        /// Unencoded path parameter with value 'path1/path2/path3'
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodPathValidWithHttpMessagesAsync(string unencodedPathParam, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded path parameter with value
        /// 'path1/path2/path3'
        /// </summary>
        /// <param name='unencodedPathParam'>
        /// Unencoded path parameter with value 'path1/path2/path3'
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetPathPathValidWithHttpMessagesAsync(string unencodedPathParam, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded path parameter with value
        /// 'path1/path2/path3'
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetSwaggerPathValidWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded query parameter with value
        /// 'value1&amp;q2=value2&amp;q3=value3'
        /// </summary>
        /// <param name='q1'>
        /// Unencoded query parameter with value
        /// 'value1&amp;q2=value2&amp;q3=value3'
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodQueryValidWithHttpMessagesAsync(string q1, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded query parameter with value null
        /// </summary>
        /// <param name='q1'>
        /// Unencoded query parameter with value null
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetMethodQueryNullWithHttpMessagesAsync(string q1 = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded query parameter with value
        /// 'value1&amp;q2=value2&amp;q3=value3'
        /// </summary>
        /// <param name='q1'>
        /// Unencoded query parameter with value
        /// 'value1&amp;q2=value2&amp;q3=value3'
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetPathQueryValidWithHttpMessagesAsync(string q1, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get method with unencoded query parameter with value
        /// 'value1&amp;q2=value2&amp;q3=value3'
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> GetSwaggerQueryValidWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
