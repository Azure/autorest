namespace Fixtures.Azure.SwaggerBatSubscriptionIdApiVersion
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    public static partial class GroupOperationsExtensions
    {
            /// <summary>
            /// Provides a resouce group with name 'testgroup101' and location 'West US'.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='resourceGroupName'>
            /// Resource Group name 'testgroup101'.
            /// </param>
            public static SampleResourceGroup GetSampleResourceGroup(this IGroupOperations operations, string resourceGroupName)
            {
                return Task.Factory.StartNew(s => ((IGroupOperations)s).GetSampleResourceGroupAsync(resourceGroupName), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Provides a resouce group with name 'testgroup101' and location 'West US'.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='resourceGroupName'>
            /// Resource Group name 'testgroup101'.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<SampleResourceGroup> GetSampleResourceGroupAsync( this IGroupOperations operations, string resourceGroupName, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<SampleResourceGroup> result = await operations.GetSampleResourceGroupWithHttpMessagesAsync(resourceGroupName, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
