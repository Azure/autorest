namespace Fixtures.MirrorRecursiveTypes
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Some cool documentation.
    /// </summary>
    public partial interface IRecursiveTypesAPI
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        /// <summary>
        /// The Products endpoint returns information about the Uber products
        /// offered at a given location. The response includes the display
        /// name and other details about each product, and lists the products
        /// in the proper display order.
        /// </summary>
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
        Task<HttpOperationResponse<Product>> PostWithOperationResponseAsync(string subscriptionId, string resourceGroupName, string apiVersion, Product body = default(Product), CancellationToken cancellationToken = default(CancellationToken));

    }
}
