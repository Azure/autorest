// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Searchservice
{
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for DataSources.
    /// </summary>
    public static partial class DataSourcesExtensions
    {
            /// <summary>
            /// Creates a new Azure Search datasource or updates a datasource if it already
            /// exists.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946900.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='dataSourceName'>
            /// The name of the datasource to create or update.
            /// </param>
            /// <param name='dataSource'>
            /// The definition of the datasource to create or update.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static DataSource CreateOrUpdate(this IDataSources operations, string dataSourceName, DataSource dataSource, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.CreateOrUpdateAsync(dataSourceName, dataSource, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates a new Azure Search datasource or updates a datasource if it already
            /// exists.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946900.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='dataSourceName'>
            /// The name of the datasource to create or update.
            /// </param>
            /// <param name='dataSource'>
            /// The definition of the datasource to create or update.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<DataSource> CreateOrUpdateAsync(this IDataSources operations, string dataSourceName, DataSource dataSource, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.CreateOrUpdateWithHttpMessagesAsync(dataSourceName, dataSource, searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Deletes an Azure Search datasource.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946881.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='dataSourceName'>
            /// The name of the datasource to delete.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static void Delete(this IDataSources operations, string dataSourceName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                operations.DeleteAsync(dataSourceName, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Deletes an Azure Search datasource.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946881.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='dataSourceName'>
            /// The name of the datasource to delete.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task DeleteAsync(this IDataSources operations, string dataSourceName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.DeleteWithHttpMessagesAsync(dataSourceName, searchRequestOptions, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Retrieves a datasource definition from Azure Search.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946893.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='dataSourceName'>
            /// The name of the datasource to retrieve.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static DataSource Get(this IDataSources operations, string dataSourceName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.GetAsync(dataSourceName, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Retrieves a datasource definition from Azure Search.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946893.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='dataSourceName'>
            /// The name of the datasource to retrieve.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<DataSource> GetAsync(this IDataSources operations, string dataSourceName, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetWithHttpMessagesAsync(dataSourceName, searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Lists all datasources available for an Azure Search service.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946878.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static DataSourceListResult List(this IDataSources operations, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.ListAsync(searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Lists all datasources available for an Azure Search service.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946878.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<DataSourceListResult> ListAsync(this IDataSources operations, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.ListWithHttpMessagesAsync(searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Creates a new Azure Search datasource.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946876.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='dataSource'>
            /// The definition of the datasource to create.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            public static DataSource Create(this IDataSources operations, DataSource dataSource, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions))
            {
                return operations.CreateAsync(dataSource, searchRequestOptions).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates a new Azure Search datasource.
            /// <see href="https://msdn.microsoft.com/library/azure/dn946876.aspx" />
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='dataSource'>
            /// The definition of the datasource to create.
            /// </param>
            /// <param name='searchRequestOptions'>
            /// Additional parameters for the operation
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<DataSource> CreateAsync(this IDataSources operations, DataSource dataSource, SearchRequestOptions searchRequestOptions = default(SearchRequestOptions), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.CreateWithHttpMessagesAsync(dataSource, searchRequestOptions, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
