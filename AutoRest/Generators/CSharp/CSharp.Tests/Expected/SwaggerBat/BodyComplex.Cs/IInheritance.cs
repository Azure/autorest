namespace Fixtures.SwaggerBatBodyComplex
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
    public partial interface IInheritance
    {
        /// <summary>
        /// Get complex types that extend others
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Siamese>> GetValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types that extend others
        /// </summary>
        /// <param name='complexBody'>
        /// Please put a siamese with id=2, name=&quot;Siameee&quot;,
        /// color=green, breed=persion, which hates 2 dogs, the 1st one named
        /// &quot;Potato&quot; with id=1 and food=&quot;tomato&quot;, and the
        /// 2nd one named &quot;Tomato&quot; with id=-1 and food=&quot;french
        /// fries&quot;.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutValidWithOperationResponseAsync(Siamese complexBody, CancellationToken cancellationToken = default(CancellationToken));
    }
}
