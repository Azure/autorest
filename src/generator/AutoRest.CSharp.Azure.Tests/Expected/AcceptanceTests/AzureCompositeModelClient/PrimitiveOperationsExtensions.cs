// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsAzureCompositeModelClient
{
    using Microsoft.Rest;
   using Microsoft.Rest.Azure;
   using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for PrimitiveOperations.
    /// </summary>
    public static partial class PrimitiveOperationsExtensions
    {
            /// <summary>
            /// Get complex types with integer properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static IntWrapper GetInt(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetIntAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with integer properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<IntWrapper> GetIntAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetIntWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with integer properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put -1 and 2
            /// </param>
            public static void PutInt(this IPrimitiveOperations operations, IntWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutIntAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with integer properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put -1 and 2
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutIntAsync(this IPrimitiveOperations operations, IntWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutIntWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with long properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static LongWrapper GetLong(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetLongAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with long properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<LongWrapper> GetLongAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetLongWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with long properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 1099511627775 and -999511627788
            /// </param>
            public static void PutLong(this IPrimitiveOperations operations, LongWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutLongAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with long properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 1099511627775 and -999511627788
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutLongAsync(this IPrimitiveOperations operations, LongWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutLongWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with float properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static FloatWrapper GetFloat(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetFloatAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with float properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<FloatWrapper> GetFloatAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetFloatWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with float properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 1.05 and -0.003
            /// </param>
            public static void PutFloat(this IPrimitiveOperations operations, FloatWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutFloatAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with float properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 1.05 and -0.003
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutFloatAsync(this IPrimitiveOperations operations, FloatWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutFloatWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with double properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static DoubleWrapper GetDouble(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetDoubleAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with double properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<DoubleWrapper> GetDoubleAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetDoubleWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with double properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 3e-100 and
            /// -0.000000000000000000000000000000000000000000000000000000005
            /// </param>
            public static void PutDouble(this IPrimitiveOperations operations, DoubleWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutDoubleAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with double properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 3e-100 and
            /// -0.000000000000000000000000000000000000000000000000000000005
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutDoubleAsync(this IPrimitiveOperations operations, DoubleWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDoubleWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with bool properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static BooleanWrapper GetBool(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetBoolAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with bool properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<BooleanWrapper> GetBoolAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetBoolWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with bool properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put true and false
            /// </param>
            public static void PutBool(this IPrimitiveOperations operations, BooleanWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutBoolAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with bool properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put true and false
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutBoolAsync(this IPrimitiveOperations operations, BooleanWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutBoolWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with string properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static StringWrapper GetString(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetStringAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with string properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<StringWrapper> GetStringAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetStringWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with string properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 'goodrequest', '', and null
            /// </param>
            public static void PutString(this IPrimitiveOperations operations, StringWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutStringAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with string properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 'goodrequest', '', and null
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutStringAsync(this IPrimitiveOperations operations, StringWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutStringWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with date properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static DateWrapper GetDate(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetDateAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with date properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<DateWrapper> GetDateAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetDateWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with date properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put '0001-01-01' and '2016-02-29'
            /// </param>
            public static void PutDate(this IPrimitiveOperations operations, DateWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutDateAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with date properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put '0001-01-01' and '2016-02-29'
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutDateAsync(this IPrimitiveOperations operations, DateWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDateWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with datetime properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static DatetimeWrapper GetDateTime(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetDateTimeAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with datetime properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<DatetimeWrapper> GetDateTimeAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetDateTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with datetime properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put '0001-01-01T12:00:00-04:00' and '2015-05-18T11:38:00-08:00'
            /// </param>
            public static void PutDateTime(this IPrimitiveOperations operations, DatetimeWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutDateTimeAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with datetime properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put '0001-01-01T12:00:00-04:00' and '2015-05-18T11:38:00-08:00'
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutDateTimeAsync(this IPrimitiveOperations operations, DatetimeWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDateTimeWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with datetimeRfc1123 properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static Datetimerfc1123Wrapper GetDateTimeRfc1123(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetDateTimeRfc1123Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with datetimeRfc1123 properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Datetimerfc1123Wrapper> GetDateTimeRfc1123Async(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetDateTimeRfc1123WithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with datetimeRfc1123 properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 'Mon, 01 Jan 0001 12:00:00 GMT' and 'Mon, 18 May 2015 11:38:00
            /// GMT'
            /// </param>
            public static void PutDateTimeRfc1123(this IPrimitiveOperations operations, Datetimerfc1123Wrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutDateTimeRfc1123Async(complexBody), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with datetimeRfc1123 properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put 'Mon, 01 Jan 0001 12:00:00 GMT' and 'Mon, 18 May 2015 11:38:00
            /// GMT'
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutDateTimeRfc1123Async(this IPrimitiveOperations operations, Datetimerfc1123Wrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDateTimeRfc1123WithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with duration properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static DurationWrapper GetDuration(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetDurationAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with duration properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<DurationWrapper> GetDurationAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetDurationWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with duration properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='field'>
            /// </param>
            public static void PutDuration(this IPrimitiveOperations operations, System.TimeSpan? field = default(System.TimeSpan?))
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutDurationAsync(field), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with duration properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='field'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutDurationAsync(this IPrimitiveOperations operations, System.TimeSpan? field = default(System.TimeSpan?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDurationWithHttpMessagesAsync(field, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with byte properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static ByteWrapper GetByte(this IPrimitiveOperations operations)
            {
                return Task.Factory.StartNew(s => ((IPrimitiveOperations)s).GetByteAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with byte properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ByteWrapper> GetByteAsync(this IPrimitiveOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetByteWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with byte properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='field'>
            /// </param>
            public static void PutByte(this IPrimitiveOperations operations, byte[] field = default(byte[]))
            {
                Task.Factory.StartNew(s => ((IPrimitiveOperations)s).PutByteAsync(field), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with byte properties
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='field'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutByteAsync(this IPrimitiveOperations operations, byte[] field = default(byte[]), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutByteWithHttpMessagesAsync(field, null, cancellationToken).ConfigureAwait(false);
            }

    }
}

