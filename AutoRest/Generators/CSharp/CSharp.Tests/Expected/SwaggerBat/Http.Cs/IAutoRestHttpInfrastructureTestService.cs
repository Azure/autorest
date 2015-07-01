namespace Fixtures.SwaggerBatHttp
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
    public partial interface IAutoRestHttpInfrastructureTestService
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        IHttpFailure HttpFailure { get; }

        IHttpSuccess HttpSuccess { get; }

        IHttpRedirects HttpRedirects { get; }

        IHttpClientFailure HttpClientFailure { get; }

        IHttpServerFailure HttpServerFailure { get; }

        IHttpRetry HttpRetry { get; }

        IMultipleResponses MultipleResponses { get; }

        }
}
