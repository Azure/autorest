namespace Fixtures.SwaggerBatBodyDateTime
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
    public partial interface IDatetime
    {
        /// <summary>
        /// Get null datetime value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid datetime value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get overflow datetime value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetOverflowWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get underflow datetime value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetUnderflowWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put max datetime value 9999-12-31T23:59:59.9999999Z
        /// </summary>
        /// <param name='datetimeBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutUtcMaxDateTimeWithOperationResponseAsync(DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get max datetime value 9999-12-31t23:59:59.9999999z
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetUtcLowercaseMaxDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get max datetime value 9999-12-31T23:59:59.9999999Z
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetUtcUppercaseMaxDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put max datetime value with positive numoffset
        /// 9999-12-31t23:59:59.9999999+14:00
        /// </summary>
        /// <param name='datetimeBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutLocalPositiveOffsetMaxDateTimeWithOperationResponseAsync(DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get max datetime value with positive num offset
        /// 9999-12-31t23:59:59.9999999+14:00
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetLocalPositiveOffsetLowercaseMaxDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get max datetime value with positive num offset
        /// 9999-12-31T23:59:59.9999999+14:00
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetLocalPositiveOffsetUppercaseMaxDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put max datetime value with positive numoffset
        /// 9999-12-31t23:59:59.9999999-14:00
        /// </summary>
        /// <param name='datetimeBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutLocalNegativeOffsetMaxDateTimeWithOperationResponseAsync(DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get max datetime value with positive num offset
        /// 9999-12-31T23:59:59.9999999-14:00
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetLocalNegativeOffsetUppercaseMaxDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get max datetime value with positive num offset
        /// 9999-12-31t23:59:59.9999999-14:00
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetLocalNegativeOffsetLowercaseMaxDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put min datetime value 0001-01-01T00:00:00Z
        /// </summary>
        /// <param name='datetimeBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutUtcMinDateTimeWithOperationResponseAsync(DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get min datetime value 0001-01-01T00:00:00Z
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetUtcMinDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put min datetime value 0001-01-01T00:00:00+14:00
        /// </summary>
        /// <param name='datetimeBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutLocalPositiveOffsetMinDateTimeWithOperationResponseAsync(DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get min datetime value 0001-01-01T00:00:00+14:00
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetLocalPositiveOffsetMinDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put min datetime value 0001-01-01T00:00:00-14:00
        /// </summary>
        /// <param name='datetimeBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutLocalNegativeOffsetMinDateTimeWithOperationResponseAsync(DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get min datetime value 0001-01-01T00:00:00-14:00
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateTime?>> GetLocalNegativeOffsetMinDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
