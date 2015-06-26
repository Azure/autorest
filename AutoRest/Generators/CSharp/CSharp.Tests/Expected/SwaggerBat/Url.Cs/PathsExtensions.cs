namespace Fixtures.SwaggerBatUrl
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class PathsExtensions
    {
            /// <summary>
            /// Get true Boolean value on path
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolPath'>
            /// true boolean value
            /// </param>
            public static void GetBooleanTrue(this IPaths operations, bool? boolPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).GetBooleanTrueAsync(boolPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get true Boolean value on path
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolPath'>
            /// true boolean value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetBooleanTrueAsync( this IPaths operations, bool? boolPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetBooleanTrueWithOperationResponseAsync(boolPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get false Boolean value on path
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolPath'>
            /// false boolean value
            /// </param>
            public static void GetBooleanFalse(this IPaths operations, bool? boolPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).GetBooleanFalseAsync(boolPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get false Boolean value on path
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='boolPath'>
            /// false boolean value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetBooleanFalseAsync( this IPaths operations, bool? boolPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetBooleanFalseWithOperationResponseAsync(boolPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;1000000&apos; integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intPath'>
            /// &apos;1000000&apos; integer value
            /// </param>
            public static void GetIntOneMillion(this IPaths operations, int? intPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).GetIntOneMillionAsync(intPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;1000000&apos; integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intPath'>
            /// &apos;1000000&apos; integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetIntOneMillionAsync( this IPaths operations, int? intPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetIntOneMillionWithOperationResponseAsync(intPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;-1000000&apos; integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intPath'>
            /// &apos;-1000000&apos; integer value
            /// </param>
            public static void GetIntNegativeOneMillion(this IPaths operations, int? intPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).GetIntNegativeOneMillionAsync(intPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;-1000000&apos; integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='intPath'>
            /// &apos;-1000000&apos; integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetIntNegativeOneMillionAsync( this IPaths operations, int? intPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetIntNegativeOneMillionWithOperationResponseAsync(intPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;10000000000&apos; 64 bit integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longPath'>
            /// &apos;10000000000&apos; 64 bit integer value
            /// </param>
            public static void GetTenBillion(this IPaths operations, long? longPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).GetTenBillionAsync(longPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;10000000000&apos; 64 bit integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longPath'>
            /// &apos;10000000000&apos; 64 bit integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetTenBillionAsync( this IPaths operations, long? longPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetTenBillionWithOperationResponseAsync(longPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;-10000000000&apos; 64 bit integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longPath'>
            /// &apos;-10000000000&apos; 64 bit integer value
            /// </param>
            public static void GetNegativeTenBillion(this IPaths operations, long? longPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).GetNegativeTenBillionAsync(longPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;-10000000000&apos; 64 bit integer value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='longPath'>
            /// &apos;-10000000000&apos; 64 bit integer value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetNegativeTenBillionAsync( this IPaths operations, long? longPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetNegativeTenBillionWithOperationResponseAsync(longPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;1.034E+20&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatPath'>
            /// &apos;1.034E+20&apos;numeric value
            /// </param>
            public static void FloatScientificPositive(this IPaths operations, double? floatPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).FloatScientificPositiveAsync(floatPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;1.034E+20&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatPath'>
            /// &apos;1.034E+20&apos;numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task FloatScientificPositiveAsync( this IPaths operations, double? floatPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.FloatScientificPositiveWithOperationResponseAsync(floatPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;-1.034E-20&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatPath'>
            /// &apos;-1.034E-20&apos;numeric value
            /// </param>
            public static void FloatScientificNegative(this IPaths operations, double? floatPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).FloatScientificNegativeAsync(floatPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;-1.034E-20&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='floatPath'>
            /// &apos;-1.034E-20&apos;numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task FloatScientificNegativeAsync( this IPaths operations, double? floatPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.FloatScientificNegativeWithOperationResponseAsync(floatPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;9999999.999&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doublePath'>
            /// &apos;9999999.999&apos;numeric value
            /// </param>
            public static void DoubleDecimalPositive(this IPaths operations, double? doublePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).DoubleDecimalPositiveAsync(doublePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;9999999.999&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doublePath'>
            /// &apos;9999999.999&apos;numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DoubleDecimalPositiveAsync( this IPaths operations, double? doublePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DoubleDecimalPositiveWithOperationResponseAsync(doublePath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;-9999999.999&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doublePath'>
            /// &apos;-9999999.999&apos;numeric value
            /// </param>
            public static void DoubleDecimalNegative(this IPaths operations, double? doublePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).DoubleDecimalNegativeAsync(doublePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;-9999999.999&apos; numeric value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='doublePath'>
            /// &apos;-9999999.999&apos;numeric value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DoubleDecimalNegativeAsync( this IPaths operations, double? doublePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DoubleDecimalNegativeWithOperationResponseAsync(doublePath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multi-byte string value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringPath'>
            /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos;multi-byte string value. Possible values for this
            /// parameter include: &apos;啊齄丂狛狜隣郎隣兀﨩&apos;
            /// </param>
            public static void StringUnicode(this IPaths operations, string stringPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).StringUnicodeAsync(stringPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multi-byte string value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringPath'>
            /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos;multi-byte string value. Possible values for this
            /// parameter include: &apos;啊齄丂狛狜隣郎隣兀﨩&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task StringUnicodeAsync( this IPaths operations, string stringPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.StringUnicodeWithOperationResponseAsync(stringPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringPath'>
            /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; url encoded string value.
            /// Possible values for this parameter include: &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos;
            /// </param>
            public static void StringUrlEncoded(this IPaths operations, string stringPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).StringUrlEncodedAsync(stringPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringPath'>
            /// &apos;begin!*&apos;();:@ &amp;=+$,/?#[]end&apos; url encoded string value.
            /// Possible values for this parameter include: &apos;begin!*&apos;();:@
            /// &amp;=+$,/?#[]end&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task StringUrlEncodedAsync( this IPaths operations, string stringPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.StringUrlEncodedWithOperationResponseAsync(stringPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringPath'>
            /// &apos;&apos; string value. Possible values for this parameter include:
            /// &apos;&apos;
            /// </param>
            public static void StringEmpty(this IPaths operations, string stringPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).StringEmptyAsync(stringPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringPath'>
            /// &apos;&apos; string value. Possible values for this parameter include:
            /// &apos;&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task StringEmptyAsync( this IPaths operations, string stringPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.StringEmptyWithOperationResponseAsync(stringPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null (should throw)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringPath'>
            /// null string value
            /// </param>
            public static void StringNull(this IPaths operations, string stringPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).StringNullAsync(stringPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null (should throw)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='stringPath'>
            /// null string value
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task StringNullAsync( this IPaths operations, string stringPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.StringNullWithOperationResponseAsync(stringPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get using uri with &apos;green color&apos; in path parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='enumPath'>
            /// send the value green. Possible values for this parameter include:
            /// &apos;red color&apos;, &apos;green color&apos;, &apos;blue color&apos;
            /// </param>
            public static void EnumValid(this IPaths operations, UriColor? enumPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).EnumValidAsync(enumPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get using uri with &apos;green color&apos; in path parameter
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='enumPath'>
            /// send the value green. Possible values for this parameter include:
            /// &apos;red color&apos;, &apos;green color&apos;, &apos;blue color&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task EnumValidAsync( this IPaths operations, UriColor? enumPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.EnumValidWithOperationResponseAsync(enumPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null (should throw on the client before the request is sent on wire)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='enumPath'>
            /// send null should throw. Possible values for this parameter include:
            /// &apos;red color&apos;, &apos;green color&apos;, &apos;blue color&apos;
            /// </param>
            public static void EnumNull(this IPaths operations, UriColor? enumPath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).EnumNullAsync(enumPath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null (should throw on the client before the request is sent on wire)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='enumPath'>
            /// send null should throw. Possible values for this parameter include:
            /// &apos;red color&apos;, &apos;green color&apos;, &apos;blue color&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task EnumNullAsync( this IPaths operations, UriColor? enumPath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.EnumNullWithOperationResponseAsync(enumPath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bytePath'>
            /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
            /// </param>
            public static void ByteMultiByte(this IPaths operations, byte[] bytePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).ByteMultiByteAsync(bytePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bytePath'>
            /// &apos;啊齄丂狛狜隣郎隣兀﨩&apos; multibyte value as utf-8 encoded byte array
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ByteMultiByteAsync( this IPaths operations, byte[] bytePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ByteMultiByteWithOperationResponseAsync(bytePath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;&apos; as byte array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bytePath'>
            /// &apos;&apos; as byte array
            /// </param>
            public static void ByteEmpty(this IPaths operations, byte[] bytePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).ByteEmptyAsync(bytePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;&apos; as byte array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bytePath'>
            /// &apos;&apos; as byte array
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ByteEmptyAsync( this IPaths operations, byte[] bytePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ByteEmptyWithOperationResponseAsync(bytePath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null as byte array (should throw)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bytePath'>
            /// null as byte array (should throw)
            /// </param>
            public static void ByteNull(this IPaths operations, byte[] bytePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).ByteNullAsync(bytePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null as byte array (should throw)
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bytePath'>
            /// null as byte array (should throw)
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ByteNullAsync( this IPaths operations, byte[] bytePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ByteNullWithOperationResponseAsync(bytePath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;2012-01-01&apos; as date
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datePath'>
            /// &apos;2012-01-01&apos; as date
            /// </param>
            public static void DateValid(this IPaths operations, DateTime? datePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).DateValidAsync(datePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;2012-01-01&apos; as date
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datePath'>
            /// &apos;2012-01-01&apos; as date
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DateValidAsync( this IPaths operations, DateTime? datePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DateValidWithOperationResponseAsync(datePath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null as date - this should throw or be unusable on the client side,
            /// depending on date representation
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datePath'>
            /// null as date (should throw)
            /// </param>
            public static void DateNull(this IPaths operations, DateTime? datePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).DateNullAsync(datePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null as date - this should throw or be unusable on the client side,
            /// depending on date representation
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='datePath'>
            /// null as date (should throw)
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DateNullAsync( this IPaths operations, DateTime? datePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DateNullWithOperationResponseAsync(datePath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get &apos;2012-01-01T01:01:01Z&apos; as date-time
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateTimePath'>
            /// &apos;2012-01-01T01:01:01Z&apos; as date-time
            /// </param>
            public static void DateTimeValid(this IPaths operations, DateTime? dateTimePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).DateTimeValidAsync(dateTimePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get &apos;2012-01-01T01:01:01Z&apos; as date-time
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateTimePath'>
            /// &apos;2012-01-01T01:01:01Z&apos; as date-time
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DateTimeValidAsync( this IPaths operations, DateTime? dateTimePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DateTimeValidWithOperationResponseAsync(dateTimePath, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get null as date-time, should be disallowed or throw depending on
            /// representation of date-time
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateTimePath'>
            /// null as date-time
            /// </param>
            public static void DateTimeNull(this IPaths operations, DateTime? dateTimePath)
            {
                Task.Factory.StartNew(s => ((IPaths)s).DateTimeNullAsync(dateTimePath), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null as date-time, should be disallowed or throw depending on
            /// representation of date-time
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='dateTimePath'>
            /// null as date-time
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DateTimeNullAsync( this IPaths operations, DateTime? dateTimePath, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DateTimeNullWithOperationResponseAsync(dateTimePath, cancellationToken).ConfigureAwait(false);
            }

    }
}
