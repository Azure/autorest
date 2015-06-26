namespace Fixtures.SwaggerBatHeader
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
    public partial interface IHeader
    {
        /// <summary>
        /// Send a post request with header value "User-Agent": "overwrite"
        /// </summary>
        /// <param name='userAgent'>
        /// Send a post request with header value "User-Agent": "overwrite"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamExistingKeyWithOperationResponseAsync(string userAgent, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value "User-Agent": "overwrite"
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseExistingKeyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header value "Content-Type": "text/html"
        /// </summary>
        /// <param name='contentType'>
        /// Send a post request with header value "Content-Type": "text/html"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamProtectedKeyWithOperationResponseAsync(string contentType, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value "Content-Type": "text/html"
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseProtectedKeyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "positive",
        /// "value": 1 or "scenario": "negative", "value": -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or
        /// "negative"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 1 or -2
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamIntegerWithOperationResponseAsync(string scenario, int? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value "value": 1 or -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or
        /// "negative"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseIntegerWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "positive",
        /// "value": 105 or "scenario": "negative", "value": -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or
        /// "negative"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 105 or -2
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamLongWithOperationResponseAsync(string scenario, long? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value "value": 105 or -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or
        /// "negative"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseLongWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "positive",
        /// "value": 0.07 or "scenario": "negative", "value": -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or
        /// "negative"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 0.07 or -3.0
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamFloatWithOperationResponseAsync(string scenario, double? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value "value": 0.07 or -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or
        /// "negative"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseFloatWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "positive",
        /// "value": 7e120 or "scenario": "negative", "value": -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or
        /// "negative"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 7e120 or -3.0
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamDoubleWithOperationResponseAsync(string scenario, double? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value "value": 7e120 or -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "positive" or
        /// "negative"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseDoubleWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "true",
        /// "value": true or "scenario": "false", "value": false
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "true" or
        /// "false"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values true or false
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamBoolWithOperationResponseAsync(string scenario, bool? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value "value": true or false
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "true" or
        /// "false"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseBoolWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "valid",
        /// "value": "The quick brown fox jumps over the lazy dog" or
        /// "scenario": "null", "value": null or "scenario": "empty",
        /// "value": ""
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or
        /// "null" or "empty"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values "The quick brown fox jumps
        /// over the lazy dog" or null or ""
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamStringWithOperationResponseAsync(string scenario, string value = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values "The quick brown fox jumps over
        /// the lazy dog" or null or ""
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or
        /// "null" or "empty"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseStringWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "valid",
        /// "value": "2010-01-01" or "scenario": "min", "value": "0001-01-01"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "min"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values "2010-01-01" or "0001-01-01"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamDateWithOperationResponseAsync(string scenario, DateTime? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values "2010-01-01" or "0001-01-01"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "min"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseDateWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "valid",
        /// "value": "2010-01-01T12:34:56Z" or "scenario": "min", "value":
        /// "0001-01-01T00:00:00Z"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "min"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values "2010-01-01T12:34:56Z" or
        /// "0001-01-01T00:00:00Z"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamDatetimeWithOperationResponseAsync(string scenario, DateTime? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values "2010-01-01T12:34:56Z" or
        /// "0001-01-01T00:00:00Z"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or "min"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseDatetimeWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "valid",
        /// "value": "啊齄丂狛狜隣郎隣兀﨩"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values "啊齄丂狛狜隣郎隣兀﨩"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamByteWithOperationResponseAsync(string scenario, byte[] value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values "啊齄丂狛狜隣郎隣兀﨩"
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseByteWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values "scenario": "valid",
        /// "value": "GREY" or "scenario": "null", "value": null
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or
        /// "null" or "empty"
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 'GREY' . Possible values
        /// for this parameter include: 'White', 'black', 'GREY'
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamEnumWithOperationResponseAsync(string scenario, GreyscaleColors? value = default(GreyscaleColors?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values "GREY" or null
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values "scenario": "valid" or
        /// "null" or "empty"
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseEnumWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
    }
}
