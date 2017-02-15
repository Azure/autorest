// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsAzureResource
{
    using Fixtures.Azure;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for AutoRestResourceFlatteningTestServiceClient.
    /// </summary>
    public static partial class AutoRestResourceFlatteningTestServiceClientExtensions
    {
            /// <summary>
            /// Put External Resource as an Array
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceArray'>
            /// External Resource as an Array to put
            /// </param>
            public static void PutArray(this IAutoRestResourceFlatteningTestServiceClient operations, IList<Resource> resourceArray = default(IList<Resource>))
            {
                operations.PutArrayAsync(resourceArray).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put External Resource as an Array
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceArray'>
            /// External Resource as an Array to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutArrayAsync(this IAutoRestResourceFlatteningTestServiceClient operations, IList<Resource> resourceArray = default(IList<Resource>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutArrayWithHttpMessagesAsync(resourceArray, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get External Resource as an Array
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static IList<FlattenedProduct> GetArray(this IAutoRestResourceFlatteningTestServiceClient operations)
            {
                return operations.GetArrayAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get External Resource as an Array
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<IList<FlattenedProduct>> GetArrayAsync(this IAutoRestResourceFlatteningTestServiceClient operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetArrayWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put External Resource as a Dictionary
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceDictionary'>
            /// External Resource as a Dictionary to put
            /// </param>
            public static void PutDictionary(this IAutoRestResourceFlatteningTestServiceClient operations, IDictionary<string, FlattenedProduct> resourceDictionary = default(IDictionary<string, FlattenedProduct>))
            {
                operations.PutDictionaryAsync(resourceDictionary).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put External Resource as a Dictionary
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceDictionary'>
            /// External Resource as a Dictionary to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutDictionaryAsync(this IAutoRestResourceFlatteningTestServiceClient operations, IDictionary<string, FlattenedProduct> resourceDictionary = default(IDictionary<string, FlattenedProduct>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDictionaryWithHttpMessagesAsync(resourceDictionary, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get External Resource as a Dictionary
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static IDictionary<string, FlattenedProduct> GetDictionary(this IAutoRestResourceFlatteningTestServiceClient operations)
            {
                return operations.GetDictionaryAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get External Resource as a Dictionary
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<IDictionary<string, FlattenedProduct>> GetDictionaryAsync(this IAutoRestResourceFlatteningTestServiceClient operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetDictionaryWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Put External Resource as a ResourceCollection
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceComplexObject'>
            /// External Resource as a ResourceCollection to put
            /// </param>
            public static void PutResourceCollection(this IAutoRestResourceFlatteningTestServiceClient operations, ResourceCollection resourceComplexObject = default(ResourceCollection))
            {
                operations.PutResourceCollectionAsync(resourceComplexObject).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put External Resource as a ResourceCollection
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceComplexObject'>
            /// External Resource as a ResourceCollection to put
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PutResourceCollectionAsync(this IAutoRestResourceFlatteningTestServiceClient operations, ResourceCollection resourceComplexObject = default(ResourceCollection), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutResourceCollectionWithHttpMessagesAsync(resourceComplexObject, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get External Resource as a ResourceCollection
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static ResourceCollection GetResourceCollection(this IAutoRestResourceFlatteningTestServiceClient operations)
            {
                return operations.GetResourceCollectionAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get External Resource as a ResourceCollection
            /// <see href="http://tempuri.org" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ResourceCollection> GetResourceCollectionAsync(this IAutoRestResourceFlatteningTestServiceClient operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetResourceCollectionWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}

