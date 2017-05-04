// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsBodyBoolean
{
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for BoolModel.
    /// </summary>
    public static partial class BoolModelExtensions
    {
            /// <summary>
            /// Get true Boolean value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static bool? GetTrue(this IBoolModel operations)
            {
                return operations.GetTrueAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get true Boolean value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<bool?> GetTrueAsync(this IBoolModel operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetTrueWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Set Boolean value true
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='boolBody'>
            /// </param>
            public static void PutTrue(this IBoolModel operations, bool boolBody)
            {
                operations.PutTrueAsync(boolBody).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set Boolean value true
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='boolBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutTrueAsync(this IBoolModel operations, bool boolBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PutTrueWithHttpMessagesAsync(boolBody, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Get false Boolean value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static bool? GetFalse(this IBoolModel operations)
            {
                return operations.GetFalseAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get false Boolean value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<bool?> GetFalseAsync(this IBoolModel operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetFalseWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Set Boolean value false
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='boolBody'>
            /// </param>
            public static void PutFalse(this IBoolModel operations, bool boolBody)
            {
                operations.PutFalseAsync(boolBody).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set Boolean value false
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='boolBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutFalseAsync(this IBoolModel operations, bool boolBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PutFalseWithHttpMessagesAsync(boolBody, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Get null Boolean value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static bool? GetNull(this IBoolModel operations)
            {
                return operations.GetNullAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null Boolean value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<bool?> GetNullAsync(this IBoolModel operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetNullWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Get invalid Boolean value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static bool? GetInvalid(this IBoolModel operations)
            {
                return operations.GetInvalidAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get invalid Boolean value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<bool?> GetInvalidAsync(this IBoolModel operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetInvalidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
