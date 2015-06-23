namespace Fixtures.SwaggerBatBodyComplex
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
    public partial interface IPrimitive
    {
        /// <summary>
        /// Get complex types with integer properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IntWrapper>> GetIntWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with integer properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put -1 and 2
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutIntWithOperationResponseAsync(IntWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with long properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<LongWrapper>> GetLongWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with long properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put 1099511627775 and -999511627788
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutLongWithOperationResponseAsync(LongWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with float properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<FloatWrapper>> GetFloatWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with float properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put 1.05 and -0.003
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutFloatWithOperationResponseAsync(FloatWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with double properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DoubleWrapper>> GetDoubleWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with double properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put 3e-100 and
        /// -0.000000000000000000000000000000000000000000000000000000005
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDoubleWithOperationResponseAsync(DoubleWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with bool properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<BooleanWrapper>> GetBoolWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with bool properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put true and false
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutBoolWithOperationResponseAsync(BooleanWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with string properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<StringWrapper>> GetStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with string properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put 'goodrequest', '', and null
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutStringWithOperationResponseAsync(StringWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with date properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DateWrapper>> GetDateWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with date properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put '0001-01-01' and '2016-02-29'
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDateWithOperationResponseAsync(DateWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with datetime properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DatetimeWrapper>> GetDateTimeWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with datetime properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put '0001-01-01T12:00:00-04:00' and
        /// '2015-05-18T11:38:00-08:00'
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDateTimeWithOperationResponseAsync(DatetimeWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with byte properties
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<ByteWrapper>> GetByteWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with byte properties
        /// </summary>
        /// <param name='complexBody'>
        /// Please put non-ascii byte string hex(FF FE FD FC 00 FA F9 F8 F7 F6)
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutByteWithOperationResponseAsync(ByteWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
    }
}
