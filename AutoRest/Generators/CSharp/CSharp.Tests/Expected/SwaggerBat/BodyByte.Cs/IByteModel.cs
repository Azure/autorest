namespace Fixtures.SwaggerBatBodyByte
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest Swagger BAT
    /// </summary>
    public partial interface IByteModel
    {
        /// <summary>
        /// Get null byte value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<byte[]>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get empty byte value &apos;&apos;
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<byte[]>> GetEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get non-ascii byte string hex(FF FE FD FC FB FA F9 F8 F7 F6)
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<byte[]>> GetNonAsciiWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put non-ascii byte string hex(FF FE FD FC FB FA F9 F8 F7 F6)
        /// </summary>
        /// <param name='byteBody'>
        /// Base64-encoded non-ascii byte string hex(FF FE FD FC FB FA F9 F8
        /// F7 F6)
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutNonAsciiWithOperationResponseAsync(byte[] byteBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid byte value &apos;:::SWAGGER::::&apos;
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<byte[]>> GetInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
