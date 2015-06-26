namespace Fixtures.SwaggerBatUrl
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class QueriesExtensions
    {
            /// <summary>
            /// Get true Boolean value on path
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolQuery'>
            /// true boolean value
            /// </param>
            public static void GetBooleanTrue(this IQueries operations, bool? boolQuery = default(bool?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetBooleanTrueAsync(boolQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get true Boolean value on path
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolQuery'>
            /// true boolean value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetBooleanTrueAsync( this IQueries operations, bool? boolQuery = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetBooleanTrueWithOperationResponseAsync(boolQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get false Boolean value on path
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolQuery'>
            /// false boolean value
            /// </param>
            public static void GetBooleanFalse(this IQueries operations, bool? boolQuery = default(bool?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetBooleanFalseAsync(boolQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get false Boolean value on path
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolQuery'>
            /// false boolean value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetBooleanFalseAsync( this IQueries operations, bool? boolQuery = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetBooleanFalseWithOperationResponseAsync(boolQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null Boolean value on query (query string should be absent)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolQuery'>
            /// null boolean value
            /// </param>
            public static void GetBooleanNull(this IQueries operations, bool? boolQuery = default(bool?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetBooleanNullAsync(boolQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null Boolean value on query (query string should be absent)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolQuery'>
            /// null boolean value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetBooleanNullAsync( this IQueries operations, bool? boolQuery = default(bool?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetBooleanNullWithOperationResponseAsync(boolQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;1000000&apos; integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intQuery'>
            /// &apos;1000000&apos; integer value
            /// </param>
            public static void GetIntOneMillion(this IQueries operations, int? intQuery = default(int?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetIntOneMillionAsync(intQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;1000000&apos; integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intQuery'>
            /// &apos;1000000&apos; integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetIntOneMillionAsync( this IQueries operations, int? intQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetIntOneMillionWithOperationResponseAsync(intQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;-1000000&apos; integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intQuery'>
            /// &apos;-1000000&apos; integer value
            /// </param>
            public static void GetIntNegativeOneMillion(this IQueries operations, int? intQuery = default(int?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetIntNegativeOneMillionAsync(intQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;-1000000&apos; integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intQuery'>
            /// &apos;-1000000&apos; integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetIntNegativeOneMillionAsync( this IQueries operations, int? intQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetIntNegativeOneMillionWithOperationResponseAsync(intQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null integer value (no query parameter)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intQuery'>
            /// null integer value
            /// </param>
            public static void GetIntNull(this IQueries operations, int? intQuery = default(int?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetIntNullAsync(intQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null integer value (no query parameter)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intQuery'>
            /// null integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetIntNullAsync( this IQueries operations, int? intQuery = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetIntNullWithOperationResponseAsync(intQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;10000000000&apos; 64 bit integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longQuery'>
            /// &apos;10000000000&apos; 64 bit integer value
            /// </param>
            public static void GetTenBillion(this IQueries operations, long? longQuery = default(long?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetTenBillionAsync(longQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;10000000000&apos; 64 bit integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longQuery'>
            /// &apos;10000000000&apos; 64 bit integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetTenBillionAsync( this IQueries operations, long? longQuery = default(long?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetTenBillionWithOperationResponseAsync(longQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;-10000000000&apos; 64 bit integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longQuery'>
            /// &apos;-10000000000&apos; 64 bit integer value
            /// </param>
            public static void GetNegativeTenBillion(this IQueries operations, long? longQuery = default(long?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetNegativeTenBillionAsync(longQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;-10000000000&apos; 64 bit integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longQuery'>
            /// &apos;-10000000000&apos; 64 bit integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetNegativeTenBillionAsync( this IQueries operations, long? longQuery = default(long?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetNegativeTenBillionWithOperationResponseAsync(longQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;null 64 bit integer value (no query param in uri)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longQuery'>
            /// null 64 bit integer value
            /// </param>
            public static void GetLongNull(this IQueries operations, long? longQuery = default(long?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).GetLongNullAsync(longQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;null 64 bit integer value (no query param in uri)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longQuery'>
            /// null 64 bit integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetLongNullAsync( this IQueries operations, long? longQuery = default(long?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetLongNullWithOperationResponseAsync(longQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;1.034E+20&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatQuery'>
            /// &apos;1.034E+20&apos;numeric value
            /// </param>
            public static void FloatScientificPositive(this IQueries operations, double? floatQuery = default(double?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).FloatScientificPositiveAsync(floatQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;1.034E+20&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatQuery'>
            /// &apos;1.034E+20&apos;numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task FloatScientificPositiveAsync( this IQueries operations, double? floatQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.FloatScientificPositiveWithOperationResponseAsync(floatQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;-1.034E-20&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatQuery'>
            /// &apos;-1.034E-20&apos;numeric value
            /// </param>
            public static void FloatScientificNegative(this IQueries operations, double? floatQuery = default(double?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).FloatScientificNegativeAsync(floatQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;-1.034E-20&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatQuery'>
            /// &apos;-1.034E-20&apos;numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task FloatScientificNegativeAsync( this IQueries operations, double? floatQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.FloatScientificNegativeWithOperationResponseAsync(floatQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null numeric value (no query parameter)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatQuery'>
            /// null numeric value
            /// </param>
            public static void FloatNull(this IQueries operations, double? floatQuery = default(double?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).FloatNullAsync(floatQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null numeric value (no query parameter)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatQuery'>
            /// null numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task FloatNullAsync( this IQueries operations, double? floatQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.FloatNullWithOperationResponseAsync(floatQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;9999999.999&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doubleQuery'>
            /// &apos;9999999.999&apos;numeric value
            /// </param>
            public static void DoubleDecimalPositive(this IQueries operations, double? doubleQuery = default(double?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).DoubleDecimalPositiveAsync(doubleQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;9999999.999&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doubleQuery'>
            /// &apos;9999999.999&apos;numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DoubleDecimalPositiveAsync( this IQueries operations, double? doubleQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DoubleDecimalPositiveWithOperationResponseAsync(doubleQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;-9999999.999&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doubleQuery'>
            /// &apos;-9999999.999&apos;numeric value
            /// </param>
            public static void DoubleDecimalNegative(this IQueries operations, double? doubleQuery = default(double?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).DoubleDecimalNegativeAsync(doubleQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;-9999999.999&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doubleQuery'>
            /// &apos;-9999999.999&apos;numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DoubleDecimalNegativeAsync( this IQueries operations, double? doubleQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DoubleDecimalNegativeWithOperationResponseAsync(doubleQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null numeric value (no query parameter)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doubleQuery'>
            /// null numeric value
            /// </param>
            public static void DoubleNull(this IQueries operations, double? doubleQuery = default(double?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).DoubleNullAsync(doubleQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null numeric value (no query parameter)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doubleQuery'>
            /// null numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DoubleNullAsync( this IQueries operations, double? doubleQuery = default(double?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DoubleNullWithOperationResponseAsync(doubleQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multi-byte string value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringQuery'>
            /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos;multi-byte string value. Possible values for this
            /// parameter include: &apos;啊齄丂狛狜隣郎隣兀﨩&apos;
            /// </param>
            public static void StringUnicode(this IQueries operations, string stringQuery = default(string))
            {
                Task.Factory.StartNew(s => ((IQueries)s).StringUnicodeAsync(stringQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multi-byte string value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringQuery'>
            /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos;multi-byte string value. Possible values for this
            /// parameter include: &apos;啊齄丂狛狜隣郎隣兀﨩&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task StringUnicodeAsync( this IQueries operations, string stringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.StringUnicodeWithOperationResponseAsync(stringQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringQuery'>
            /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; url encoded string value.
            /// Possible values for this parameter include: &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos;
            /// </param>
            public static void StringUrlEncoded(this IQueries operations, string stringQuery = default(string))
            {
                Task.Factory.StartNew(s => ((IQueries)s).StringUrlEncodedAsync(stringQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringQuery'>
            /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; url encoded string value.
            /// Possible values for this parameter include: &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task StringUrlEncodedAsync( this IQueries operations, string stringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.StringUrlEncodedWithOperationResponseAsync(stringQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringQuery'>
            /// &apos;&apos; string value. Possible values for this parameter include:
            /// &apos;&apos;
            /// </param>
            public static void StringEmpty(this IQueries operations, string stringQuery = default(string))
            {
                Task.Factory.StartNew(s => ((IQueries)s).StringEmptyAsync(stringQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringQuery'>
            /// &apos;&apos; string value. Possible values for this parameter include:
            /// &apos;&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task StringEmptyAsync( this IQueries operations, string stringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.StringEmptyWithOperationResponseAsync(stringQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null (no query parameter in url)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringQuery'>
            /// null string value
            /// </param>
            public static void StringNull(this IQueries operations, string stringQuery = default(string))
            {
                Task.Factory.StartNew(s => ((IQueries)s).StringNullAsync(stringQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null (no query parameter in url)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringQuery'>
            /// null string value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task StringNullAsync( this IQueries operations, string stringQuery = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.StringNullWithOperationResponseAsync(stringQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get using uri with query parameter &apos;green color&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='enumQuery'>
            /// &apos;green color&apos; enum value. Possible values for this parameter
            /// include: &apos;red color&apos;, &apos;green color&apos;, &apos;blue
            /// color&apos;
            /// </param>
            public static void EnumValid(this IQueries operations, UriColor? enumQuery = default(UriColor?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).EnumValidAsync(enumQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get using uri with query parameter &apos;green color&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='enumQuery'>
            /// &apos;green color&apos; enum value. Possible values for this parameter
            /// include: &apos;red color&apos;, &apos;green color&apos;, &apos;blue
            /// color&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task EnumValidAsync( this IQueries operations, UriColor? enumQuery = default(UriColor?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.EnumValidWithOperationResponseAsync(enumQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null (no query parameter in url)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='enumQuery'>
            /// null string value. Possible values for this parameter include: &apos;red
            /// color&apos;, &apos;green color&apos;, &apos;blue color&apos;
            /// </param>
            public static void EnumNull(this IQueries operations, UriColor? enumQuery = default(UriColor?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).EnumNullAsync(enumQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null (no query parameter in url)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='enumQuery'>
            /// null string value. Possible values for this parameter include: &apos;red
            /// color&apos;, &apos;green color&apos;, &apos;blue color&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task EnumNullAsync( this IQueries operations, UriColor? enumQuery = default(UriColor?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.EnumNullWithOperationResponseAsync(enumQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='byteQuery'>
            /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
            /// </param>
            public static void ByteMultiByte(this IQueries operations, byte[] byteQuery = default(byte[]))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ByteMultiByteAsync(byteQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='byteQuery'>
            /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ByteMultiByteAsync( this IQueries operations, byte[] byteQuery = default(byte[]), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ByteMultiByteWithOperationResponseAsync(byteQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;&apos; as byte array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='byteQuery'>
            /// &apos;&apos; as byte array
            /// </param>
            public static void ByteEmpty(this IQueries operations, byte[] byteQuery = default(byte[]))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ByteEmptyAsync(byteQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;&apos; as byte array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='byteQuery'>
            /// &apos;&apos; as byte array
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ByteEmptyAsync( this IQueries operations, byte[] byteQuery = default(byte[]), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ByteEmptyWithOperationResponseAsync(byteQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null as byte array (no query parameters in uri)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='byteQuery'>
            /// null as byte array (no query parameters in uri)
            /// </param>
            public static void ByteNull(this IQueries operations, byte[] byteQuery = default(byte[]))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ByteNullAsync(byteQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null as byte array (no query parameters in uri)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='byteQuery'>
            /// null as byte array (no query parameters in uri)
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ByteNullAsync( this IQueries operations, byte[] byteQuery = default(byte[]), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ByteNullWithOperationResponseAsync(byteQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;2012-01-01&apos; as date
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateQuery'>
            /// &apos;2012-01-01&apos; as date
            /// </param>
            public static void DateValid(this IQueries operations, DateTime? dateQuery = default(DateTime?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).DateValidAsync(dateQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;2012-01-01&apos; as date
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateQuery'>
            /// &apos;2012-01-01&apos; as date
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DateValidAsync( this IQueries operations, DateTime? dateQuery = default(DateTime?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DateValidWithOperationResponseAsync(dateQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null as date - this should result in no query parameters in uri
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateQuery'>
            /// null as date (no query parameters in uri)
            /// </param>
            public static void DateNull(this IQueries operations, DateTime? dateQuery = default(DateTime?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).DateNullAsync(dateQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null as date - this should result in no query parameters in uri
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateQuery'>
            /// null as date (no query parameters in uri)
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DateNullAsync( this IQueries operations, DateTime? dateQuery = default(DateTime?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DateNullWithOperationResponseAsync(dateQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;2012-01-01T01:01:01Z&apos; as date-time
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateTimeQuery'>
            /// &apos;2012-01-01T01:01:01Z&apos; as date-time
            /// </param>
            public static void DateTimeValid(this IQueries operations, DateTime? dateTimeQuery = default(DateTime?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).DateTimeValidAsync(dateTimeQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;2012-01-01T01:01:01Z&apos; as date-time
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateTimeQuery'>
            /// &apos;2012-01-01T01:01:01Z&apos; as date-time
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DateTimeValidAsync( this IQueries operations, DateTime? dateTimeQuery = default(DateTime?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DateTimeValidWithOperationResponseAsync(dateTimeQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null as date-time, should result in no query parameters in uri
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateTimeQuery'>
            /// null as date-time (no query parameters)
            /// </param>
            public static void DateTimeNull(this IQueries operations, DateTime? dateTimeQuery = default(DateTime?))
            {
                Task.Factory.StartNew(s => ((IQueries)s).DateTimeNullAsync(dateTimeQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null as date-time, should result in no query parameters in uri
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateTimeQuery'>
            /// null as date-time (no query parameters)
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DateTimeNullAsync( this IQueries operations, DateTime? dateTimeQuery = default(DateTime?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DateTimeNullWithOperationResponseAsync(dateTimeQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the csv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the csv-array format
            /// </param>
            public static void ArrayStringCsvValid(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ArrayStringCsvValidAsync(arrayQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the csv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the csv-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ArrayStringCsvValidAsync( this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ArrayStringCsvValidWithOperationResponseAsync(arrayQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a null array of string using the csv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// a null array of string using the csv-array format
            /// </param>
            public static void ArrayStringCsvNull(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ArrayStringCsvNullAsync(arrayQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a null array of string using the csv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// a null array of string using the csv-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ArrayStringCsvNullAsync( this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ArrayStringCsvNullWithOperationResponseAsync(arrayQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get an empty array [] of string using the csv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an empty array [] of string using the csv-array format
            /// </param>
            public static void ArrayStringCsvEmpty(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ArrayStringCsvEmptyAsync(arrayQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an empty array [] of string using the csv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an empty array [] of string using the csv-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ArrayStringCsvEmptyAsync( this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ArrayStringCsvEmptyWithOperationResponseAsync(arrayQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the ssv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the ssv-array format
            /// </param>
            public static void ArrayStringSsvValid(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ArrayStringSsvValidAsync(arrayQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the ssv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the ssv-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ArrayStringSsvValidAsync( this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ArrayStringSsvValidWithOperationResponseAsync(arrayQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the tsv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the tsv-array format
            /// </param>
            public static void ArrayStringTsvValid(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ArrayStringTsvValidAsync(arrayQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the tsv-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the tsv-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ArrayStringTsvValidAsync( this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ArrayStringTsvValidWithOperationResponseAsync(arrayQuery, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the pipes-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the pipes-array format
            /// </param>
            public static void ArrayStringPipesValid(this IQueries operations, IList<string> arrayQuery = default(IList<string>))
            {
                Task.Factory.StartNew(s => ((IQueries)s).ArrayStringPipesValidAsync(arrayQuery), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the pipes-array format
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayQuery'>
            /// an array of string [&apos;ArrayQuery1&apos;, &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos; , null, &apos;&apos;] using the pipes-array format
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ArrayStringPipesValidAsync( this IQueries operations, IList<string> arrayQuery = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ArrayStringPipesValidWithOperationResponseAsync(arrayQuery, cancellationToken).ConfigureAwait(false);
            }

    }
}
