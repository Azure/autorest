// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute
{
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for Snapshots.
    /// </summary>
    public static partial class SnapshotsExtensions
    {
            /// <summary>
            /// Creates or updates a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='snapshot'>
            /// Snapshot object supplied in the body of the Put disk operation.
            /// </param>
            public static Snapshot CreateOrUpdate(this ISnapshots operations, string resourceGroupName, string snapshotName, Snapshot snapshot)
            {
                return operations.CreateOrUpdateAsync(resourceGroupName, snapshotName, snapshot).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates or updates a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='snapshot'>
            /// Snapshot object supplied in the body of the Put disk operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Snapshot> CreateOrUpdateAsync(this ISnapshots operations, string resourceGroupName, string snapshotName, Snapshot snapshot, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.CreateOrUpdateWithHttpMessagesAsync(resourceGroupName, snapshotName, snapshot, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Updates (patches) a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='snapshot'>
            /// Snapshot object supplied in the body of the Patch snapshot operation.
            /// </param>
            public static Snapshot Update(this ISnapshots operations, string resourceGroupName, string snapshotName, SnapshotUpdate snapshot)
            {
                return operations.UpdateAsync(resourceGroupName, snapshotName, snapshot).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Updates (patches) a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='snapshot'>
            /// Snapshot object supplied in the body of the Patch snapshot operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Snapshot> UpdateAsync(this ISnapshots operations, string resourceGroupName, string snapshotName, SnapshotUpdate snapshot, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.UpdateWithHttpMessagesAsync(resourceGroupName, snapshotName, snapshot, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Gets information about a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            public static Snapshot Get(this ISnapshots operations, string resourceGroupName, string snapshotName)
            {
                return operations.GetAsync(resourceGroupName, snapshotName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets information about a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Snapshot> GetAsync(this ISnapshots operations, string resourceGroupName, string snapshotName, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetWithHttpMessagesAsync(resourceGroupName, snapshotName, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Deletes a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            public static OperationStatusResponse Delete(this ISnapshots operations, string resourceGroupName, string snapshotName)
            {
                return operations.DeleteAsync(resourceGroupName, snapshotName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Deletes a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<OperationStatusResponse> DeleteAsync(this ISnapshots operations, string resourceGroupName, string snapshotName, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.DeleteWithHttpMessagesAsync(resourceGroupName, snapshotName, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Lists snapshots under a resource group.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            public static SnapshotList ListByResourceGroup(this ISnapshots operations, string resourceGroupName)
            {
                return operations.ListByResourceGroupAsync(resourceGroupName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Lists snapshots under a resource group.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<SnapshotList> ListByResourceGroupAsync(this ISnapshots operations, string resourceGroupName, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.ListByResourceGroupWithHttpMessagesAsync(resourceGroupName, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Lists snapshots under a subscription.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static SnapshotList List(this ISnapshots operations)
            {
                return operations.ListAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Lists snapshots under a subscription.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<SnapshotList> ListAsync(this ISnapshots operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.ListWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Grants access to a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='grantAccessData'>
            /// Access data object supplied in the body of the get snapshot access
            /// operation.
            /// </param>
            public static AccessUri GrantAccess(this ISnapshots operations, string resourceGroupName, string snapshotName, GrantAccessData grantAccessData)
            {
                return operations.GrantAccessAsync(resourceGroupName, snapshotName, grantAccessData).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Grants access to a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='grantAccessData'>
            /// Access data object supplied in the body of the get snapshot access
            /// operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<AccessUri> GrantAccessAsync(this ISnapshots operations, string resourceGroupName, string snapshotName, GrantAccessData grantAccessData, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GrantAccessWithHttpMessagesAsync(resourceGroupName, snapshotName, grantAccessData, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Revokes access to a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            public static OperationStatusResponse RevokeAccess(this ISnapshots operations, string resourceGroupName, string snapshotName)
            {
                return operations.RevokeAccessAsync(resourceGroupName, snapshotName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Revokes access to a snapshot.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='snapshotName'>
            /// The name of the snapshot within the given subscription and resource group.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<OperationStatusResponse> RevokeAccessAsync(this ISnapshots operations, string resourceGroupName, string snapshotName, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.RevokeAccessWithHttpMessagesAsync(resourceGroupName, snapshotName, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
