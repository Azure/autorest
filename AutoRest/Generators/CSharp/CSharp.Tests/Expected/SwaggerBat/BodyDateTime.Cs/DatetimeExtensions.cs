namespace Fixtures.SwaggerBatBodyDateTime
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class DatetimeExtensions
    {
            /// <summary>
            /// Get null datetime value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetNull(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null datetime value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetNullAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetNullWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get invalid datetime value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetInvalid(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetInvalidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get invalid datetime value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetInvalidAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetInvalidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get overflow datetime value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetOverflow(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetOverflowAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get overflow datetime value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetOverflowAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetOverflowWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get underflow datetime value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetUnderflow(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetUnderflowAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get underflow datetime value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetUnderflowAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetUnderflowWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put max datetime value 9999-12-31T23:59:59.9999999Z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            public static void PutUtcMaxDateTime(this IDatetime operations, DateTime? datetimeBody)
            {
                Task.Factory.StartNew(s => ((IDatetime)s).PutUtcMaxDateTimeAsync(datetimeBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put max datetime value 9999-12-31T23:59:59.9999999Z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutUtcMaxDateTimeAsync( this IDatetime operations, DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutUtcMaxDateTimeWithHttpMessagesAsync(datetimeBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get max datetime value 9999-12-31t23:59:59.9999999z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetUtcLowercaseMaxDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetUtcLowercaseMaxDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get max datetime value 9999-12-31t23:59:59.9999999z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetUtcLowercaseMaxDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetUtcLowercaseMaxDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get max datetime value 9999-12-31T23:59:59.9999999Z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetUtcUppercaseMaxDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetUtcUppercaseMaxDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get max datetime value 9999-12-31T23:59:59.9999999Z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetUtcUppercaseMaxDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetUtcUppercaseMaxDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put max datetime value with positive numoffset
            /// 9999-12-31t23:59:59.9999999+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            public static void PutLocalPositiveOffsetMaxDateTime(this IDatetime operations, DateTime? datetimeBody)
            {
                Task.Factory.StartNew(s => ((IDatetime)s).PutLocalPositiveOffsetMaxDateTimeAsync(datetimeBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put max datetime value with positive numoffset
            /// 9999-12-31t23:59:59.9999999+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutLocalPositiveOffsetMaxDateTimeAsync( this IDatetime operations, DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutLocalPositiveOffsetMaxDateTimeWithHttpMessagesAsync(datetimeBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get max datetime value with positive num offset
            /// 9999-12-31t23:59:59.9999999+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetLocalPositiveOffsetLowercaseMaxDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetLocalPositiveOffsetLowercaseMaxDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get max datetime value with positive num offset
            /// 9999-12-31t23:59:59.9999999+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetLocalPositiveOffsetLowercaseMaxDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetLocalPositiveOffsetLowercaseMaxDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get max datetime value with positive num offset
            /// 9999-12-31T23:59:59.9999999+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetLocalPositiveOffsetUppercaseMaxDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetLocalPositiveOffsetUppercaseMaxDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get max datetime value with positive num offset
            /// 9999-12-31T23:59:59.9999999+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetLocalPositiveOffsetUppercaseMaxDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetLocalPositiveOffsetUppercaseMaxDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put max datetime value with positive numoffset
            /// 9999-12-31t23:59:59.9999999-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            public static void PutLocalNegativeOffsetMaxDateTime(this IDatetime operations, DateTime? datetimeBody)
            {
                Task.Factory.StartNew(s => ((IDatetime)s).PutLocalNegativeOffsetMaxDateTimeAsync(datetimeBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put max datetime value with positive numoffset
            /// 9999-12-31t23:59:59.9999999-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutLocalNegativeOffsetMaxDateTimeAsync( this IDatetime operations, DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutLocalNegativeOffsetMaxDateTimeWithHttpMessagesAsync(datetimeBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get max datetime value with positive num offset
            /// 9999-12-31T23:59:59.9999999-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetLocalNegativeOffsetUppercaseMaxDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetLocalNegativeOffsetUppercaseMaxDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get max datetime value with positive num offset
            /// 9999-12-31T23:59:59.9999999-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetLocalNegativeOffsetUppercaseMaxDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetLocalNegativeOffsetUppercaseMaxDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get max datetime value with positive num offset
            /// 9999-12-31t23:59:59.9999999-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetLocalNegativeOffsetLowercaseMaxDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetLocalNegativeOffsetLowercaseMaxDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get max datetime value with positive num offset
            /// 9999-12-31t23:59:59.9999999-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetLocalNegativeOffsetLowercaseMaxDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetLocalNegativeOffsetLowercaseMaxDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put min datetime value 0001-01-01T00:00:00Z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            public static void PutUtcMinDateTime(this IDatetime operations, DateTime? datetimeBody)
            {
                Task.Factory.StartNew(s => ((IDatetime)s).PutUtcMinDateTimeAsync(datetimeBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put min datetime value 0001-01-01T00:00:00Z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutUtcMinDateTimeAsync( this IDatetime operations, DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutUtcMinDateTimeWithHttpMessagesAsync(datetimeBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get min datetime value 0001-01-01T00:00:00Z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetUtcMinDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetUtcMinDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get min datetime value 0001-01-01T00:00:00Z
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetUtcMinDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetUtcMinDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put min datetime value 0001-01-01T00:00:00+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            public static void PutLocalPositiveOffsetMinDateTime(this IDatetime operations, DateTime? datetimeBody)
            {
                Task.Factory.StartNew(s => ((IDatetime)s).PutLocalPositiveOffsetMinDateTimeAsync(datetimeBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put min datetime value 0001-01-01T00:00:00+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutLocalPositiveOffsetMinDateTimeAsync( this IDatetime operations, DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutLocalPositiveOffsetMinDateTimeWithHttpMessagesAsync(datetimeBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get min datetime value 0001-01-01T00:00:00+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetLocalPositiveOffsetMinDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetLocalPositiveOffsetMinDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get min datetime value 0001-01-01T00:00:00+14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetLocalPositiveOffsetMinDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetLocalPositiveOffsetMinDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put min datetime value 0001-01-01T00:00:00-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            public static void PutLocalNegativeOffsetMinDateTime(this IDatetime operations, DateTime? datetimeBody)
            {
                Task.Factory.StartNew(s => ((IDatetime)s).PutLocalNegativeOffsetMinDateTimeAsync(datetimeBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put min datetime value 0001-01-01T00:00:00-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datetimeBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutLocalNegativeOffsetMinDateTimeAsync( this IDatetime operations, DateTime? datetimeBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutLocalNegativeOffsetMinDateTimeWithHttpMessagesAsync(datetimeBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get min datetime value 0001-01-01T00:00:00-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static DateTime? GetLocalNegativeOffsetMinDateTime(this IDatetime operations)
            {
                return Task.Factory.StartNew(s => ((IDatetime)s).GetLocalNegativeOffsetMinDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get min datetime value 0001-01-01T00:00:00-14:00
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DateTime?> GetLocalNegativeOffsetMinDateTimeAsync( this IDatetime operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DateTime?> result = await operations.GetLocalNegativeOffsetMinDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
