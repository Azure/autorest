// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsAzureCompositeModelClient
{
    using System;		
    using System.Collections;		
    using System.Collections.Generic;		
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;

    /// <summary>
    /// Extension methods for ArrayOperations.
    /// </summary>
    public static partial class ArrayOperationsExtensions
    {
            /// <summary>
            /// Get complex types with array property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static ArrayWrapper GetValid(this IArrayOperations operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IArrayOperations)s).GetValidAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with array property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<ArrayWrapper> GetValidAsync(this IArrayOperations operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetValidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with array property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='array'>
            /// </param>
            public static void PutValid(this IArrayOperations operations, System.Collections.Generic.IList<string> array = default(System.Collections.Generic.IList<string>))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IArrayOperations)s).PutValidAsync(array), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with array property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='array'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task PutValidAsync(this IArrayOperations operations, System.Collections.Generic.IList<string> array = default(System.Collections.Generic.IList<string>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.PutValidWithHttpMessagesAsync(array, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with array property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static ArrayWrapper GetEmpty(this IArrayOperations operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IArrayOperations)s).GetEmptyAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with array property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<ArrayWrapper> GetEmptyAsync(this IArrayOperations operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetEmptyWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types with array property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='array'>
            /// </param>
            public static void PutEmpty(this IArrayOperations operations, System.Collections.Generic.IList<string> array = default(System.Collections.Generic.IList<string>))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IArrayOperations)s).PutEmptyAsync(array), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with array property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='array'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task PutEmptyAsync(this IArrayOperations operations, System.Collections.Generic.IList<string> array = default(System.Collections.Generic.IList<string>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.PutEmptyWithHttpMessagesAsync(array, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with array property while server doesn't provide a
            /// response payload
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static ArrayWrapper GetNotProvided(this IArrayOperations operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IArrayOperations)s).GetNotProvidedAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with array property while server doesn't provide a
            /// response payload
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<ArrayWrapper> GetNotProvidedAsync(this IArrayOperations operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetNotProvidedWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
