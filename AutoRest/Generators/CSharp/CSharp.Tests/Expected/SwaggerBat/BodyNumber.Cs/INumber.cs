namespace Fixtures.SwaggerBatBodyNumber
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface INumber
    {
        /// <summary>
        /// Get null Number value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid float Number value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetInvalidFloatWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid double Number value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetInvalidDoubleWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put big float value 3.402823e+20
        /// </summary>
        /// <param name='numberBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutBigFloatWithOperationResponseAsync(double? numberBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get big float value 3.402823e+20
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetBigFloatWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put big double value 2.5976931e+101
        /// </summary>
        /// <param name='numberBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutBigDoubleWithOperationResponseAsync(double? numberBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get big double value 2.5976931e+101
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetBigDoubleWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put big double value 99999999.99
        /// </summary>
        /// <param name='numberBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutBigDoublePositiveDecimalWithOperationResponseAsync(double? numberBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get big double value 99999999.99
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetBigDoublePositiveDecimalWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put big double value -99999999.99
        /// </summary>
        /// <param name='numberBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutBigDoubleNegativeDecimalWithOperationResponseAsync(double? numberBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get big double value -99999999.99
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetBigDoubleNegativeDecimalWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put small float value 3.402823e-20
        /// </summary>
        /// <param name='numberBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutSmallFloatWithOperationResponseAsync(double? numberBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get big double value 3.402823e-20
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetSmallFloatWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put small double value 2.5976931e-101
        /// </summary>
        /// <param name='numberBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutSmallDoubleWithOperationResponseAsync(double? numberBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get big double value 2.5976931e-101
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<double?>> GetSmallDoubleWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
