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
    public partial interface IPaths
    {
        /// <summary>
        /// Get true Boolean value on path
        /// </summary>
        /// <param name='boolPath'>
        /// true boolean value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetBooleanTrueWithOperationResponseAsync(bool? boolPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get false Boolean value on path
        /// </summary>
        /// <param name='boolPath'>
        /// false boolean value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetBooleanFalseWithOperationResponseAsync(bool? boolPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;1000000&apos; integer value
        /// </summary>
        /// <param name='intPath'>
        /// &apos;1000000&apos; integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetIntOneMillionWithOperationResponseAsync(int? intPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;-1000000&apos; integer value
        /// </summary>
        /// <param name='intPath'>
        /// &apos;-1000000&apos; integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetIntNegativeOneMillionWithOperationResponseAsync(int? intPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;10000000000&apos; 64 bit integer value
        /// </summary>
        /// <param name='longPath'>
        /// &apos;10000000000&apos; 64 bit integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetTenBillionWithOperationResponseAsync(long? longPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;-10000000000&apos; 64 bit integer value
        /// </summary>
        /// <param name='longPath'>
        /// &apos;-10000000000&apos; 64 bit integer value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetNegativeTenBillionWithOperationResponseAsync(long? longPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;1.034E+20&apos; numeric value
        /// </summary>
        /// <param name='floatPath'>
        /// &apos;1.034E+20&apos;numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> FloatScientificPositiveWithOperationResponseAsync(double? floatPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;-1.034E-20&apos; numeric value
        /// </summary>
        /// <param name='floatPath'>
        /// &apos;-1.034E-20&apos;numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> FloatScientificNegativeWithOperationResponseAsync(double? floatPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;9999999.999&apos; numeric value
        /// </summary>
        /// <param name='doublePath'>
        /// &apos;9999999.999&apos;numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DoubleDecimalPositiveWithOperationResponseAsync(double? doublePath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;-9999999.999&apos; numeric value
        /// </summary>
        /// <param name='doublePath'>
        /// &apos;-9999999.999&apos;numeric value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DoubleDecimalNegativeWithOperationResponseAsync(double? doublePath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multi-byte string value
        /// </summary>
        /// <param name='stringPath'>
        /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos;multi-byte string value. Possible values for
        /// this parameter include: &apos;啊齄丂狛狜隣郎隣兀﨩&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringUnicodeWithOperationResponseAsync(string stringPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end
        /// </summary>
        /// <param name='stringPath'>
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; url encoded
        /// string value. Possible values for this parameter include:
        /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringUrlEncodedWithOperationResponseAsync(string stringPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;&apos;
        /// </summary>
        /// <param name='stringPath'>
        /// &apos;&apos; string value. Possible values for this parameter
        /// include: &apos;&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringEmptyWithOperationResponseAsync(string stringPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null (should throw)
        /// </summary>
        /// <param name='stringPath'>
        /// null string value
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringNullWithOperationResponseAsync(string stringPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get using uri with &apos;green color&apos; in path parameter
        /// </summary>
        /// <param name='enumPath'>
        /// send the value green. Possible values for this parameter include:
        /// &apos;red color&apos;, &apos;green color&apos;, &apos;blue
        /// color&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> EnumValidWithOperationResponseAsync(UriColor? enumPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null (should throw on the client before the request is sent on
        /// wire)
        /// </summary>
        /// <param name='enumPath'>
        /// send null should throw. Possible values for this parameter
        /// include: &apos;red color&apos;, &apos;green color&apos;,
        /// &apos;blue color&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> EnumNullWithOperationResponseAsync(UriColor? enumPath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte
        /// array
        /// </summary>
        /// <param name='bytePath'>
        /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteMultiByteWithOperationResponseAsync(byte[] bytePath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;&apos; as byte array
        /// </summary>
        /// <param name='bytePath'>
        /// &apos;&apos; as byte array
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteEmptyWithOperationResponseAsync(byte[] bytePath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as byte array (should throw)
        /// </summary>
        /// <param name='bytePath'>
        /// null as byte array (should throw)
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteNullWithOperationResponseAsync(byte[] bytePath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;2012-01-01&apos; as date
        /// </summary>
        /// <param name='datePath'>
        /// &apos;2012-01-01&apos; as date
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateValidWithOperationResponseAsync(DateTime? datePath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as date - this should throw or be unusable on the client
        /// side, depending on date representation
        /// </summary>
        /// <param name='datePath'>
        /// null as date (should throw)
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateNullWithOperationResponseAsync(DateTime? datePath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get &apos;2012-01-01T01:01:01Z&apos; as date-time
        /// </summary>
        /// <param name='dateTimePath'>
        /// &apos;2012-01-01T01:01:01Z&apos; as date-time
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateTimeValidWithOperationResponseAsync(DateTime? dateTimePath, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as date-time, should be disallowed or throw depending on
        /// representation of date-time
        /// </summary>
        /// <param name='dateTimePath'>
        /// null as date-time
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateTimeNullWithOperationResponseAsync(DateTime? dateTimePath, CancellationToken cancellationToken = default(CancellationToken));
    }
}
