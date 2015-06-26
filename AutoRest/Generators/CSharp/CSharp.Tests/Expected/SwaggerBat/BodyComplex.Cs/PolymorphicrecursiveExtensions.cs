namespace Fixtures.SwaggerBatBodyComplex
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class PolymorphicrecursiveExtensions
    {
            /// <summary>
            /// Get complex types that are polymorphic and have recursive references
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Fish GetValid(this IPolymorphicrecursive operations)
            {
                return Task.Factory.StartNew(s => ((IPolymorphicrecursive)s).GetValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types that are polymorphic and have recursive references
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Fish> GetValidAsync( this IPolymorphicrecursive operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Fish> result = await operations.GetValidWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put complex types that are polymorphic and have recursive references
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
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
            /// &quot;species&quot;: &quot;predator&quot;,
            /// &quot;length&quot;: 20,
            /// &quot;age&quot;: 6
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
            public static void PutValid(this IPolymorphicrecursive operations, Fish complexBody)
            {
                Task.Factory.StartNew(s => ((IPolymorphicrecursive)s).PutValidAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types that are polymorphic and have recursive references
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
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
            /// &quot;species&quot;: &quot;predator&quot;,
            /// &quot;length&quot;: 20,
            /// &quot;age&quot;: 6
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
            public static async Task PutValidAsync( this IPolymorphicrecursive operations, Fish complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutValidWithOperationResponseAsync(complexBody, cancellationToken).ConfigureAwait(false);
            }

    }
}
