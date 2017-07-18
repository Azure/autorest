// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.AcceptanceTestsUrlMultiCollectionFormat
{
    using Models;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for Queries.
    /// </summary>
    public static partial class QueriesExtensions
    {
            /// <summary>
            /// Get a null array of string using the multi-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='arrayQuery'>
            /// a null array of string using the multi-array format
            /// </param>
            public static void ArrayStringMultiNull(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                operations.ArrayStringMultiNullAsync(arrayQuery).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a null array of string using the multi-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='arrayQuery'>
            /// a null array of string using the multi-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task ArrayStringMultiNullAsync(this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.ArrayStringMultiNullWithHttpMessagesAsync(arrayQuery, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Get an empty array [] of string using the multi-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='arrayQuery'>
            /// an empty array [] of string using the multi-array format
            /// </param>
            public static void ArrayStringMultiEmpty(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                operations.ArrayStringMultiEmptyAsync(arrayQuery).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an empty array [] of string using the multi-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='arrayQuery'>
            /// an empty array [] of string using the multi-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task ArrayStringMultiEmptyAsync(this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.ArrayStringMultiEmptyWithHttpMessagesAsync(arrayQuery, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Get an array of string ['ArrayQuery1', 'begin!*'();:@ &amp;=+$,/?#[]end' ,
            /// null, ''] using the mult-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string ['ArrayQuery1', 'begin!*'();:@ &amp;=+$,/?#[]end' ,
            /// null, ''] using the mult-array format
            /// </param>
            public static void ArrayStringMultiValid(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                operations.ArrayStringMultiValidAsync(arrayQuery).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an array of string ['ArrayQuery1', 'begin!*'();:@ &amp;=+$,/?#[]end' ,
            /// null, ''] using the mult-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string ['ArrayQuery1', 'begin!*'();:@ &amp;=+$,/?#[]end' ,
            /// null, ''] using the mult-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task ArrayStringMultiValidAsync(this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.ArrayStringMultiValidWithHttpMessagesAsync(arrayQuery, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

    }
}
