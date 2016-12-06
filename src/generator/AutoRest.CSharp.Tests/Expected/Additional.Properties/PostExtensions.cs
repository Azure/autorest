// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AdditionalProperties
{
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for Post.
    /// </summary>
    public static partial class PostExtensions
    {
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='pet'>
            /// The pet JSON you want to post
            /// </param>
            public static void Pets(this IPost operations, Pet pet)
            {
                Task.Factory.StartNew(s => ((IPost)s).PetsAsync(pet), operations, CancellationToken.None, TaskCreationOptions.None,  TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='pet'>
            /// The pet JSON you want to post
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PetsAsync(this IPost operations, Pet pet, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PetsWithHttpMessagesAsync(pet, null, cancellationToken).ConfigureAwait(false);
            }

    }
}

