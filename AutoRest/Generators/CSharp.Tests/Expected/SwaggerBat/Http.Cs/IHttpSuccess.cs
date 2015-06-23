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
    public partial interface IHttpSuccess
    {
        /// <summary>
        /// Return 200 status code if successful
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Head200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get 200 success
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<bool?>> Get200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put boolean value true returning 200 success
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Put200WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Patch true Boolean value in request returning 200
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Patch200WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Post bollean value true in request that returns a 200
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Post200WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Delete simple boolean value true returns 200
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Delete200WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put true Boolean value in request returns 201
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Put201WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Post true Boolean value in request returns 201 (Created)
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Post201WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put true Boolean value in request returns 202 (Accepted)
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Put202WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Patch true Boolean value in request returns 202
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Patch202WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Post true Boolean value in request returns 202 (Accepted)
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Post202WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Delete true Boolean value in request returns 202 (accepted)
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Delete202WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 204 status code if successful
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Head204WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put true Boolean value in request returns 204 (no content)
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Put204WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Patch true Boolean value in request returns 204 (no content)
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Patch204WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Post true Boolean value in request returns 204 (no content)
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Post204WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Delete true Boolean value in request returns 204 (no content)
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Delete204WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 404 status code
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Head404WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
