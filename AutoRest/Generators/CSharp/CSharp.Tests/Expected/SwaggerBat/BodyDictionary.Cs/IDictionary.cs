namespace Fixtures.SwaggerBatBodyDictionary
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest Swagger BAT
    /// </summary>
    public partial interface IDictionary
    {
        /// <summary>
        /// Get null dictionary value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get empty dictionary value {}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value empty {}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutEmptyWithOperationResponseAsync(IDictionary<string, string> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get Dictionary with null value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetNullValueWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get Dictionary with null key
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetNullKeyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get Dictionary with key as empty string
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetEmptyStringKeyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid Dictionary value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value {&quot;0&quot;: true, &quot;1&quot;:
        /// false, &quot;2&quot;: false, &quot;3&quot;: true }
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, bool?>>> GetBooleanTfftWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value empty {&quot;0&quot;: true, &quot;1&quot;:
        /// false, &quot;2&quot;: false, &quot;3&quot;: true }
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutBooleanTfftWithOperationResponseAsync(IDictionary<string, bool?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value {&quot;0&quot;: true, &quot;1&quot;:
        /// null, &quot;2&quot;: false }
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, bool?>>> GetBooleanInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value &apos;{&quot;0&quot;: true,
        /// &quot;1&quot;: &quot;boolean&quot;, &quot;2&quot;: false}&apos;
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, bool?>>> GetBooleanInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {&quot;0&quot;: 1, &quot;1&quot;: -1,
        /// &quot;2&quot;: 3, &quot;3&quot;: 300}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetIntegerValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value empty {&quot;0&quot;: 1, &quot;1&quot;: -1,
        /// &quot;2&quot;: 3, &quot;3&quot;: 300}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutIntegerValidWithOperationResponseAsync(IDictionary<string, int?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {&quot;0&quot;: 1, &quot;1&quot;:
        /// null, &quot;2&quot;: 0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetIntInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {&quot;0&quot;: 1, &quot;1&quot;:
        /// &quot;integer&quot;, &quot;2&quot;: 0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetIntInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {&quot;0&quot;: 1, &quot;1&quot;: -1,
        /// &quot;2&quot;: 3, &quot;3&quot;: 300}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, long?>>> GetLongValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value empty {&quot;0&quot;: 1, &quot;1&quot;: -1,
        /// &quot;2&quot;: 3, &quot;3&quot;: 300}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutLongValidWithOperationResponseAsync(IDictionary<string, long?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get long dictionary value {&quot;0&quot;: 1, &quot;1&quot;: null,
        /// &quot;2&quot;: 0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, long?>>> GetLongInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get long dictionary value {&quot;0&quot;: 1, &quot;1&quot;:
        /// &quot;integer&quot;, &quot;2&quot;: 0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, long?>>> GetLongInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float dictionary value {&quot;0&quot;: 0, &quot;1&quot;:
        /// -0.01, &quot;2&quot;: 1.2e20}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetFloatValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value {&quot;0&quot;: 0, &quot;1&quot;: -0.01,
        /// &quot;2&quot;: 1.2e20}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutFloatValidWithOperationResponseAsync(IDictionary<string, double?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float dictionary value {&quot;0&quot;: 0.0, &quot;1&quot;:
        /// null, &quot;2&quot;: 1.2e20}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetFloatInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value {&quot;0&quot;: 1.0, &quot;1&quot;:
        /// &quot;number&quot;, &quot;2&quot;: 0.0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetFloatInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float dictionary value {&quot;0&quot;: 0, &quot;1&quot;:
        /// -0.01, &quot;2&quot;: 1.2e20}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetDoubleValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value {&quot;0&quot;: 0, &quot;1&quot;: -0.01,
        /// &quot;2&quot;: 1.2e20}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDoubleValidWithOperationResponseAsync(IDictionary<string, double?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float dictionary value {&quot;0&quot;: 0.0, &quot;1&quot;:
        /// null, &quot;2&quot;: 1.2e20}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetDoubleInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value {&quot;0&quot;: 1.0, &quot;1&quot;:
        /// &quot;number&quot;, &quot;2&quot;: 0.0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetDoubleInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string dictionary value {&quot;0&quot;: &quot;foo1&quot;,
        /// &quot;1&quot;: &quot;foo2&quot;, &quot;2&quot;: &quot;foo3&quot;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetStringValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value {&quot;0&quot;: &quot;foo1&quot;,
        /// &quot;1&quot;: &quot;foo2&quot;, &quot;2&quot;: &quot;foo3&quot;}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutStringValidWithOperationResponseAsync(IDictionary<string, string> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string dictionary value {&quot;0&quot;: &quot;foo&quot;,
        /// &quot;1&quot;: null, &quot;2&quot;: &quot;foo2&quot;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetStringWithNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string dictionary value {&quot;0&quot;: &quot;foo&quot;,
        /// &quot;1&quot;: 123, &quot;2&quot;: &quot;foo2&quot;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetStringWithInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {&quot;0&quot;:
        /// &quot;2000-12-01&quot;, &quot;1&quot;: &quot;1980-01-02&quot;,
        /// &quot;2&quot;: &quot;1492-10-12&quot;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value  {&quot;0&quot;: &quot;2000-12-01&quot;,
        /// &quot;1&quot;: &quot;1980-01-02&quot;, &quot;2&quot;:
        /// &quot;1492-10-12&quot;}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDateValidWithOperationResponseAsync(IDictionary<string, DateTime?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date dictionary value {&quot;0&quot;: &quot;2012-01-01&quot;,
        /// &quot;1&quot;: null, &quot;2&quot;: &quot;1776-07-04&quot;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date dictionary value {&quot;0&quot;: &quot;2011-03-22&quot;,
        /// &quot;1&quot;: &quot;date&quot;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateInvalidCharsWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date-time dictionary value {&quot;0&quot;:
        /// &quot;2000-12-01t00:00:01z&quot;, &quot;1&quot;:
        /// &quot;1980-01-02T00:11:35+01:00&quot;, &quot;2&quot;:
        /// &quot;1492-10-12T10:15:01-08:00&quot;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateTimeValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value  {&quot;0&quot;:
        /// &quot;2000-12-01t00:00:01z&quot;, &quot;1&quot;:
        /// &quot;1980-01-02T00:11:35+01:00&quot;, &quot;2&quot;:
        /// &quot;1492-10-12T10:15:01-08:00&quot;}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDateTimeValidWithOperationResponseAsync(IDictionary<string, DateTime?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date dictionary value {&quot;0&quot;:
        /// &quot;2000-12-01t00:00:01z&quot;, &quot;1&quot;: null}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateTimeInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date dictionary value {&quot;0&quot;:
        /// &quot;2000-12-01t00:00:01z&quot;, &quot;1&quot;:
        /// &quot;date-time&quot;}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateTimeInvalidCharsWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get byte dictionary value {&quot;0&quot;: hex(FF FF FF FA),
        /// &quot;1&quot;: hex(01 02 03), &quot;2&quot;: hex (25, 29, 43)}
        /// with each item encoded in base64
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, byte[]>>> GetByteValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put the dictionary value {&quot;0&quot;: hex(FF FF FF FA),
        /// &quot;1&quot;: hex(01 02 03), &quot;2&quot;: hex (25, 29, 43)}
        /// with each elementencoded in base 64
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutByteValidWithOperationResponseAsync(IDictionary<string, byte[]> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get byte dictionary value {&quot;0&quot;: hex(FF FF FF FA),
        /// &quot;1&quot;: null} with the first item base64 encoded
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, byte[]>>> GetByteInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get dictionary of complex type null value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, Widget>>> GetComplexNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get empty dictionary of complex type {}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, Widget>>> GetComplexEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get dictionary of complex type with null item {&quot;0&quot;:
        /// {&quot;integer&quot;: 1, &quot;string&quot;: &quot;2&quot;},
        /// &quot;1&quot;: null, &quot;2&quot;: {&quot;integer&quot;: 5,
        /// &quot;string&quot;: &quot;6&quot;}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, Widget>>> GetComplexItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get dictionary of complex type with empty item {&quot;0&quot;:
        /// {&quot;integer&quot;: 1, &quot;string&quot;: &quot;2&quot;},
        /// &quot;1:&quot; {}, &quot;2&quot;: {&quot;integer&quot;: 5,
        /// &quot;string&quot;: &quot;6&quot;}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, Widget>>> GetComplexItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get dictionary of complex type with {&quot;0&quot;:
        /// {&quot;integer&quot;: 1, &quot;string&quot;: &quot;2&quot;},
        /// &quot;1&quot;: {&quot;integer&quot;: 3, &quot;string&quot;:
        /// &quot;4&quot;}, &quot;2&quot;: {&quot;integer&quot;: 5,
        /// &quot;string&quot;: &quot;6&quot;}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, Widget>>> GetComplexValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put an dictionary of complex type with values {&quot;0&quot;:
        /// {&quot;integer&quot;: 1, &quot;string&quot;: &quot;2&quot;},
        /// &quot;1&quot;: {&quot;integer&quot;: 3, &quot;string&quot;:
        /// &quot;4&quot;}, &quot;2&quot;: {&quot;integer&quot;: 5,
        /// &quot;string&quot;: &quot;6&quot;}}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutComplexValidWithOperationResponseAsync(IDictionary<string, Widget> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a null array
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IList<string>>>> GetArrayNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an empty dictionary {}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IList<string>>>> GetArrayEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionary of array of strings {&quot;0&quot;:
        /// [&quot;1&quot;, &quot;2&quot;, &quot;3&quot;], &quot;1&quot;:
        /// null, &quot;2&quot;: [&quot;7&quot;, &quot;8&quot;,
        /// &quot;9&quot;]}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IList<string>>>> GetArrayItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of array of strings [{&quot;0&quot;: [&quot;1&quot;,
        /// &quot;2&quot;, &quot;3&quot;], &quot;1&quot;: [], &quot;2&quot;:
        /// [&quot;7&quot;, &quot;8&quot;, &quot;9&quot;]}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IList<string>>>> GetArrayItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of array of strings {&quot;0&quot;: [&quot;1&quot;,
        /// &quot;2&quot;, &quot;3&quot;], &quot;1&quot;: [&quot;4&quot;,
        /// &quot;5&quot;, &quot;6&quot;], &quot;2&quot;: [&quot;7&quot;,
        /// &quot;8&quot;, &quot;9&quot;]}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IList<string>>>> GetArrayValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put An array of array of strings {&quot;0&quot;: [&quot;1&quot;,
        /// &quot;2&quot;, &quot;3&quot;], &quot;1&quot;: [&quot;4&quot;,
        /// &quot;5&quot;, &quot;6&quot;], &quot;2&quot;: [&quot;7&quot;,
        /// &quot;8&quot;, &quot;9&quot;]}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutArrayValidWithOperationResponseAsync(IDictionary<string, IList<string>> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries with value null
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IDictionary<string, string>>>> GetDictionaryNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries of type &lt;string, string&gt;
        /// with value {}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IDictionary<string, string>>>> GetDictionaryEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries of type &lt;string, string&gt;
        /// with value {&quot;0&quot;: {&quot;1&quot;: &quot;one&quot;,
        /// &quot;2&quot;: &quot;two&quot;, &quot;3&quot;:
        /// &quot;three&quot;}, &quot;1&quot;: null, &quot;2&quot;:
        /// {&quot;7&quot;: &quot;seven&quot;, &quot;8&quot;:
        /// &quot;eight&quot;, &quot;9&quot;: &quot;nine&quot;}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IDictionary<string, string>>>> GetDictionaryItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries of type &lt;string, string&gt;
        /// with value {&quot;0&quot;: {&quot;1&quot;: &quot;one&quot;,
        /// &quot;2&quot;: &quot;two&quot;, &quot;3&quot;:
        /// &quot;three&quot;}, &quot;1&quot;: {}, &quot;2&quot;:
        /// {&quot;7&quot;: &quot;seven&quot;, &quot;8&quot;:
        /// &quot;eight&quot;, &quot;9&quot;: &quot;nine&quot;}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IDictionary<string, string>>>> GetDictionaryItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries of type &lt;string, string&gt;
        /// with value {&quot;0&quot;: {&quot;1&quot;: &quot;one&quot;,
        /// &quot;2&quot;: &quot;two&quot;, &quot;3&quot;:
        /// &quot;three&quot;}, &quot;1&quot;: {&quot;4&quot;:
        /// &quot;four&quot;, &quot;5&quot;: &quot;five&quot;, &quot;6&quot;:
        /// &quot;six&quot;}, &quot;2&quot;: {&quot;7&quot;:
        /// &quot;seven&quot;, &quot;8&quot;: &quot;eight&quot;,
        /// &quot;9&quot;: &quot;nine&quot;}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IDictionary<string, string>>>> GetDictionaryValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries of type &lt;string, string&gt;
        /// with value {&quot;0&quot;: {&quot;1&quot;: &quot;one&quot;,
        /// &quot;2&quot;: &quot;two&quot;, &quot;3&quot;:
        /// &quot;three&quot;}, &quot;1&quot;: {&quot;4&quot;:
        /// &quot;four&quot;, &quot;5&quot;: &quot;five&quot;, &quot;6&quot;:
        /// &quot;six&quot;}, &quot;2&quot;: {&quot;7&quot;:
        /// &quot;seven&quot;, &quot;8&quot;: &quot;eight&quot;,
        /// &quot;9&quot;: &quot;nine&quot;}}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDictionaryValidWithOperationResponseAsync(IDictionary<string, IDictionary<string, string>> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
    }
}
