namespace Fixtures.Azure.SwaggerBatResourceFlattening
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    /// <summary>
    /// Resource Flattening for AutoRest
    /// </summary>
    public partial interface IAutoRestResourceFlatteningTestService : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        /// <summary>
        /// Put External Resource as an Array
        /// </summary>
        /// <param name='resourceArray'>
        /// External Resource as an Array to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PutArrayWithOperationResponseAsync(IList<Resource> resourceArray = default(IList<Resource>), CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Get External Resource as an Array
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<IList<FlattenedProduct>>> GetArrayWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Put External Resource as a Dictionary
        /// </summary>
        /// <param name='resourceDictionary'>
        /// External Resource as a Dictionary to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PutDictionaryWithOperationResponseAsync(IDictionary<string, FlattenedProduct> resourceDictionary = default(IDictionary<string, FlattenedProduct>), CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Get External Resource as a Dictionary
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<IDictionary<string, FlattenedProduct>>> GetDictionaryWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Put External Resource as a ResourceCollection
        /// </summary>
        /// <param name='resourceComplexObject'>
        /// External Resource as a ResourceCollection to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PutResourceCollectionWithOperationResponseAsync(ResourceCollection resourceComplexObject = default(ResourceCollection), CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Get External Resource as a ResourceCollection
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<ResourceCollection>> GetResourceCollectionWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));

    }
}
