namespace Fixtures.Azure.SwaggerBatResourceFlattening
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    public static partial class AutoRestResourceFlatteningTestServiceExtensions
    {
            /// <summary>
            /// Put External Resource as an Array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='resourceArray'>
            /// External Resource as an Array to put
            /// </param>
            public static void PutArray(this IAutoRestResourceFlatteningTestService operations, IList<Resource> resourceArray = default(IList<Resource>))
            {
                Task.Factory.StartNew(s => ((IAutoRestResourceFlatteningTestService)s).PutArrayAsync(resourceArray), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put External Resource as an Array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='resourceArray'>
            /// External Resource as an Array to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutArrayAsync( this IAutoRestResourceFlatteningTestService operations, IList<Resource> resourceArray = default(IList<Resource>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutArrayWithOperationResponseAsync(resourceArray, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get External Resource as an Array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IList<FlattenedProduct> GetArray(this IAutoRestResourceFlatteningTestService operations)
            {
                return Task.Factory.StartNew(s => ((IAutoRestResourceFlatteningTestService)s).GetArrayAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get External Resource as an Array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IList<FlattenedProduct>> GetArrayAsync( this IAutoRestResourceFlatteningTestService operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<IList<FlattenedProduct>> result = await operations.GetArrayWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put External Resource as a Dictionary
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='resourceDictionary'>
            /// External Resource as a Dictionary to put
            /// </param>
            public static void PutDictionary(this IAutoRestResourceFlatteningTestService operations, IDictionary<string, FlattenedProduct> resourceDictionary = default(IDictionary<string, FlattenedProduct>))
            {
                Task.Factory.StartNew(s => ((IAutoRestResourceFlatteningTestService)s).PutDictionaryAsync(resourceDictionary), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put External Resource as a Dictionary
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='resourceDictionary'>
            /// External Resource as a Dictionary to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutDictionaryAsync( this IAutoRestResourceFlatteningTestService operations, IDictionary<string, FlattenedProduct> resourceDictionary = default(IDictionary<string, FlattenedProduct>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDictionaryWithOperationResponseAsync(resourceDictionary, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get External Resource as a Dictionary
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, FlattenedProduct> GetDictionary(this IAutoRestResourceFlatteningTestService operations)
            {
                return Task.Factory.StartNew(s => ((IAutoRestResourceFlatteningTestService)s).GetDictionaryAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get External Resource as a Dictionary
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, FlattenedProduct>> GetDictionaryAsync( this IAutoRestResourceFlatteningTestService operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<IDictionary<string, FlattenedProduct>> result = await operations.GetDictionaryWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put External Resource as a ResourceCollection
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='resourceComplexObject'>
            /// External Resource as a ResourceCollection to put
            /// </param>
            public static void PutResourceCollection(this IAutoRestResourceFlatteningTestService operations, ResourceCollection resourceComplexObject = default(ResourceCollection))
            {
                Task.Factory.StartNew(s => ((IAutoRestResourceFlatteningTestService)s).PutResourceCollectionAsync(resourceComplexObject), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put External Resource as a ResourceCollection
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='resourceComplexObject'>
            /// External Resource as a ResourceCollection to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutResourceCollectionAsync( this IAutoRestResourceFlatteningTestService operations, ResourceCollection resourceComplexObject = default(ResourceCollection), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutResourceCollectionWithOperationResponseAsync(resourceComplexObject, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get External Resource as a ResourceCollection
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static ResourceCollection GetResourceCollection(this IAutoRestResourceFlatteningTestService operations)
            {
                return Task.Factory.StartNew(s => ((IAutoRestResourceFlatteningTestService)s).GetResourceCollectionAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get External Resource as a ResourceCollection
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<ResourceCollection> GetResourceCollectionAsync( this IAutoRestResourceFlatteningTestService operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<ResourceCollection> result = await operations.GetResourceCollectionWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
