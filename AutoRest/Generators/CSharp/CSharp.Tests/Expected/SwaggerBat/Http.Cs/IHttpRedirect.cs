using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Rest;
using Fixtures.SwaggerBatHttp.Models;

namespace Fixtures.SwaggerBatHttp
{
    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IHttpRedirect
    {
        /// <summary>
        /// Redirect get with 307
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Get307WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
