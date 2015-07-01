namespace Fixtures.Azure.SwaggerBatLro
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
    /// Long-running Operation for AutoRest
    /// </summary>
    public partial interface IAutoRestLongRunningOperationTestService
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        ILROsOperations LROs { get; }

        IDONOTCALLsOperations DONOTCALLs { get; }

        ILRORetrysOperations LRORetrys { get; }

        ILROSADsOperations LROSADs { get; }

        }
}
