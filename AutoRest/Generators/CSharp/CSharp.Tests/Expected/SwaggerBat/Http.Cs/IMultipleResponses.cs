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
    public partial interface IMultipleResponses
    {
        /// <summary>
        /// Send a 200 response with valid payload: {&apos;statusCode&apos;:
        /// &apos;200&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200Model204NoModelDefaultError200ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 204 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200Model204NoModelDefaultError204ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 201 response with valid payload: {&apos;statusCode&apos;:
        /// &apos;201&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200Model204NoModelDefaultError201InvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 202 response with no payload:
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200Model204NoModelDefaultError202NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with valid error payload: {&apos;status&apos;:
        /// 400, &apos;message&apos;: &apos;client error&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200Model204NoModelDefaultError400ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with valid payload: {&apos;statusCode&apos;:
        /// &apos;200&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200Model201ModelDefaultError200ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 201 response with valid payload: {&apos;statusCode&apos;:
        /// &apos;201&apos;, &apos;textStatusCode&apos;: &apos;Created&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200Model201ModelDefaultError201ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with valid payload: {&apos;code&apos;:
        /// &apos;400&apos;, &apos;message&apos;: &apos;client error&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200Model201ModelDefaultError400ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with valid payload: {&apos;statusCode&apos;:
        /// &apos;200&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<object>> Get200ModelA201ModelC404ModelDDefaultError200ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with valid payload: {&apos;httpCode&apos;:
        /// &apos;201&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<object>> Get200ModelA201ModelC404ModelDDefaultError201ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with valid payload:
        /// {&apos;httpStatusCode&apos;: &apos;404&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<object>> Get200ModelA201ModelC404ModelDDefaultError404ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with valid payload: {&apos;code&apos;:
        /// &apos;400&apos;, &apos;message&apos;: &apos;client error&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<object>> Get200ModelA201ModelC404ModelDDefaultError400ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 202 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Get202None204NoneDefaultError202NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 204 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Get202None204NoneDefaultError204NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with valid payload: {&apos;code&apos;:
        /// &apos;400&apos;, &apos;message&apos;: &apos;client error&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Get202None204NoneDefaultError400ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 202 response with an unexpected payload
        /// {&apos;property&apos;: &apos;value&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Get202None204NoneDefaultNone202InvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 204 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Get202None204NoneDefaultNone204NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Get202None204NoneDefaultNone400NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with an unexpected payload
        /// {&apos;property&apos;: &apos;value&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> Get202None204NoneDefaultNone400InvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with valid payload: {&apos;statusCode&apos;:
        /// &apos;200&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> GetDefaultModelA200ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> GetDefaultModelA200NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with valid payload: {&apos;statusCode&apos;:
        /// &apos;400&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> GetDefaultModelA400ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> GetDefaultModelA400NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with invalid payload: {&apos;statusCode&apos;:
        /// &apos;200&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetDefaultNone200InvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetDefaultNone200NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with valid payload: {&apos;statusCode&apos;:
        /// &apos;400&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetDefaultNone400InvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with no payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetDefaultNone400NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with no payload, when a payload is expected -
        /// client should return a null object of thde type for model A
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200ModelA200NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with payload {&apos;statusCode&apos;:
        /// &apos;200&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200ModelA200ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with invalid payload
        /// {&apos;statusCodeInvalid&apos;: &apos;200&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200ModelA200InvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 400 response with no payload client should treat as an http
        /// error with no error model
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200ModelA400NoneWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with payload {&apos;statusCode&apos;:
        /// &apos;400&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200ModelA400ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 200 response with invalid payload
        /// {&apos;statusCodeInvalid&apos;: &apos;400&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200ModelA400InvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a 202 response with payload {&apos;statusCode&apos;:
        /// &apos;202&apos;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<A>> Get200ModelA202ValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
