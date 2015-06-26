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
    public partial interface IDictionary
    {
        /// <summary>
        /// Get complex types with dictionary property
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DictionaryWrapper>> GetValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with dictionary property
        /// </summary>
        /// <param name='complexBody'>
        /// Please put a dictionary with 5 key-value pairs:
        /// &quot;txt&quot;:&quot;notepad&quot;,
        /// &quot;bmp&quot;:&quot;mspaint&quot;,
        /// &quot;xls&quot;:&quot;excel&quot;, &quot;exe&quot;:&quot;&quot;,
        /// &quot;&quot;:null
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutValidWithOperationResponseAsync(DictionaryWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with dictionary property which is empty
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DictionaryWrapper>> GetEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put complex types with dictionary property which is empty
        /// </summary>
        /// <param name='complexBody'>
        /// Please put an empty dictionary
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutEmptyWithOperationResponseAsync(DictionaryWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with dictionary property which is null
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DictionaryWrapper>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get complex types with dictionary property while server
        /// doesn&apos;t provide a response payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<DictionaryWrapper>> GetNotProvidedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
