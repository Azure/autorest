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
        /// Send a post request with header value &quot;User-Agent&quot;:
        /// &quot;overwrite&quot;
        /// </summary>
        /// <param name='userAgent'>
        /// Send a post request with header value &quot;User-Agent&quot;:
        /// &quot;overwrite&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamExistingKeyWithOperationResponseAsync(string userAgent, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value &quot;User-Agent&quot;:
        /// &quot;overwrite&quot;
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseExistingKeyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header value &quot;Content-Type&quot;:
        /// &quot;text/html&quot;
        /// </summary>
        /// <param name='contentType'>
        /// Send a post request with header value &quot;Content-Type&quot;:
        /// &quot;text/html&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamProtectedKeyWithOperationResponseAsync(string contentType, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value &quot;Content-Type&quot;:
        /// &quot;text/html&quot;
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseProtectedKeyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot;, &quot;value&quot;: 1 or
        /// &quot;scenario&quot;: &quot;negative&quot;, &quot;value&quot;: -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot; or &quot;negative&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 1 or -2
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamIntegerWithOperationResponseAsync(string scenario, int? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value &quot;value&quot;: 1 or -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot; or &quot;negative&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseIntegerWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot;, &quot;value&quot;: 105 or
        /// &quot;scenario&quot;: &quot;negative&quot;, &quot;value&quot;: -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot; or &quot;negative&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 105 or -2
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamLongWithOperationResponseAsync(string scenario, long? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value &quot;value&quot;: 105 or -2
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot; or &quot;negative&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseLongWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot;, &quot;value&quot;: 0.07 or
        /// &quot;scenario&quot;: &quot;negative&quot;, &quot;value&quot;:
        /// -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot; or &quot;negative&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 0.07 or -3.0
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamFloatWithOperationResponseAsync(string scenario, double? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value &quot;value&quot;: 0.07 or -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot; or &quot;negative&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseFloatWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot;, &quot;value&quot;: 7e120 or
        /// &quot;scenario&quot;: &quot;negative&quot;, &quot;value&quot;:
        /// -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot; or &quot;negative&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values 7e120 or -3.0
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamDoubleWithOperationResponseAsync(string scenario, double? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value &quot;value&quot;: 7e120 or -3.0
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;positive&quot; or &quot;negative&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseDoubleWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;true&quot;, &quot;value&quot;: true or
        /// &quot;scenario&quot;: &quot;false&quot;, &quot;value&quot;: false
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;true&quot; or &quot;false&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values true or false
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamBoolWithOperationResponseAsync(string scenario, bool? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header value &quot;value&quot;: true or false
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;true&quot; or &quot;false&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseBoolWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot;, &quot;value&quot;: &quot;The quick brown fox
        /// jumps over the lazy dog&quot; or &quot;scenario&quot;:
        /// &quot;null&quot;, &quot;value&quot;: null or
        /// &quot;scenario&quot;: &quot;empty&quot;, &quot;value&quot;:
        /// &quot;&quot;
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values &quot;The quick brown fox
        /// jumps over the lazy dog&quot; or null or &quot;&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamStringWithOperationResponseAsync(string scenario, string value = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values &quot;The quick brown fox jumps
        /// over the lazy dog&quot; or null or &quot;&quot;
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseStringWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot;, &quot;value&quot;: &quot;2010-01-01&quot; or
        /// &quot;scenario&quot;: &quot;min&quot;, &quot;value&quot;:
        /// &quot;0001-01-01&quot;
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot; or &quot;min&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values &quot;2010-01-01&quot; or
        /// &quot;0001-01-01&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamDateWithOperationResponseAsync(string scenario, DateTime? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values &quot;2010-01-01&quot; or
        /// &quot;0001-01-01&quot;
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot; or &quot;min&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseDateWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot;, &quot;value&quot;:
        /// &quot;2010-01-01T12:34:56Z&quot; or &quot;scenario&quot;:
        /// &quot;min&quot;, &quot;value&quot;:
        /// &quot;0001-01-01T00:00:00Z&quot;
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot; or &quot;min&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values
        /// &quot;2010-01-01T12:34:56Z&quot; or
        /// &quot;0001-01-01T00:00:00Z&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamDatetimeWithOperationResponseAsync(string scenario, DateTime? value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values &quot;2010-01-01T12:34:56Z&quot;
        /// or &quot;0001-01-01T00:00:00Z&quot;
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot; or &quot;min&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseDatetimeWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot;, &quot;value&quot;: &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamByteWithOperationResponseAsync(string scenario, byte[] value, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseByteWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot;, &quot;value&quot;: &quot;GREY&quot; or
        /// &quot;scenario&quot;: &quot;null&quot;, &quot;value&quot;: null
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
        /// </param>
        /// <param name='value'>
        /// Send a post request with header values &apos;GREY&apos; . Possible
        /// values for this parameter include: &apos;White&apos;,
        /// &apos;black&apos;, &apos;GREY&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ParamEnumWithOperationResponseAsync(string scenario, GreyscaleColors? value = default(GreyscaleColors?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a response with header values &quot;GREY&quot; or null
        /// </summary>
        /// <param name='scenario'>
        /// Send a post request with header values &quot;scenario&quot;:
        /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ResponseEnumWithOperationResponseAsync(string scenario, CancellationToken cancellationToken = default(CancellationToken));
    }
}
