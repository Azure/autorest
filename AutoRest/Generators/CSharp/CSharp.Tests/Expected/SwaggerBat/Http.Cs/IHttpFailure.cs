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
    public partial interface IHttpFailure
    {
        /// <summary>
        /// Get empty error form server
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<bool?>> GetEmptyErrorWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
