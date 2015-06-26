namespace Fixtures.Azure.SwaggerBatSubscriptionIdApiVersion
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    /// <summary>
    /// Some cool documentation.
    /// </summary>
    public partial interface IGroupOperations
    {
        /// <summary>
        /// Provides a resouce group with name 'testgroup101' and location
        /// 'West US'.
        /// </summary>
        /// <param name='resourceGroupName'>
        /// Resource Group name 'testgroup101'.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<SampleResourceGroup>> GetSampleResourceGroupWithOperationResponseAsync(string resourceGroupName, CancellationToken cancellationToken = default(CancellationToken));
    }
}
