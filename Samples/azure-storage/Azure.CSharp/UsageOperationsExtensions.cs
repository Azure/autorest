
namespace Petstore
{
    using Microsoft.Rest.Azure;
    using Models;

    /// <summary>
    /// Extension methods for UsageOperations.
    /// </summary>
    public static partial class UsageOperationsExtensions
    {
            /// <summary>
            /// Gets the current usage count and the limit for the resources under the
            /// subscription.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static System.Collections.Generic.IEnumerable<Usage> List(this IUsageOperations operations)
            {
                return ((IUsageOperations)operations).ListAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets the current usage count and the limit for the resources under the
            /// subscription.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Usage>> ListAsync(this IUsageOperations operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.ListWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
