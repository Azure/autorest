namespace Fixtures.SwaggerBatUrl
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
    public partial interface IQueries
    {
        /// <summary>
        /// Get true Boolean value on path
        /// </summary>
        /// <param name='boolQuery'>
        /// true boolean value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetBooleanTrueWithOperationResponseAsync(bool? boolQuery = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get false Boolean value on path
        /// </summary>
        /// <param name='boolQuery'>
        /// false boolean value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetBooleanFalseWithOperationResponseAsync(bool? boolQuery = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null Boolean value on query (query string should be absent)
        /// </summary>
        /// <param name='boolQuery'>
        /// null boolean value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetBooleanNullWithOperationResponseAsync(bool? boolQuery = default(bool?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;1000000&apos; integer value
        /// </summary>
        /// <param name='intQuery'>
        /// &apos;1000000&apos; integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetIntOneMillionWithOperationResponseAsync(int? intQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;-1000000&apos; integer value
        /// </summary>
        /// <param name='intQuery'>
        /// &apos;-1000000&apos; integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetIntNegativeOneMillionWithOperationResponseAsync(int? intQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null integer value (no query parameter)
        /// </summary>
        /// <param name='intQuery'>
        /// null integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetIntNullWithOperationResponseAsync(int? intQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;10000000000&apos; 64 bit integer value
        /// </summary>
        /// <param name='longQuery'>
        /// &apos;10000000000&apos; 64 bit integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetTenBillionWithOperationResponseAsync(long? longQuery = default(long?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;-10000000000&apos; 64 bit integer value
        /// </summary>
        /// <param name='longQuery'>
        /// &apos;-10000000000&apos; 64 bit integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetNegativeTenBillionWithOperationResponseAsync(long? longQuery = default(long?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;null 64 bit integer value (no query param in uri)
        /// </summary>
        /// <param name='longQuery'>
        /// null 64 bit integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetLongNullWithOperationResponseAsync(long? longQuery = default(long?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;1.034E+20&apos; numeric value
        /// </summary>
        /// <param name='floatQuery'>
        /// &apos;1.034E+20&apos;numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> FloatScientificPositiveWithOperationResponseAsync(double? floatQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;-1.034E-20&apos; numeric value
        /// </summary>
        /// <param name='floatQuery'>
        /// &apos;-1.034E-20&apos;numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> FloatScientificNegativeWithOperationResponseAsync(double? floatQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null numeric value (no query parameter)
        /// </summary>
        /// <param name='floatQuery'>
        /// null numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> FloatNullWithOperationResponseAsync(double? floatQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;9999999.999&apos; numeric value
        /// </summary>
        /// <param name='doubleQuery'>
        /// &apos;9999999.999&apos;numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DoubleDecimalPositiveWithOperationResponseAsync(double? doubleQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;-9999999.999&apos; numeric value
        /// </summary>
        /// <param name='doubleQuery'>
        /// &apos;-9999999.999&apos;numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DoubleDecimalNegativeWithOperationResponseAsync(double? doubleQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null numeric value (no query parameter)
        /// </summary>
        /// <param name='doubleQuery'>
        /// null numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DoubleNullWithOperationResponseAsync(double? doubleQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multi-byte string value
        /// </summary>
        /// <param name='stringQuery'>
        /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos;multi-byte string value. Possible values for
        /// this parameter include: &apos;啊齄丂狛狜隣郎隣兀﨩&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringUnicodeWithOperationResponseAsync(string stringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end
        /// </summary>
        /// <param name='stringQuery'>
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; url encoded
        /// string value. Possible values for this parameter include:
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringUrlEncodedWithOperationResponseAsync(string stringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;&apos;
        /// </summary>
        /// <param name='stringQuery'>
        /// &apos;&apos; string value. Possible values for this parameter
        /// include: &apos;&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringEmptyWithOperationResponseAsync(string stringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null (no query parameter in url)
        /// </summary>
        /// <param name='stringQuery'>
        /// null string value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringNullWithOperationResponseAsync(string stringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get using uri with query parameter &apos;green color&apos;
        /// </summary>
        /// <param name='enumQuery'>
        /// &apos;green color&apos; enum value. Possible values for this
        /// parameter include: &apos;red color&apos;, &apos;green
        /// color&apos;, &apos;blue color&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> EnumValidWithOperationResponseAsync(UriColor? enumQuery = default(UriColor?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null (no query parameter in url)
        /// </summary>
        /// <param name='enumQuery'>
        /// null string value. Possible values for this parameter include:
        /// &apos;red color&apos;, &apos;green color&apos;, &apos;blue
        /// color&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> EnumNullWithOperationResponseAsync(UriColor? enumQuery = default(UriColor?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte
        /// array
        /// </summary>
        /// <param name='byteQuery'>
        /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteMultiByteWithOperationResponseAsync(byte[] byteQuery = default(byte[]), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;&apos; as byte array
        /// </summary>
        /// <param name='byteQuery'>
        /// &apos;&apos; as byte array
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteEmptyWithOperationResponseAsync(byte[] byteQuery = default(byte[]), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as byte array (no query parameters in uri)
        /// </summary>
        /// <param name='byteQuery'>
        /// null as byte array (no query parameters in uri)
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteNullWithOperationResponseAsync(byte[] byteQuery = default(byte[]), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;2012-01-01&apos; as date
        /// </summary>
        /// <param name='dateQuery'>
        /// &apos;2012-01-01&apos; as date
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateValidWithOperationResponseAsync(DateTime? dateQuery = default(DateTime?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as date - this should result in no query parameters in uri
        /// </summary>
        /// <param name='dateQuery'>
        /// null as date (no query parameters in uri)
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateNullWithOperationResponseAsync(DateTime? dateQuery = default(DateTime?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;2012-01-01T01:01:01Z&apos; as date-time
        /// </summary>
        /// <param name='dateTimeQuery'>
        /// &apos;2012-01-01T01:01:01Z&apos; as date-time
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateTimeValidWithOperationResponseAsync(DateTime? dateTimeQuery = default(DateTime?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as date-time, should result in no query parameters in uri
        /// </summary>
        /// <param name='dateTimeQuery'>
        /// null as date-time (no query parameters)
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateTimeNullWithOperationResponseAsync(DateTime? dateTimeQuery = default(DateTime?), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of string [&apos;ArrayQuery1&apos;,
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; , null,
        /// &apos;&apos;] using the csv-array format
        /// </summary>
        /// <param name='arrayQuery'>
        /// an array of string [&apos;ArrayQuery1&apos;,
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; , null,
        /// &apos;&apos;] using the csv-array format
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ArrayStringCsvValidWithOperationResponseAsync(IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get a null array of string using the csv-array format
        /// </summary>
        /// <param name='arrayQuery'>
        /// a null array of string using the csv-array format
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ArrayStringCsvNullWithOperationResponseAsync(IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an empty array [] of string using the csv-array format
        /// </summary>
        /// <param name='arrayQuery'>
        /// an empty array [] of string using the csv-array format
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ArrayStringCsvEmptyWithOperationResponseAsync(IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of string [&apos;ArrayQuery1&apos;,
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; , null,
        /// &apos;&apos;] using the ssv-array format
        /// </summary>
        /// <param name='arrayQuery'>
        /// an array of string [&apos;ArrayQuery1&apos;,
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; , null,
        /// &apos;&apos;] using the ssv-array format
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ArrayStringSsvValidWithOperationResponseAsync(IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of string [&apos;ArrayQuery1&apos;,
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; , null,
        /// &apos;&apos;] using the tsv-array format
        /// </summary>
        /// <param name='arrayQuery'>
        /// an array of string [&apos;ArrayQuery1&apos;,
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; , null,
        /// &apos;&apos;] using the tsv-array format
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ArrayStringTsvValidWithOperationResponseAsync(IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of string [&apos;ArrayQuery1&apos;,
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; , null,
        /// &apos;&apos;] using the pipes-array format
        /// </summary>
        /// <param name='arrayQuery'>
        /// an array of string [&apos;ArrayQuery1&apos;,
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; , null,
        /// &apos;&apos;] using the pipes-array format
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ArrayStringPipesValidWithOperationResponseAsync(IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken));
    }
}
