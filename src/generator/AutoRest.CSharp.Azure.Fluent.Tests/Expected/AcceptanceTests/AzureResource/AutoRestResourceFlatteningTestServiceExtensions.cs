// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsAzureResource
{
    using Azure;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for AutoRestResourceFlatteningTestService.
    /// </summary>
    public static partial class AutoRestResourceFlatteningTestServiceExtensions
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
            public static void PutArray(this IAutoRestResourceFlatteningTestService operations, IList<ResourceInner> resourceArray = default(IList<ResourceInner>))
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
            public static async Task PutArrayAsync(this IAutoRestResourceFlatteningTestService operations, IList<ResourceInner> resourceArray = default(IList<ResourceInner>), CancellationToken cancellationToken = default(CancellationToken))
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
            public static IList<FlattenedProductInner> GetArray(this IAutoRestResourceFlatteningTestService operations)
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
            public static async Task<IList<FlattenedProductInner>> GetArrayAsync(this IAutoRestResourceFlatteningTestService operations, CancellationToken cancellationToken = default(CancellationToken))
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
            public static void PutDictionary(this IAutoRestResourceFlatteningTestService operations, IDictionary<string, FlattenedProductInner> resourceDictionary = default(IDictionary<string, FlattenedProductInner>))
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
            public static async Task PutDictionaryAsync(this IAutoRestResourceFlatteningTestService operations, IDictionary<string, FlattenedProductInner> resourceDictionary = default(IDictionary<string, FlattenedProductInner>), CancellationToken cancellationToken = default(CancellationToken))
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
            public static IDictionary<string, FlattenedProductInner> GetDictionary(this IAutoRestResourceFlatteningTestService operations)
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
            public static async Task<IDictionary<string, FlattenedProductInner>> GetDictionaryAsync(this IAutoRestResourceFlatteningTestService operations, CancellationToken cancellationToken = default(CancellationToken))
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
            public static void PutResourceCollection(this IAutoRestResourceFlatteningTestService operations, ResourceCollectionInner resourceComplexObject = default(ResourceCollectionInner))
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
            public static async Task PutResourceCollectionAsync(this IAutoRestResourceFlatteningTestService operations, ResourceCollectionInner resourceComplexObject = default(ResourceCollectionInner), CancellationToken cancellationToken = default(CancellationToken))
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
            public static ResourceCollectionInner GetResourceCollection(this IAutoRestResourceFlatteningTestService operations)
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
            public static async Task<ResourceCollectionInner> GetResourceCollectionAsync(this IAutoRestResourceFlatteningTestService operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetResourceCollectionWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
