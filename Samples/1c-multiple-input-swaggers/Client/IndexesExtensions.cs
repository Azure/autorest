// Code generated by Microsoft (R) AutoRest Code Generator 1.0.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Searchservice
{
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for Indexes.
    /// </summary>
    public static partial class IndexesExtensions
    {
            /// <summary>
            /// Creates a new Azure Search index.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798941.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='index'>
            /// The definition of the index to create.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static Index Create(this IIndexes operations, Index index, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.CreateAsync(index, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates a new Azure Search index.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798941.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='index'>
            /// The definition of the index to create.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Index> CreateAsync(this IIndexes operations, Index index, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.CreateWithHttpMessagesAsync(index, searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Lists all indexes available for an Azure Search service.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798923.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='select'>
            /// Selects which properties of the index definitions to retrieve. Specified as
            /// a comma-separated list of JSON property names, or '*' for all properties.
            /// The default is all properties.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static IndexListResult List(this IIndexes operations, string select = default(string), SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.ListAsync(select, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Lists all indexes available for an Azure Search service.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798923.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='select'>
            /// Selects which properties of the index definitions to retrieve. Specified as
            /// a comma-separated list of JSON property names, or '*' for all properties.
            /// The default is all properties.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<IndexListResult> ListAsync(this IIndexes operations, string select = default(string), SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.ListWithHttpMessagesAsync(select, searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Creates a new Azure Search index or updates an index if it already exists.
            /// <see href="https://msdn.microsoft.com/library/azure/dn800964.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='indexName'>
            /// The definition of the index to create or update.
            /// </param>
            /// <param name='index'>
            /// The definition of the index to create or update.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static Index CreateOrUpdate(this IIndexes operations, string indexName, Index index, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.CreateOrUpdateAsync(indexName, index, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates a new Azure Search index or updates an index if it already exists.
            /// <see href="https://msdn.microsoft.com/library/azure/dn800964.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='indexName'>
            /// The definition of the index to create or update.
            /// </param>
            /// <param name='index'>
            /// The definition of the index to create or update.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Index> CreateOrUpdateAsync(this IIndexes operations, string indexName, Index index, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.CreateOrUpdateWithHttpMessagesAsync(indexName, index, searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Deletes an Azure Search index and all the documents it contains.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798926.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='indexName'>
            /// The name of the index to delete.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static void Delete(this IIndexes operations, string indexName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                operations.DeleteAsync(indexName, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Deletes an Azure Search index and all the documents it contains.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798926.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='indexName'>
            /// The name of the index to delete.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task DeleteAsync(this IIndexes operations, string indexName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.DeleteWithHttpMessagesAsync(indexName, searchRequestOptions, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Retrieves an index definition from Azure Search.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798939.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='indexName'>
            /// The name of the index to retrieve.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static Index Get(this IIndexes operations, string indexName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.GetAsync(indexName, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Retrieves an index definition from Azure Search.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798939.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='indexName'>
            /// The name of the index to retrieve.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Index> GetAsync(this IIndexes operations, string indexName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetWithHttpMessagesAsync(indexName, searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Returns statistics for the given index, including a document count and
            /// storage usage.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798942.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='indexName'>
            /// The name of the index for which to retrieve statistics.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static IndexGetStatisticsResult GetStatistics(this IIndexes operations, string indexName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.GetStatisticsAsync(indexName, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Returns statistics for the given index, including a document count and
            /// storage usage.
            /// <see href="https://msdn.microsoft.com/library/azure/dn798942.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='indexName'>
            /// The name of the index for which to retrieve statistics.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<IndexGetStatisticsResult> GetStatisticsAsync(this IIndexes operations, string indexName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetStatisticsWithHttpMessagesAsync(indexName, searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
