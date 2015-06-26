namespace Fixtures.SwaggerBatBodyString
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class EnumModelExtensions
    {
            /// <summary>
            /// Get enum value &apos;red color&apos; from enumeration of &apos;red
            /// color&apos;, &apos;green-color&apos;, &apos;blue_color&apos;.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Colors? GetNotExpandable(this IEnumModel operations)
            {
                return Task.Factory.StartNew(s => ((IEnumModel)s).GetNotExpandableAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get enum value &apos;red color&apos; from enumeration of &apos;red
            /// color&apos;, &apos;green-color&apos;, &apos;blue_color&apos;.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Colors?> GetNotExpandableAsync( this IEnumModel operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Colors?> result = await operations.GetNotExpandableWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Sends value &apos;red color&apos; from enumeration of &apos;red
            /// color&apos;, &apos;green-color&apos;, &apos;blue_color&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringBody'>
            /// Possible values for this parameter include: &apos;red color&apos;,
            /// &apos;green-color&apos;, &apos;blue_color&apos;
            /// </param>
            public static void PutNotExpandable(this IEnumModel operations, Colors? stringBody)
            {
                Task.Factory.StartNew(s => ((IEnumModel)s).PutNotExpandableAsync(stringBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Sends value &apos;red color&apos; from enumeration of &apos;red
            /// color&apos;, &apos;green-color&apos;, &apos;blue_color&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringBody'>
            /// Possible values for this parameter include: &apos;red color&apos;,
            /// &apos;green-color&apos;, &apos;blue_color&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutNotExpandableAsync( this IEnumModel operations, Colors? stringBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutNotExpandableWithOperationResponseAsync(stringBody, cancellationToken).ConfigureAwait(false);
            }

    }
}
