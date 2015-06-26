namespace Fixtures.SwaggerBatUrl
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IPathItems
    {
        /// <summary>
        /// send globalStringPath=&apos;globalStringPath&apos;,
        /// pathItemStringPath=&apos;pathItemStringPath&apos;,
        /// localStringPath=&apos;localStringPath&apos;,
        /// globalStringQuery=&apos;globalStringQuery&apos;,
        /// pathItemStringQuery=&apos;pathItemStringQuery&apos;,
        /// localStringQuery=&apos;localStringQuery&apos;
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value &apos;localStringPath&apos;
        /// </param>
        /// <param name='localStringQuery'>
        /// should contain value &apos;localStringQuery&apos;
        /// </param>
        /// <param name='pathItemStringPath'>
        /// A string value &apos;pathItemStringPath&apos; that appears in the
        /// path
        /// </param>
        /// <param name='pathItemStringQuery'>
        /// A string value &apos;pathItemStringQuery&apos; that appears as a
        /// query parameter
        /// </param>
        /// <param name='globalStringPath'>
        /// A string value &apos;globalItemStringPath&apos; that appears in
        /// the path
        /// </param>
        /// <param name='globalStringQuery'>
        /// should contain value null
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetAllWithValuesWithOperationResponseAsync(string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// send globalStringPath=&apos;globalStringPath&apos;,
        /// pathItemStringPath=&apos;pathItemStringPath&apos;,
        /// localStringPath=&apos;localStringPath&apos;,
        /// globalStringQuery=null,
        /// pathItemStringQuery=&apos;pathItemStringQuery&apos;,
        /// localStringQuery=&apos;localStringQuery&apos;
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value &apos;localStringPath&apos;
        /// </param>
        /// <param name='localStringQuery'>
        /// should contain value &apos;localStringQuery&apos;
        /// </param>
        /// <param name='pathItemStringPath'>
        /// A string value &apos;pathItemStringPath&apos; that appears in the
        /// path
        /// </param>
        /// <param name='pathItemStringQuery'>
        /// A string value &apos;pathItemStringQuery&apos; that appears as a
        /// query parameter
        /// </param>
        /// <param name='globalStringPath'>
        /// A string value &apos;globalItemStringPath&apos; that appears in
        /// the path
        /// </param>
        /// <param name='globalStringQuery'>
        /// should contain value null
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetGlobalQueryNullWithOperationResponseAsync(string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// send globalStringPath=globalStringPath,
        /// pathItemStringPath=&apos;pathItemStringPath&apos;,
        /// localStringPath=&apos;localStringPath&apos;,
        /// globalStringQuery=null,
        /// pathItemStringQuery=&apos;pathItemStringQuery&apos;,
        /// localStringQuery=null
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value &apos;localStringPath&apos;
        /// </param>
        /// <param name='localStringQuery'>
        /// should contain null value
        /// </param>
        /// <param name='pathItemStringPath'>
        /// A string value &apos;pathItemStringPath&apos; that appears in the
        /// path
        /// </param>
        /// <param name='pathItemStringQuery'>
        /// A string value &apos;pathItemStringQuery&apos; that appears as a
        /// query parameter
        /// </param>
        /// <param name='globalStringPath'>
        /// A string value &apos;globalItemStringPath&apos; that appears in
        /// the path
        /// </param>
        /// <param name='globalStringQuery'>
        /// should contain value null
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetGlobalAndLocalQueryNullWithOperationResponseAsync(string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// send globalStringPath=&apos;globalStringPath&apos;,
        /// pathItemStringPath=&apos;pathItemStringPath&apos;,
        /// localStringPath=&apos;localStringPath&apos;,
        /// globalStringQuery=&apos;globalStringQuery&apos;,
        /// pathItemStringQuery=null, localStringQuery=null
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value &apos;localStringPath&apos;
        /// </param>
        /// <param name='localStringQuery'>
        /// should contain value null
        /// </param>
        /// <param name='pathItemStringPath'>
        /// A string value &apos;pathItemStringPath&apos; that appears in the
        /// path
        /// </param>
        /// <param name='pathItemStringQuery'>
        /// should contain value null
        /// </param>
        /// <param name='globalStringPath'>
        /// A string value &apos;globalItemStringPath&apos; that appears in
        /// the path
        /// </param>
        /// <param name='globalStringQuery'>
        /// should contain value null
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetLocalPathItemQueryNullWithOperationResponseAsync(string localStringPath, string pathItemStringPath, string globalStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), string globalStringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken));
    }
}
