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
        /// Get boolean dictionary value {"0": true, "1": false, "2": false,
        /// "3": true }
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, bool?>>> GetBooleanTfftWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value empty {"0": true, "1": false, "2": false,
        /// "3": true }
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutBooleanTfftWithOperationResponseAsync(IDictionary<string, bool?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value {"0": true, "1": null, "2": false }
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, bool?>>> GetBooleanInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value '{"0": true, "1": "boolean", "2":
        /// false}'
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, bool?>>> GetBooleanInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {"0": 1, "1": -1, "2": 3, "3": 300}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetIntegerValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value empty {"0": 1, "1": -1, "2": 3, "3": 300}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutIntegerValidWithOperationResponseAsync(IDictionary<string, int?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {"0": 1, "1": null, "2": 0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetIntInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {"0": 1, "1": "integer", "2": 0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetIntInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {"0": 1, "1": -1, "2": 3, "3": 300}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, long?>>> GetLongValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value empty {"0": 1, "1": -1, "2": 3, "3": 300}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutLongValidWithOperationResponseAsync(IDictionary<string, long?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get long dictionary value {"0": 1, "1": null, "2": 0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, long?>>> GetLongInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get long dictionary value {"0": 1, "1": "integer", "2": 0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, long?>>> GetLongInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetFloatValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutFloatValidWithOperationResponseAsync(IDictionary<string, double?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float dictionary value {"0": 0.0, "1": null, "2": 1.2e20}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetFloatInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value {"0": 1.0, "1": "number", "2": 0.0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetFloatInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetDoubleValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDoubleValidWithOperationResponseAsync(IDictionary<string, double?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get float dictionary value {"0": 0.0, "1": null, "2": 1.2e20}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetDoubleInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get boolean dictionary value {"0": 1.0, "1": "number", "2": 0.0}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, double?>>> GetDoubleInvalidStringWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string dictionary value {"0": "foo1", "1": "foo2", "2": "foo3"}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetStringValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value {"0": "foo1", "1": "foo2", "2": "foo3"}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutStringValidWithOperationResponseAsync(IDictionary<string, string> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string dictionary value {"0": "foo", "1": null, "2": "foo2"}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetStringWithNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string dictionary value {"0": "foo", "1": 123, "2": "foo2"}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, string>>> GetStringWithInvalidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get integer dictionary value {"0": "2000-12-01", "1":
        /// "1980-01-02", "2": "1492-10-12"}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value  {"0": "2000-12-01", "1": "1980-01-02", "2":
        /// "1492-10-12"}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDateValidWithOperationResponseAsync(IDictionary<string, DateTime?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date dictionary value {"0": "2012-01-01", "1": null, "2":
        /// "1776-07-04"}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date dictionary value {"0": "2011-03-22", "1": "date"}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateInvalidCharsWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date-time dictionary value {"0": "2000-12-01t00:00:01z", "1":
        /// "1980-01-02T00:11:35+01:00", "2": "1492-10-12T10:15:01-08:00"}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateTimeValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set dictionary value  {"0": "2000-12-01t00:00:01z", "1":
        /// "1980-01-02T00:11:35+01:00", "2": "1492-10-12T10:15:01-08:00"}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDateTimeValidWithOperationResponseAsync(IDictionary<string, DateTime?> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date dictionary value {"0": "2000-12-01t00:00:01z", "1": null}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateTimeInvalidNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get date dictionary value {"0": "2000-12-01t00:00:01z", "1":
        /// "date-time"}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, DateTime?>>> GetDateTimeInvalidCharsWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get byte dictionary value {"0": hex(FF FF FF FA), "1": hex(01 02
        /// 03), "2": hex (25, 29, 43)} with each item encoded in base64
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, byte[]>>> GetByteValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put the dictionary value {"0": hex(FF FF FF FA), "1": hex(01 02
        /// 03), "2": hex (25, 29, 43)} with each elementencoded in base 64
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutByteValidWithOperationResponseAsync(IDictionary<string, byte[]> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get byte dictionary value {"0": hex(FF FF FF FA), "1": null} with
        /// the first item base64 encoded
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
        /// Get dictionary of complex type with null item {"0": {"integer": 1,
        /// "string": "2"}, "1": null, "2": {"integer": 5, "string": "6"}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, Widget>>> GetComplexItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get dictionary of complex type with empty item {"0": {"integer":
        /// 1, "string": "2"}, "1:" {}, "2": {"integer": 5, "string": "6"}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, Widget>>> GetComplexItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get dictionary of complex type with {"0": {"integer": 1, "string":
        /// "2"}, "1": {"integer": 3, "string": "4"}, "2": {"integer": 5,
        /// "string": "6"}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, Widget>>> GetComplexValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put an dictionary of complex type with values {"0": {"integer": 1,
        /// "string": "2"}, "1": {"integer": 3, "string": "4"}, "2":
        /// {"integer": 5, "string": "6"}}
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
        /// Get an dictionary of array of strings {"0": ["1", "2", "3"], "1":
        /// null, "2": ["7", "8", "9"]}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IList<string>>>> GetArrayItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of array of strings [{"0": ["1", "2", "3"], "1": [],
        /// "2": ["7", "8", "9"]}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IList<string>>>> GetArrayItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of array of strings {"0": ["1", "2", "3"], "1": ["4",
        /// "5", "6"], "2": ["7", "8", "9"]}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IList<string>>>> GetArrayValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Put An array of array of strings {"0": ["1", "2", "3"], "1": ["4",
        /// "5", "6"], "2": ["7", "8", "9"]}
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
        /// with value {"0": {"1": "one", "2": "two", "3": "three"}, "1":
        /// null, "2": {"7": "seven", "8": "eight", "9": "nine"}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IDictionary<string, string>>>> GetDictionaryItemNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries of type &lt;string, string&gt;
        /// with value {"0": {"1": "one", "2": "two", "3": "three"}, "1": {},
        /// "2": {"7": "seven", "8": "eight", "9": "nine"}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IDictionary<string, string>>>> GetDictionaryItemEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries of type &lt;string, string&gt;
        /// with value {"0": {"1": "one", "2": "two", "3": "three"}, "1":
        /// {"4": "four", "5": "five", "6": "six"}, "2": {"7": "seven", "8":
        /// "eight", "9": "nine"}}
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, IDictionary<string, string>>>> GetDictionaryValidWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an dictionaries of dictionaries of type &lt;string, string&gt;
        /// with value {"0": {"1": "one", "2": "two", "3": "three"}, "1":
        /// {"4": "four", "5": "five", "6": "six"}, "2": {"7": "seven", "8":
        /// "eight", "9": "nine"}}
        /// </summary>
        /// <param name='arrayBody'>
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutDictionaryValidWithOperationResponseAsync(IDictionary<string, IDictionary<string, string>> arrayBody, CancellationToken cancellationToken = default(CancellationToken));
    }
}
