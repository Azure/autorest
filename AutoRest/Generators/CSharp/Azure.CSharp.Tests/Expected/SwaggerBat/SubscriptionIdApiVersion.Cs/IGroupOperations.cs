namespace Fixtures.Azure.SwaggerBatSubscriptionIdApiVersion
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using System.Linq;
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
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<SampleResourceGroup>> GetSampleResourceGroupWithHttpMessagesAsync(string resourceGroupName, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
