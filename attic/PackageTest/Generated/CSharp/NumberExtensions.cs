namespace Fixtures.Bodynumber
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class NumberExtensions
    {
            /// <summary>
            /// Get null Number value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetNull(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null Number value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetNullAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetNullWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get invalid float Number value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetInvalidFloat(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetInvalidFloatAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get invalid float Number value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetInvalidFloatAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetInvalidFloatWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get invalid double Number value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetInvalidDouble(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetInvalidDoubleAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get invalid double Number value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetInvalidDoubleAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetInvalidDoubleWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put big float value 3.402823e+20
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            public static void PutBigFloat(this INumber operations, double? numberBody)
            {
                Task.Factory.StartNew(s => ((INumber)s).PutBigFloatAsync(numberBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put big float value 3.402823e+20
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutBigFloatAsync( this INumber operations, double? numberBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutBigFloatWithHttpMessagesAsync(numberBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get big float value 3.402823e+20
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetBigFloat(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetBigFloatAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get big float value 3.402823e+20
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetBigFloatAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetBigFloatWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put big double value 2.5976931e+101
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            public static void PutBigDouble(this INumber operations, double? numberBody)
            {
                Task.Factory.StartNew(s => ((INumber)s).PutBigDoubleAsync(numberBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put big double value 2.5976931e+101
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutBigDoubleAsync( this INumber operations, double? numberBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutBigDoubleWithHttpMessagesAsync(numberBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get big double value 2.5976931e+101
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetBigDouble(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetBigDoubleAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get big double value 2.5976931e+101
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetBigDoubleAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetBigDoubleWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put big double value 99999999.99
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            public static void PutBigDoublePositiveDecimal(this INumber operations, double? numberBody)
            {
                Task.Factory.StartNew(s => ((INumber)s).PutBigDoublePositiveDecimalAsync(numberBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put big double value 99999999.99
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutBigDoublePositiveDecimalAsync( this INumber operations, double? numberBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutBigDoublePositiveDecimalWithHttpMessagesAsync(numberBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get big double value 99999999.99
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetBigDoublePositiveDecimal(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetBigDoublePositiveDecimalAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get big double value 99999999.99
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetBigDoublePositiveDecimalAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetBigDoublePositiveDecimalWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put big double value -99999999.99
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            public static void PutBigDoubleNegativeDecimal(this INumber operations, double? numberBody)
            {
                Task.Factory.StartNew(s => ((INumber)s).PutBigDoubleNegativeDecimalAsync(numberBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put big double value -99999999.99
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutBigDoubleNegativeDecimalAsync( this INumber operations, double? numberBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutBigDoubleNegativeDecimalWithHttpMessagesAsync(numberBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get big double value -99999999.99
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetBigDoubleNegativeDecimal(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetBigDoubleNegativeDecimalAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get big double value -99999999.99
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetBigDoubleNegativeDecimalAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetBigDoubleNegativeDecimalWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put small float value 3.402823e-20
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            public static void PutSmallFloat(this INumber operations, double? numberBody)
            {
                Task.Factory.StartNew(s => ((INumber)s).PutSmallFloatAsync(numberBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put small float value 3.402823e-20
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutSmallFloatAsync( this INumber operations, double? numberBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutSmallFloatWithHttpMessagesAsync(numberBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get big double value 3.402823e-20
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetSmallFloat(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetSmallFloatAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get big double value 3.402823e-20
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetSmallFloatAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetSmallFloatWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put small double value 2.5976931e-101
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            public static void PutSmallDouble(this INumber operations, double? numberBody)
            {
                Task.Factory.StartNew(s => ((INumber)s).PutSmallDoubleAsync(numberBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put small double value 2.5976931e-101
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='numberBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutSmallDoubleAsync( this INumber operations, double? numberBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutSmallDoubleWithHttpMessagesAsync(numberBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get big double value 2.5976931e-101
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static double? GetSmallDouble(this INumber operations)
            {
                return Task.Factory.StartNew(s => ((INumber)s).GetSmallDoubleAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get big double value 2.5976931e-101
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<double?> GetSmallDoubleAsync( this INumber operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<double?> result = await operations.GetSmallDoubleWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
