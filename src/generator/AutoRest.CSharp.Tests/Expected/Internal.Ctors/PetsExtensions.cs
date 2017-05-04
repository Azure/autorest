// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.InternalCtors
{
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for Pets.
    /// </summary>
    public static partial class PetsExtensions
    {
            /// <summary>
            /// Gets a pet from the store
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static void Get(this IPets operations)
            {
                operations.GetAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets a pet from the store
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task GetAsync(this IPets operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.GetWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

    }
}
