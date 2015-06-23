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
    public partial interface IHttpClientFailure
    {
        /// <summary>
        /// Return 400 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Head400WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 400 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Get400WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 400 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Put400WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 400 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Patch400WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 400 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Post400WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 400 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Delete400WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 401 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Head401WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 402 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Get402WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 403 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Get403WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 404 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Put404WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 405 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Patch405WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 406 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Post406WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 407 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Delete407WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 409 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Put409WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 410 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Head410WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 411 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Get411WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 412 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Get412WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 413 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Put413WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 414 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Patch414WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 415 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Post415WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 416 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Get416WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 417 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='booleanValue'>
        /// Simple boolean value true
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Delete417WithOperationResponseAsync(bool? booleanValue = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Return 429 status code - should be represented in the client as an
        /// error
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> Head429WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
