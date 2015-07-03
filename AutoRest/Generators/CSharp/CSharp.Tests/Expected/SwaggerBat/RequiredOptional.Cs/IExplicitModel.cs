namespace Fixtures.SwaggerBatRequiredOptional
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
    public partial interface IExplicitModel
    {
        /// <summary>
        /// Test explicitly required integer. Please put null and the client
        /// library should throw before the request is sent.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredIntegerParameterWithOperationResponseAsync(int? bodyParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional integer. Please put null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalIntegerParameterWithOperationResponseAsync(int? bodyParameter = default(int?), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required integer. Please put a valid int-wrapper
        /// with 'value' = null and the client library should throw before
        /// the request is sent.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredIntegerPropertyWithOperationResponseAsync(IntWrapper bodyParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional integer. Please put a valid int-wrapper
        /// with 'value' = null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalIntegerPropertyWithOperationResponseAsync(IntOptionalWrapper bodyParameter = default(IntOptionalWrapper), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required integer. Please put a header
        /// 'headerParameter' =&gt; null and the client library should throw
        /// before the request is sent.
        /// </summary>
        /// <param name='headerParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredIntegerHeaderWithOperationResponseAsync(int? headerParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional integer. Please put a header
        /// 'headerParameter' =&gt; null.
        /// </summary>
        /// <param name='headerParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalIntegerHeaderWithOperationResponseAsync(int? headerParameter = default(int?), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required string. Please put null and the client
        /// library should throw before the request is sent.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredStringParameterWithOperationResponseAsync(string bodyParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional string. Please put null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalStringParameterWithOperationResponseAsync(string bodyParameter = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required string. Please put a valid string-wrapper
        /// with 'value' = null and the client library should throw before
        /// the request is sent.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredStringPropertyWithOperationResponseAsync(StringWrapper bodyParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional integer. Please put a valid
        /// string-wrapper with 'value' = null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalStringPropertyWithOperationResponseAsync(StringOptionalWrapper bodyParameter = default(StringOptionalWrapper), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required string. Please put a header
        /// 'headerParameter' =&gt; null and the client library should throw
        /// before the request is sent.
        /// </summary>
        /// <param name='headerParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredStringHeaderWithOperationResponseAsync(string headerParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional string. Please put a header
        /// 'headerParameter' =&gt; null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalStringHeaderWithOperationResponseAsync(string bodyParameter = default(string), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required complex object. Please put null and the
        /// client library should throw before the request is sent.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredClassParameterWithOperationResponseAsync(Product bodyParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional complex object. Please put null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalClassParameterWithOperationResponseAsync(Product bodyParameter = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required complex object. Please put a valid
        /// class-wrapper with 'value' = null and the client library should
        /// throw before the request is sent.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredClassPropertyWithOperationResponseAsync(ClassWrapper bodyParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional complex object. Please put a valid
        /// class-wrapper with 'value' = null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalClassPropertyWithOperationResponseAsync(ClassOptionalWrapper bodyParameter = default(ClassOptionalWrapper), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required array. Please put null and the client
        /// library should throw before the request is sent.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredArrayParameterWithOperationResponseAsync(IList<string> bodyParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional array. Please put null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalArrayParameterWithOperationResponseAsync(IList<string> bodyParameter = default(IList<string>), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required array. Please put a valid array-wrapper
        /// with 'value' = null and the client library should throw before
        /// the request is sent.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredArrayPropertyWithOperationResponseAsync(ArrayWrapper bodyParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional array. Please put a valid array-wrapper
        /// with 'value' = null.
        /// </summary>
        /// <param name='bodyParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalArrayPropertyWithOperationResponseAsync(ArrayOptionalWrapper bodyParameter = default(ArrayOptionalWrapper), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly required array. Please put a header
        /// 'headerParameter' =&gt; null and the client library should throw
        /// before the request is sent.
        /// </summary>
        /// <param name='headerParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Error>> PostRequiredArrayHeaderWithOperationResponseAsync(IList<string> headerParameter, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Test explicitly optional integer. Please put a header
        /// 'headerParameter' =&gt; null.
        /// </summary>
        /// <param name='headerParameter'>
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PostOptionalArrayHeaderWithOperationResponseAsync(IList<string> headerParameter = default(IList<string>), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
