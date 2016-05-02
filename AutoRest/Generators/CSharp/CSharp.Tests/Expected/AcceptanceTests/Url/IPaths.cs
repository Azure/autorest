// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsUrl
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Paths operations.
    /// </summary>
    public partial interface IPaths
    {
        /// <summary>
        /// Get true Boolean value on path
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetBooleanTrueWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get false Boolean value on path
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetBooleanFalseWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '1000000' integer value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetIntOneMillionWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '-1000000' integer value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetIntNegativeOneMillionWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '10000000000' 64 bit integer value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetTenBillionWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '-10000000000' 64 bit integer value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetNegativeTenBillionWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '1.034E+20' numeric value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> FloatScientificPositiveWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '-1.034E-20' numeric value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> FloatScientificNegativeWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '9999999.999' numeric value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> DoubleDecimalPositiveWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '-9999999.999' numeric value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> DoubleDecimalNegativeWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '啊齄丂狛狜隣郎隣兀﨩' multi-byte string value
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringUnicodeWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get 'begin!*'();:@ &amp;=+$,/?#[]end
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringUrlEncodedWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get ''
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringEmptyWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null (should throw)
        /// </summary>
        /// <param name='stringPath'>
        /// null string value
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> StringNullWithHttpMessagesAsync(string stringPath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get using uri with 'green color' in path parameter
        /// </summary>
        /// <param name='enumPath'>
        /// send the value green. Possible values include: 'red color', 'green
        /// color', 'blue color'
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> EnumValidWithHttpMessagesAsync(UriColor enumPath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null (should throw on the client before the request is sent on
        /// wire)
        /// </summary>
        /// <param name='enumPath'>
        /// send null should throw. Possible values include: 'red color',
        /// 'green color', 'blue color'
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> EnumNullWithHttpMessagesAsync(UriColor enumPath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array
        /// </summary>
        /// <param name='bytePath'>
        /// '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteMultiByteWithHttpMessagesAsync(byte[] bytePath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '' as byte array
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteEmptyWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as byte array (should throw)
        /// </summary>
        /// <param name='bytePath'>
        /// null as byte array (should throw)
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> ByteNullWithHttpMessagesAsync(byte[] bytePath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '2012-01-01' as date
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateValidWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as date - this should throw or be unusable on the client
        /// side, depending on date representation
        /// </summary>
        /// <param name='datePath'>
        /// null as date (should throw)
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateNullWithHttpMessagesAsync(DateTime datePath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get '2012-01-01T01:01:01Z' as date-time
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateTimeValidWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get null as date-time, should be disallowed or throw depending on
        /// representation of date-time
        /// </summary>
        /// <param name='dateTimePath'>
        /// null as date-time
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> DateTimeNullWithHttpMessagesAsync(DateTime dateTimePath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get 'lorem' encoded value as 'bG9yZW0' (base64url)
        /// </summary>
        /// <param name='base64UrlPath'>
        /// base64url encoded value
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> Base64UrlWithHttpMessagesAsync(byte[] base64UrlPath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get an array of string ['ArrayPath1', 'begin!*'();:@
        /// &amp;=+$,/?#[]end' , null, ''] using the csv-array format
        /// </summary>
        /// <param name='arrayPath'>
        /// an array of string ['ArrayPath1', 'begin!*'();:@
        /// &amp;=+$,/?#[]end' , null, ''] using the csv-array format
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> ArrayCsvInPathWithHttpMessagesAsync(IList<string> arrayPath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get the date 2016-04-13 encoded value as '1460505600' (Unix time)
        /// </summary>
        /// <param name='unixTimeUrlPath'>
        /// Unix time encoded value
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to the request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> UnixTimeUrlWithHttpMessagesAsync(DateTime unixTimeUrlPath, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
