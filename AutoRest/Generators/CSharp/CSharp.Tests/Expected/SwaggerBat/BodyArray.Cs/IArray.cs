namespace Fixtures.SwaggerBatBodyArray
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
    public partial interface IArray
    {
        /// <summary>
        /// Get null array value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get invalid array [1, 2, 3
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> GetInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get empty array value []
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> GetEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value empty []
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutEmptyWithOperationResponseAsync(IList<string> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean array value [true, false, false, true]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<bool?>>> GetBooleanTfftWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value empty [true, false, false, true]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutBooleanTfftWithOperationResponseAsync(IList<bool?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean array value [true, null, false]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<bool?>>> GetBooleanInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean array value [true, &apos;boolean&apos;, false]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<bool?>>> GetBooleanInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer array value [1, -1, 3, 300]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> GetIntegerValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value empty [1, -1, 3, 300]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutIntegerValidWithOperationResponseAsync(IList<int?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer array value [1, null, 0]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> GetIntInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer array value [1, &apos;integer&apos;, 0]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> GetIntInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer array value [1, -1, 3, 300]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<long?>>> GetLongValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value empty [1, -1, 3, 300]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutLongValidWithOperationResponseAsync(IList<long?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get long array value [1, null, 0]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<long?>>> GetLongInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get long array value [1, &apos;integer&apos;, 0]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<long?>>> GetLongInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float array value [0, -0.01, 1.2e20]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<double?>>> GetFloatValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value [0, -0.01, 1.2e20]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutFloatValidWithOperationResponseAsync(IList<double?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float array value [0.0, null, -1.2e20]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<double?>>> GetFloatInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean array value [1.0, &apos;number&apos;, 0.0]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<double?>>> GetFloatInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float array value [0, -0.01, 1.2e20]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<double?>>> GetDoubleValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value [0, -0.01, 1.2e20]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDoubleValidWithOperationResponseAsync(IList<double?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float array value [0.0, null, -1.2e20]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<double?>>> GetDoubleInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean array value [1.0, &apos;number&apos;, 0.0]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<double?>>> GetDoubleInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string array value [&apos;foo1&apos;, &apos;foo2&apos;,
        /// &apos;foo3&apos;]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<string>>> GetStringValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value [&apos;foo1&apos;, &apos;foo2&apos;,
        /// &apos;foo3&apos;]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutStringValidWithOperationResponseAsync(IList<string> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string array value [&apos;foo&apos;, null, &apos;foo2&apos;]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<string>>> GetStringWithNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string array value [&apos;foo&apos;, 123, &apos;foo2&apos;]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<string>>> GetStringWithInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer array value [&apos;2000-12-01&apos;,
        /// &apos;1980-01-02&apos;, &apos;1492-10-12&apos;]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<DateTime?>>> GetDateValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value  [&apos;2000-12-01&apos;, &apos;1980-01-02&apos;,
        /// &apos;1492-10-12&apos;]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDateValidWithOperationResponseAsync(IList<DateTime?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date array value [&apos;2012-01-01&apos;, null,
        /// &apos;1776-07-04&apos;]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<DateTime?>>> GetDateInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date array value [&apos;2011-03-22&apos;, &apos;date&apos;]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<DateTime?>>> GetDateInvalidCharsWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date-time array value [&apos;2000-12-01t00:00:01z&apos;,
        /// &apos;1980-01-02T00:11:35+01:00&apos;,
        /// &apos;1492-10-12T10:15:01-08:00&apos;]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<DateTime?>>> GetDateTimeValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set array value  [&apos;2000-12-01t00:00:01z&apos;,
        /// &apos;1980-01-02T00:11:35+01:00&apos;,
        /// &apos;1492-10-12T10:15:01-08:00&apos;]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDateTimeValidWithOperationResponseAsync(IList<DateTime?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date array value [&apos;2000-12-01t00:00:01z&apos;, null]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<DateTime?>>> GetDateTimeInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date array value [&apos;2000-12-01t00:00:01z&apos;,
        /// &apos;date-time&apos;]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<DateTime?>>> GetDateTimeInvalidCharsWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get byte array value [hex(FF FF FF FA), hex(01 02 03), hex (25,
        /// 29, 43)] with each item encoded in base64
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<byte[]>>> GetByteValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put the array value [hex(FF FF FF FA), hex(01 02 03), hex (25, 29,
        /// 43)] with each elementencoded in base 64
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutByteValidWithOperationResponseAsync(IList<byte[]> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get byte array value [hex(AB, AC, AD), null] with the first item
        /// base64 encoded
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<byte[]>>> GetByteInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get array of complex type null value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Product>>> GetComplexNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get empty array of complex type []
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Product>>> GetComplexEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get array of complex type with null item [{&apos;integer&apos;: 1
        /// &apos;string&apos;: &apos;2&apos;}, null, {&apos;integer&apos;:
        /// 5, &apos;string&apos;: &apos;6&apos;}]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Product>>> GetComplexItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get array of complex type with empty item [{&apos;integer&apos;: 1
        /// &apos;string&apos;: &apos;2&apos;}, {}, {&apos;integer&apos;: 5,
        /// &apos;string&apos;: &apos;6&apos;}]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Product>>> GetComplexItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get array of complex type with [{&apos;integer&apos;: 1
        /// &apos;string&apos;: &apos;2&apos;}, {&apos;integer&apos;: 3,
        /// &apos;string&apos;: &apos;4&apos;}, {&apos;integer&apos;: 5,
        /// &apos;string&apos;: &apos;6&apos;}]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Product>>> GetComplexValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put an array of complex type with values [{&apos;integer&apos;: 1
        /// &apos;string&apos;: &apos;2&apos;}, {&apos;integer&apos;: 3,
        /// &apos;string&apos;: &apos;4&apos;}, {&apos;integer&apos;: 5,
        /// &apos;string&apos;: &apos;6&apos;}]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutComplexValidWithOperationResponseAsync(IList<Product> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a null array
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IList<string>>>> GetArrayNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an empty array []
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IList<string>>>> GetArrayEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of array of strings [[&apos;1&apos;, &apos;2&apos;,
        /// &apos;3&apos;], null, [&apos;7&apos;, &apos;8&apos;,
        /// &apos;9&apos;]]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IList<string>>>> GetArrayItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of array of strings [[&apos;1&apos;, &apos;2&apos;,
        /// &apos;3&apos;], [], [&apos;7&apos;, &apos;8&apos;, &apos;9&apos;]]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IList<string>>>> GetArrayItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of array of strings [[&apos;1&apos;, &apos;2&apos;,
        /// &apos;3&apos;], [&apos;4&apos;, &apos;5&apos;, &apos;6&apos;],
        /// [&apos;7&apos;, &apos;8&apos;, &apos;9&apos;]]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IList<string>>>> GetArrayValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put An array of array of strings [[&apos;1&apos;, &apos;2&apos;,
        /// &apos;3&apos;], [&apos;4&apos;, &apos;5&apos;, &apos;6&apos;],
        /// [&apos;7&apos;, &apos;8&apos;, &apos;9&apos;]]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutArrayValidWithOperationResponseAsync(IList<IList<string>> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of Dictionaries with value null
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IDictionary<string, string>>>> GetDictionaryNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of Dictionaries of type &lt;string, string&gt; with
        /// value []
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IDictionary<string, string>>>> GetDictionaryEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of Dictionaries of type &lt;string, string&gt; with
        /// value [{&apos;1&apos;: &apos;one&apos;, &apos;2&apos;:
        /// &apos;two&apos;, &apos;3&apos;: &apos;three&apos;}, null,
        /// {&apos;7&apos;: &apos;seven&apos;, &apos;8&apos;:
        /// &apos;eight&apos;, &apos;9&apos;: &apos;nine&apos;}]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IDictionary<string, string>>>> GetDictionaryItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of Dictionaries of type &lt;string, string&gt; with
        /// value [{&apos;1&apos;: &apos;one&apos;, &apos;2&apos;:
        /// &apos;two&apos;, &apos;3&apos;: &apos;three&apos;}, {},
        /// {&apos;7&apos;: &apos;seven&apos;, &apos;8&apos;:
        /// &apos;eight&apos;, &apos;9&apos;: &apos;nine&apos;}]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IDictionary<string, string>>>> GetDictionaryItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of Dictionaries of type &lt;string, string&gt; with
        /// value [{&apos;1&apos;: &apos;one&apos;, &apos;2&apos;:
        /// &apos;two&apos;, &apos;3&apos;: &apos;three&apos;},
        /// {&apos;4&apos;: &apos;four&apos;, &apos;5&apos;:
        /// &apos;five&apos;, &apos;6&apos;: &apos;six&apos;},
        /// {&apos;7&apos;: &apos;seven&apos;, &apos;8&apos;:
        /// &apos;eight&apos;, &apos;9&apos;: &apos;nine&apos;}]
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<IDictionary<string, string>>>> GetDictionaryValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of Dictionaries of type &lt;string, string&gt; with
        /// value [{&apos;1&apos;: &apos;one&apos;, &apos;2&apos;:
        /// &apos;two&apos;, &apos;3&apos;: &apos;three&apos;},
        /// {&apos;4&apos;: &apos;four&apos;, &apos;5&apos;:
        /// &apos;five&apos;, &apos;6&apos;: &apos;six&apos;},
        /// {&apos;7&apos;: &apos;seven&apos;, &apos;8&apos;:
        /// &apos;eight&apos;, &apos;9&apos;: &apos;nine&apos;}]
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDictionaryValidWithOperationResponseAsync(IList<IDictionary<string, string>> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
    }
}
