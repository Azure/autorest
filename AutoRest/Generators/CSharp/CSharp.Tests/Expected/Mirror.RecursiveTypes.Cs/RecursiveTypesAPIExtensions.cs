namespace Fixtures.MirrorRecursiveTypes
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class RecursiveTypesAPIExtensions
    {
            /// <summary>
            /// The Products endpoint returns information about the Uber products offered
            /// at a given location. The response includes the display name and other
            /// details about each product, and lists the products in the proper display
            /// order.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='subscriptionId'>
            /// Subscription Id.
            /// </param>
            /// <param name='resourceGroupName'>
            /// Resource Group Id.
            /// </param>
            /// <param name='apiVersion'>
            /// API Id.
            /// </param>
            /// <param name='body'>
            /// API body mody.
            /// </param>
            public static Product Post(this IRecursiveTypesAPI operations, string subscriptionId, string resourceGroupName, string apiVersion, Product body = default(Product))
            {
                return Task.Factory.StartNew(s => ((IRecursiveTypesAPI)s).PostAsync(subscriptionId, resourceGroupName, apiVersion, body), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// The Products endpoint returns information about the Uber products offered
            /// at a given location. The response includes the display name and other
            /// details about each product, and lists the products in the proper display
            /// order.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='subscriptionId'>
            /// Subscription Id.
            /// </param>
            /// <param name='resourceGroupName'>
            /// Resource Group Id.
            /// </param>
            /// <param name='apiVersion'>
            /// API Id.
            /// </param>
            /// <param name='body'>
            /// API body mody.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> PostAsync( this IRecursiveTypesAPI operations, string subscriptionId, string resourceGroupName, string apiVersion, Product body = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Product> result = await operations.PostWithOperationResponseAsync(subscriptionId, resourceGroupName, apiVersion, body, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
