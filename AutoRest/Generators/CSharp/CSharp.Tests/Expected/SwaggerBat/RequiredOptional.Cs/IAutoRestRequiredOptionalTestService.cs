namespace Fixtures.SwaggerBatRequiredOptional
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IAutoRestRequiredOptionalTestService : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        IImplicitModel ImplicitModel { get; }

        IExplicitModel ExplicitModel { get; }

        }
}
