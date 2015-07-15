namespace Fixtures.MirrorRecursiveTypes
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Newtonsoft.Json;
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
        /// Gets or sets json serialization settings.
        /// </summary>
        JsonSerializerSettings SerializationSettings { get; }

        /// <summary>
        /// Gets or sets json deserialization settings.
        /// </summary>
        JsonSerializerSettings DeserializationSettings { get; }        


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
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>        
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Product>> PostWithHttpMessagesAsync(string subscriptionId, string resourceGroupName, string apiVersion, Product body = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

    }
}
