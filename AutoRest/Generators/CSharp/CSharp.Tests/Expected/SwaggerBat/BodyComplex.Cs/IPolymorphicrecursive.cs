namespace Fixtures.SwaggerBatBodyComplex
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
    public partial interface IPolymorphicrecursive
    {
        /// <summary>
        /// Get complex types that are polymorphic and have recursive
        /// references
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Fish>> GetValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types that are polymorphic and have recursive
        /// references
        /// </summary>
        /// <param name='complexBody'>
        /// Please put a salmon that looks like this:
        /// {
        /// &quot;dtype&quot;: &quot;salmon&quot;,
        /// &quot;species&quot;: &quot;king&quot;,
        /// &quot;length&quot;: 1,
        /// &quot;age&quot;: 1,
        /// &quot;location&quot;: &quot;alaska&quot;,
        /// &quot;iswild&quot;: true,
        /// &quot;siblings&quot;: [
        /// {
        /// &quot;dtype&quot;: &quot;shark&quot;,
        /// &quot;species&quot;: &quot;predator&quot;,
        /// &quot;length&quot;: 20,
        /// &quot;age&quot;: 6,
        /// &quot;siblings&quot;: [
        /// {
        /// &quot;dtype&quot;: &quot;salmon&quot;,
        /// &quot;species&quot;: &quot;coho&quot;,
        /// &quot;length&quot;: 2,
        /// &quot;age&quot;: 2,
        /// &quot;location&quot;: &quot;atlantic&quot;,
        /// &quot;iswild&quot;: true,
        /// &quot;siblings&quot;: [
        /// {
        /// &quot;dtype&quot;: &quot;shark&quot;,
        /// &quot;species&quot;:
        /// &quot;predator&quot;,
        /// &quot;length&quot;: 20,
        /// &quot;age&quot;: 6
        /// },
        /// {
        /// &quot;dtype&quot;:
        /// &quot;sawshark&quot;,
        /// &quot;species&quot;:
        /// &quot;dangerous&quot;,
        /// &quot;length&quot;: 10,
        /// &quot;age&quot;: 105
        /// }
        /// ]
        /// },
        /// {
        /// &quot;dtype&quot;: &quot;sawshark&quot;,
        /// &quot;species&quot;: &quot;dangerous&quot;,
        /// &quot;length&quot;: 10,
        /// &quot;age&quot;: 105
        /// }
        /// ]
        /// },
        /// {
        /// &quot;dtype&quot;: &quot;sawshark&quot;,
        /// &quot;species&quot;: &quot;dangerous&quot;,
        /// &quot;length&quot;: 10,
        /// &quot;age&quot;: 105
        /// }
        /// ]
        /// }
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutValidWithOperationResponseAsync(Fish complexBody, CancellationToken cancellationToken = default(CancellationToken));
    }
}
