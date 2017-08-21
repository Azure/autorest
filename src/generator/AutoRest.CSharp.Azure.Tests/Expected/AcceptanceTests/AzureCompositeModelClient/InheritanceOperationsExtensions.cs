// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.Azure.AcceptanceTestsAzureCompositeModelClient
{
    using Fixtures.Azure;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for InheritanceOperations.
    /// </summary>
    public static partial class InheritanceOperationsExtensions
    {
            /// <summary>
            /// Get complex types that extend others
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static Siamese GetValid(this IInheritanceOperations operations)
            {
                return operations.GetValidAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types that extend others
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Siamese> GetValidAsync(this IInheritanceOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetValidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put complex types that extend others
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put a siamese with id=2, name="Siameee", color=green, breed=persion,
            /// which hates 2 dogs, the 1st one named "Potato" with id=1 and food="tomato",
            /// and the 2nd one named "Tomato" with id=-1 and food="french fries".
            /// </param>
            public static void PutValid(this IInheritanceOperations operations, Siamese complexBody)
            {
                operations.PutValidAsync(complexBody).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types that extend others
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put a siamese with id=2, name="Siameee", color=green, breed=persion,
            /// which hates 2 dogs, the 1st one named "Potato" with id=1 and food="tomato",
            /// and the 2nd one named "Tomato" with id=-1 and food="french fries".
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutValidAsync(this IInheritanceOperations operations, Siamese complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PutValidWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

    }
}
