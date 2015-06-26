namespace Fixtures.SwaggerBatUrl
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class PathItemsExtensions
    {
            /// <summary>
            /// send globalStringPath=&apos;globalStringPath&apos;,
            /// pathItemStringPath=&apos;pathItemStringPath&apos;,
            /// localStringPath=&apos;localStringPath&apos;,
            /// globalStringQuery=&apos;globalStringQuery&apos;,
            /// pathItemStringQuery=&apos;pathItemStringQuery&apos;,
            /// localStringQuery=&apos;localStringQuery&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='localStringPath'>
            /// should contain value &apos;localStringPath&apos;
            /// </param>
            /// <param name='localStringQuery'>
            /// should contain value &apos;localStringQuery&apos;
            /// </param>
            /// <param name='pathItemStringPath'>
            /// A string value &apos;pathItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='pathItemStringQuery'>
            /// A string value &apos;pathItemStringQuery&apos; that appears as a query
            /// parameter
            /// </param>
            /// <param name='globalStringPath'>
            /// A string value &apos;globalItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='globalStringQuery'>
            /// should contain value null
            /// </param>
            public static void GetAllWithValues(this IPathItems operations, string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string))
            {
                Task.Factory.StartNew(s => ((IPathItems)s).GetAllWithValuesAsync(localStringPath, pathItemStringPath, globalStringPath, localStringQuery, pathItemStringQuery, globalStringQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// send globalStringPath=&apos;globalStringPath&apos;,
            /// pathItemStringPath=&apos;pathItemStringPath&apos;,
            /// localStringPath=&apos;localStringPath&apos;,
            /// globalStringQuery=&apos;globalStringQuery&apos;,
            /// pathItemStringQuery=&apos;pathItemStringQuery&apos;,
            /// localStringQuery=&apos;localStringQuery&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='localStringPath'>
            /// should contain value &apos;localStringPath&apos;
            /// </param>
            /// <param name='localStringQuery'>
            /// should contain value &apos;localStringQuery&apos;
            /// </param>
            /// <param name='pathItemStringPath'>
            /// A string value &apos;pathItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='pathItemStringQuery'>
            /// A string value &apos;pathItemStringQuery&apos; that appears as a query
            /// parameter
            /// </param>
            /// <param name='globalStringPath'>
            /// A string value &apos;globalItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='globalStringQuery'>
            /// should contain value null
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetAllWithValuesAsync( this IPathItems operations, string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetAllWithValuesWithOperationResponseAsync(localStringPath, pathItemStringPath, globalStringPath, localStringQuery, pathItemStringQuery, globalStringQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// send globalStringPath=&apos;globalStringPath&apos;,
            /// pathItemStringPath=&apos;pathItemStringPath&apos;,
            /// localStringPath=&apos;localStringPath&apos;, globalStringQuery=null,
            /// pathItemStringQuery=&apos;pathItemStringQuery&apos;,
            /// localStringQuery=&apos;localStringQuery&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='localStringPath'>
            /// should contain value &apos;localStringPath&apos;
            /// </param>
            /// <param name='localStringQuery'>
            /// should contain value &apos;localStringQuery&apos;
            /// </param>
            /// <param name='pathItemStringPath'>
            /// A string value &apos;pathItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='pathItemStringQuery'>
            /// A string value &apos;pathItemStringQuery&apos; that appears as a query
            /// parameter
            /// </param>
            /// <param name='globalStringPath'>
            /// A string value &apos;globalItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='globalStringQuery'>
            /// should contain value null
            /// </param>
            public static void GetGlobalQueryNull(this IPathItems operations, string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string))
            {
                Task.Factory.StartNew(s => ((IPathItems)s).GetGlobalQueryNullAsync(localStringPath, pathItemStringPath, globalStringPath, localStringQuery, pathItemStringQuery, globalStringQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// send globalStringPath=&apos;globalStringPath&apos;,
            /// pathItemStringPath=&apos;pathItemStringPath&apos;,
            /// localStringPath=&apos;localStringPath&apos;, globalStringQuery=null,
            /// pathItemStringQuery=&apos;pathItemStringQuery&apos;,
            /// localStringQuery=&apos;localStringQuery&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='localStringPath'>
            /// should contain value &apos;localStringPath&apos;
            /// </param>
            /// <param name='localStringQuery'>
            /// should contain value &apos;localStringQuery&apos;
            /// </param>
            /// <param name='pathItemStringPath'>
            /// A string value &apos;pathItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='pathItemStringQuery'>
            /// A string value &apos;pathItemStringQuery&apos; that appears as a query
            /// parameter
            /// </param>
            /// <param name='globalStringPath'>
            /// A string value &apos;globalItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='globalStringQuery'>
            /// should contain value null
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetGlobalQueryNullAsync( this IPathItems operations, string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetGlobalQueryNullWithOperationResponseAsync(localStringPath, pathItemStringPath, globalStringPath, localStringQuery, pathItemStringQuery, globalStringQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// send globalStringPath=globalStringPath,
            /// pathItemStringPath=&apos;pathItemStringPath&apos;,
            /// localStringPath=&apos;localStringPath&apos;, globalStringQuery=null,
            /// pathItemStringQuery=&apos;pathItemStringQuery&apos;, localStringQuery=null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='localStringPath'>
            /// should contain value &apos;localStringPath&apos;
            /// </param>
            /// <param name='localStringQuery'>
            /// should contain null value
            /// </param>
            /// <param name='pathItemStringPath'>
            /// A string value &apos;pathItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='pathItemStringQuery'>
            /// A string value &apos;pathItemStringQuery&apos; that appears as a query
            /// parameter
            /// </param>
            /// <param name='globalStringPath'>
            /// A string value &apos;globalItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='globalStringQuery'>
            /// should contain value null
            /// </param>
            public static void GetGlobalAndLocalQueryNull(this IPathItems operations, string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string))
            {
                Task.Factory.StartNew(s => ((IPathItems)s).GetGlobalAndLocalQueryNullAsync(localStringPath, pathItemStringPath, globalStringPath, localStringQuery, pathItemStringQuery, globalStringQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// send globalStringPath=globalStringPath,
            /// pathItemStringPath=&apos;pathItemStringPath&apos;,
            /// localStringPath=&apos;localStringPath&apos;, globalStringQuery=null,
            /// pathItemStringQuery=&apos;pathItemStringQuery&apos;, localStringQuery=null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='localStringPath'>
            /// should contain value &apos;localStringPath&apos;
            /// </param>
            /// <param name='localStringQuery'>
            /// should contain null value
            /// </param>
            /// <param name='pathItemStringPath'>
            /// A string value &apos;pathItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='pathItemStringQuery'>
            /// A string value &apos;pathItemStringQuery&apos; that appears as a query
            /// parameter
            /// </param>
            /// <param name='globalStringPath'>
            /// A string value &apos;globalItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='globalStringQuery'>
            /// should contain value null
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetGlobalAndLocalQueryNullAsync( this IPathItems operations, string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetGlobalAndLocalQueryNullWithOperationResponseAsync(localStringPath, pathItemStringPath, globalStringPath, localStringQuery, pathItemStringQuery, globalStringQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// send globalStringPath=&apos;globalStringPath&apos;,
            /// pathItemStringPath=&apos;pathItemStringPath&apos;,
            /// localStringPath=&apos;localStringPath&apos;,
            /// globalStringQuery=&apos;globalStringQuery&apos;,
            /// pathItemStringQuery=null, localStringQuery=null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='localStringPath'>
            /// should contain value &apos;localStringPath&apos;
            /// </param>
            /// <param name='localStringQuery'>
            /// should contain value null
            /// </param>
            /// <param name='pathItemStringPath'>
            /// A string value &apos;pathItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='pathItemStringQuery'>
            /// should contain value null
            /// </param>
            /// <param name='globalStringPath'>
            /// A string value &apos;globalItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='globalStringQuery'>
            /// should contain value null
            /// </param>
            public static void GetLocalPathItemQueryNull(this IPathItems operations, string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string))
            {
                Task.Factory.StartNew(s => ((IPathItems)s).GetLocalPathItemQueryNullAsync(localStringPath, pathItemStringPath, globalStringPath, localStringQuery, pathItemStringQuery, globalStringQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// send globalStringPath=&apos;globalStringPath&apos;,
            /// pathItemStringPath=&apos;pathItemStringPath&apos;,
            /// localStringPath=&apos;localStringPath&apos;,
            /// globalStringQuery=&apos;globalStringQuery&apos;,
            /// pathItemStringQuery=null, localStringQuery=null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='localStringPath'>
            /// should contain value &apos;localStringPath&apos;
            /// </param>
            /// <param name='localStringQuery'>
            /// should contain value null
            /// </param>
            /// <param name='pathItemStringPath'>
            /// A string value &apos;pathItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='pathItemStringQuery'>
            /// should contain value null
            /// </param>
            /// <param name='globalStringPath'>
            /// A string value &apos;globalItemStringPath&apos; that appears in the path
            /// </param>
            /// <param name='globalStringQuery'>
            /// should contain value null
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetLocalPathItemQueryNullAsync( this IPathItems operations, string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetLocalPathItemQueryNullWithOperationResponseAsync(localStringPath, pathItemStringPath, globalStringPath, localStringQuery, pathItemStringQuery, globalStringQuery, cancellationToken).ConfigureAwait(false);
            }

    }
}
