// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsBodyInteger
{
    using System;		
    using System.Collections;		
    using System.Collections.Generic;		
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Extension methods for IntModel.
    /// </summary>
    public static partial class IntModelExtensions
    {
            /// <summary>
            /// Get null Int value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static int? GetNull(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetNullAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null Int value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<int?> GetNullAsync(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetNullWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Get invalid Int value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static int? GetInvalid(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetInvalidAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get invalid Int value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<int?> GetInvalidAsync(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetInvalidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Get overflow Int32 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static int? GetOverflowInt32(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetOverflowInt32Async(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get overflow Int32 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<int?> GetOverflowInt32Async(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetOverflowInt32WithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Get underflow Int32 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static int? GetUnderflowInt32(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetUnderflowInt32Async(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get underflow Int32 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<int?> GetUnderflowInt32Async(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetUnderflowInt32WithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Get overflow Int64 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static long? GetOverflowInt64(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetOverflowInt64Async(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get overflow Int64 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<long?> GetOverflowInt64Async(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetOverflowInt64WithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Get underflow Int64 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static long? GetUnderflowInt64(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetUnderflowInt64Async(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get underflow Int64 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<long?> GetUnderflowInt64Async(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetUnderflowInt64WithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put max int32 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            public static void PutMax32(this IIntModel operations, int intBody)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).PutMax32Async(intBody), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put max int32 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task PutMax32Async(this IIntModel operations, int intBody, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.PutMax32WithHttpMessagesAsync(intBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Put max int64 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            public static void PutMax64(this IIntModel operations, long intBody)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).PutMax64Async(intBody), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put max int64 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task PutMax64Async(this IIntModel operations, long intBody, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.PutMax64WithHttpMessagesAsync(intBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Put min int32 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            public static void PutMin32(this IIntModel operations, int intBody)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).PutMin32Async(intBody), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put min int32 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task PutMin32Async(this IIntModel operations, int intBody, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.PutMin32WithHttpMessagesAsync(intBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Put min int64 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            public static void PutMin64(this IIntModel operations, long intBody)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).PutMin64Async(intBody), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put min int64 value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task PutMin64Async(this IIntModel operations, long intBody, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.PutMin64WithHttpMessagesAsync(intBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get datetime encoded as Unix time value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static System.DateTime? GetUnixTime(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetUnixTimeAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get datetime encoded as Unix time value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<System.DateTime?> GetUnixTimeAsync(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetUnixTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put datetime encoded as Unix time
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            public static void PutUnixTimeDate(this IIntModel operations, System.DateTime intBody)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).PutUnixTimeDateAsync(intBody), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put datetime encoded as Unix time
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='intBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task PutUnixTimeDateAsync(this IIntModel operations, System.DateTime intBody, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.PutUnixTimeDateWithHttpMessagesAsync(intBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get invalid Unix time value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static System.DateTime? GetInvalidUnixTime(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetInvalidUnixTimeAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get invalid Unix time value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<System.DateTime?> GetInvalidUnixTimeAsync(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetInvalidUnixTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Get null Unix time value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static System.DateTime? GetNullUnixTime(this IIntModel operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IIntModel)s).GetNullUnixTimeAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null Unix time value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<System.DateTime?> GetNullUnixTimeAsync(this IIntModel operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetNullUnixTimeWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
