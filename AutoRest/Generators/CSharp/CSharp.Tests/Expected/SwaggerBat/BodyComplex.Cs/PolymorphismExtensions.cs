namespace Fixtures.SwaggerBatBodyComplex
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class PolymorphismExtensions
    {
            /// <summary>
            /// Get complex types that are polymorphic
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Fish GetValid(this IPolymorphism operations)
            {
                return Task.Factory.StartNew(s => ((IPolymorphism)s).GetValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types that are polymorphic
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Fish> GetValidAsync( this IPolymorphism operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Fish> result = await operations.GetValidWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put complex types that are polymorphic
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='complexBody'>
            /// Please put a salmon that looks like this:
            /// {
            /// &apos;dtype&apos;:&apos;Salmon&apos;,
            /// &apos;location&apos;:&apos;alaska&apos;,
            /// &apos;iswild&apos;:true,
            /// &apos;species&apos;:&apos;king&apos;,
            /// &apos;length&apos;:1.0,
            /// &apos;siblings&apos;:[
            /// {
            /// &apos;dtype&apos;:&apos;Shark&apos;,
            /// &apos;age&apos;:6,
            /// &apos;birthday&apos;: &apos;2012-01-05T01:00:00Z&apos;,
            /// &apos;length&apos;:20.0,
            /// &apos;species&apos;:&apos;predator&apos;,
            /// },
            /// {
            /// &apos;dtype&apos;:&apos;Sawshark&apos;,
            /// &apos;age&apos;:105,
            /// &apos;birthday&apos;: &apos;1900-01-05T01:00:00Z&apos;,
            /// &apos;length&apos;:10.0,
            /// &apos;picture&apos;: new Buffer([255, 255, 255, 255,
            /// 254]).toString(&apos;base64&apos;),
            /// &apos;species&apos;:&apos;dangerous&apos;,
            /// }
            /// ]
            /// };
            /// </param>
            public static void PutValid(this IPolymorphism operations, Fish complexBody)
            {
                Task.Factory.StartNew(s => ((IPolymorphism)s).PutValidAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types that are polymorphic
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='complexBody'>
            /// Please put a salmon that looks like this:
            /// {
            /// &apos;dtype&apos;:&apos;Salmon&apos;,
            /// &apos;location&apos;:&apos;alaska&apos;,
            /// &apos;iswild&apos;:true,
            /// &apos;species&apos;:&apos;king&apos;,
            /// &apos;length&apos;:1.0,
            /// &apos;siblings&apos;:[
            /// {
            /// &apos;dtype&apos;:&apos;Shark&apos;,
            /// &apos;age&apos;:6,
            /// &apos;birthday&apos;: &apos;2012-01-05T01:00:00Z&apos;,
            /// &apos;length&apos;:20.0,
            /// &apos;species&apos;:&apos;predator&apos;,
            /// },
            /// {
            /// &apos;dtype&apos;:&apos;Sawshark&apos;,
            /// &apos;age&apos;:105,
            /// &apos;birthday&apos;: &apos;1900-01-05T01:00:00Z&apos;,
            /// &apos;length&apos;:10.0,
            /// &apos;picture&apos;: new Buffer([255, 255, 255, 255,
            /// 254]).toString(&apos;base64&apos;),
            /// &apos;species&apos;:&apos;dangerous&apos;,
            /// }
            /// ]
            /// };
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutValidAsync( this IPolymorphism operations, Fish complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutValidWithOperationResponseAsync(complexBody, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Put complex types that are polymorphic, attempting to omit required
            /// &apos;birthday&apos; field - the request should not be allowed from the
            /// client
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='complexBody'>
            /// Please attempt put a sawshark that looks like this, the client should not
            /// allow this data to be sent:
            /// {
            /// &quot;dtype&quot;: &quot;sawshark&quot;,
            /// &quot;species&quot;: &quot;snaggle toothed&quot;,
            /// &quot;length&quot;: 18.5,
            /// &quot;age&quot;: 2,
            /// &quot;birthday&quot;: &quot;2013-06-01T01:00:00Z&quot;,
            /// &quot;location&quot;: &quot;alaska&quot;,
            /// &quot;picture&quot;: base64(FF FF FF FF FE),
            /// &quot;siblings&quot;: [
            /// {
            /// &quot;dtype&quot;: &quot;shark&quot;,
            /// &quot;species&quot;: &quot;predator&quot;,
            /// &quot;birthday&quot;: &quot;2012-01-05T01:00:00Z&quot;,
            /// &quot;length&quot;: 20,
            /// &quot;age&quot;: 6
            /// },
            /// {
            /// &quot;dtype&quot;: &quot;sawshark&quot;,
            /// &quot;species&quot;: &quot;dangerous&quot;,
            /// &quot;picture&quot;: base64(FF FF FF FF FE),
            /// &quot;length&quot;: 10,
            /// &quot;age&quot;: 105
            /// }
            /// ]
            /// }
            /// </param>
            public static void PutValidMissingRequired(this IPolymorphism operations, Fish complexBody)
            {
                Task.Factory.StartNew(s => ((IPolymorphism)s).PutValidMissingRequiredAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types that are polymorphic, attempting to omit required
            /// &apos;birthday&apos; field - the request should not be allowed from the
            /// client
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='complexBody'>
            /// Please attempt put a sawshark that looks like this, the client should not
            /// allow this data to be sent:
            /// {
            /// &quot;dtype&quot;: &quot;sawshark&quot;,
            /// &quot;species&quot;: &quot;snaggle toothed&quot;,
            /// &quot;length&quot;: 18.5,
            /// &quot;age&quot;: 2,
            /// &quot;birthday&quot;: &quot;2013-06-01T01:00:00Z&quot;,
            /// &quot;location&quot;: &quot;alaska&quot;,
            /// &quot;picture&quot;: base64(FF FF FF FF FE),
            /// &quot;siblings&quot;: [
            /// {
            /// &quot;dtype&quot;: &quot;shark&quot;,
            /// &quot;species&quot;: &quot;predator&quot;,
            /// &quot;birthday&quot;: &quot;2012-01-05T01:00:00Z&quot;,
            /// &quot;length&quot;: 20,
            /// &quot;age&quot;: 6
            /// },
            /// {
            /// &quot;dtype&quot;: &quot;sawshark&quot;,
            /// &quot;species&quot;: &quot;dangerous&quot;,
            /// &quot;picture&quot;: base64(FF FF FF FF FE),
            /// &quot;length&quot;: 10,
            /// &quot;age&quot;: 105
            /// }
            /// ]
            /// }
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutValidMissingRequiredAsync( this IPolymorphism operations, Fish complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutValidMissingRequiredWithOperationResponseAsync(complexBody, cancellationToken).ConfigureAwait(false);
            }

    }
}
