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
                HttpOperationResponse<Fish> result = await operations.GetValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
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
            /// "dtype": "salmon",
            /// "species": "king",
            /// "length": 1,
            /// "age": 1,
            /// "location": "alaska",
            /// "iswild": true,
            /// "siblings": [
            /// {
            /// "dtype": "shark",
            /// "species": "predator",
            /// "length": 20,
            /// "age": 6,
            /// "siblings": [
            /// {
            /// "dtype": "salmon",
            /// "species": "coho",
            /// "length": 2,
            /// "age": 2,
            /// "location": "atlantic",
            /// "iswild": true,
            /// "siblings": [
            /// {
            /// "dtype": "shark",
            /// "species": "predator",
            /// "length": 20,
            /// "age": 6
            /// },
            /// {
            /// "dtype": "sawshark",
            /// "species": "dangerous",
            /// "length": 10,
            /// "age": 105
            /// }
            /// ]
            /// },
            /// {
            /// "dtype": "sawshark",
            /// "species": "dangerous",
            /// "length": 10,
            /// "age": 105
            /// }
            /// ]
            /// },
            /// {
            /// "dtype": "sawshark",
            /// "species": "dangerous",
            /// "length": 10,
            /// "age": 105
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
            /// "dtype": "salmon",
            /// "species": "king",
            /// "length": 1,
            /// "age": 1,
            /// "location": "alaska",
            /// "iswild": true,
            /// "siblings": [
            /// {
            /// "dtype": "shark",
            /// "species": "predator",
            /// "length": 20,
            /// "age": 6,
            /// "siblings": [
            /// {
            /// "dtype": "salmon",
            /// "species": "coho",
            /// "length": 2,
            /// "age": 2,
            /// "location": "atlantic",
            /// "iswild": true,
            /// "siblings": [
            /// {
            /// "dtype": "shark",
            /// "species": "predator",
            /// "length": 20,
            /// "age": 6
            /// },
            /// {
            /// "dtype": "sawshark",
            /// "species": "dangerous",
            /// "length": 10,
            /// "age": 105
            /// }
            /// ]
            /// },
            /// {
            /// "dtype": "sawshark",
            /// "species": "dangerous",
            /// "length": 10,
            /// "age": 105
            /// }
            /// ]
            /// },
            /// {
            /// "dtype": "sawshark",
            /// "species": "dangerous",
            /// "length": 10,
            /// "age": 105
            /// }
            /// ]
            /// }
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutValidAsync( this IPolymorphicrecursive operations, Fish complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutValidWithOperationResponseAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

    }
}
