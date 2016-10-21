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
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((IInheritanceOperations)s).GetValidAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
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
            public static async System.Threading.Tasks.Task<Siamese> GetValidAsync(this IInheritanceOperations operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
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
            /// Please put a siamese with id=2, name="Siameee", color=green,
            /// breed=persion, which hates 2 dogs, the 1st one named "Potato" with id=1
            /// and food="tomato", and the 2nd one named "Tomato" with id=-1 and
            /// food="french fries".
            /// </param>
            public static void PutValid(this IInheritanceOperations operations, Siamese complexBody)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IInheritanceOperations)s).PutValidAsync(complexBody), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types that extend others
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put a siamese with id=2, name="Siameee", color=green,
            /// breed=persion, which hates 2 dogs, the 1st one named "Potato" with id=1
            /// and food="tomato", and the 2nd one named "Tomato" with id=-1 and
            /// food="french fries".
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task PutValidAsync(this IInheritanceOperations operations, Siamese complexBody, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.PutValidWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

    }
}
