namespace Fixtures.SwaggerBatBodyDictionary
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class DictionaryExtensions
    {
            /// <summary>
            /// Get null dictionary value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, int?> GetNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get null dictionary value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, int?>> GetNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, int?>> result = await operations.GetNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get empty dictionary value {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, int?> GetEmpty(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get empty dictionary value {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, int?>> GetEmptyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, int?>> result = await operations.GetEmptyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value empty {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutEmpty(this IDictionary operations, IDictionary<string, string> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutEmptyAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value empty {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutEmptyAsync( this IDictionary operations, IDictionary<string, string> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutEmptyWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get Dictionary with null value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, string> GetNullValue(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetNullValueAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get Dictionary with null value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, string>> GetNullValueAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, string>> result = await operations.GetNullValueWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get Dictionary with null key
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, string> GetNullKey(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetNullKeyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get Dictionary with null key
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, string>> GetNullKeyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, string>> result = await operations.GetNullKeyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get Dictionary with key as empty string
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, string> GetEmptyStringKey(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetEmptyStringKeyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get Dictionary with key as empty string
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, string>> GetEmptyStringKeyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, string>> result = await operations.GetEmptyStringKeyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get invalid Dictionary value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, string> GetInvalid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetInvalidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get invalid Dictionary value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, string>> GetInvalidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, string>> result = await operations.GetInvalidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get boolean dictionary value {"0": true, "1": false, "2": false, "3": true
            /// }
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, bool?> GetBooleanTfft(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetBooleanTfftAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get boolean dictionary value {"0": true, "1": false, "2": false, "3": true
            /// }
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, bool?>> GetBooleanTfftAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, bool?>> result = await operations.GetBooleanTfftWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value empty {"0": true, "1": false, "2": false, "3": true }
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutBooleanTfft(this IDictionary operations, IDictionary<string, bool?> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutBooleanTfftAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value empty {"0": true, "1": false, "2": false, "3": true }
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutBooleanTfftAsync( this IDictionary operations, IDictionary<string, bool?> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutBooleanTfftWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get boolean dictionary value {"0": true, "1": null, "2": false }
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, bool?> GetBooleanInvalidNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetBooleanInvalidNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get boolean dictionary value {"0": true, "1": null, "2": false }
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, bool?>> GetBooleanInvalidNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, bool?>> result = await operations.GetBooleanInvalidNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get boolean dictionary value '{"0": true, "1": "boolean", "2": false}'
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, bool?> GetBooleanInvalidString(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetBooleanInvalidStringAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get boolean dictionary value '{"0": true, "1": "boolean", "2": false}'
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, bool?>> GetBooleanInvalidStringAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, bool?>> result = await operations.GetBooleanInvalidStringWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get integer dictionary value {"0": 1, "1": -1, "2": 3, "3": 300}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, int?> GetIntegerValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetIntegerValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get integer dictionary value {"0": 1, "1": -1, "2": 3, "3": 300}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, int?>> GetIntegerValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, int?>> result = await operations.GetIntegerValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value empty {"0": 1, "1": -1, "2": 3, "3": 300}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutIntegerValid(this IDictionary operations, IDictionary<string, int?> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutIntegerValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value empty {"0": 1, "1": -1, "2": 3, "3": 300}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutIntegerValidAsync( this IDictionary operations, IDictionary<string, int?> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutIntegerValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get integer dictionary value {"0": 1, "1": null, "2": 0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, int?> GetIntInvalidNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetIntInvalidNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get integer dictionary value {"0": 1, "1": null, "2": 0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, int?>> GetIntInvalidNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, int?>> result = await operations.GetIntInvalidNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get integer dictionary value {"0": 1, "1": "integer", "2": 0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, int?> GetIntInvalidString(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetIntInvalidStringAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get integer dictionary value {"0": 1, "1": "integer", "2": 0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, int?>> GetIntInvalidStringAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, int?>> result = await operations.GetIntInvalidStringWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get integer dictionary value {"0": 1, "1": -1, "2": 3, "3": 300}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, long?> GetLongValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetLongValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get integer dictionary value {"0": 1, "1": -1, "2": 3, "3": 300}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, long?>> GetLongValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, long?>> result = await operations.GetLongValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value empty {"0": 1, "1": -1, "2": 3, "3": 300}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutLongValid(this IDictionary operations, IDictionary<string, long?> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutLongValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value empty {"0": 1, "1": -1, "2": 3, "3": 300}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutLongValidAsync( this IDictionary operations, IDictionary<string, long?> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutLongValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get long dictionary value {"0": 1, "1": null, "2": 0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, long?> GetLongInvalidNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetLongInvalidNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get long dictionary value {"0": 1, "1": null, "2": 0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, long?>> GetLongInvalidNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, long?>> result = await operations.GetLongInvalidNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get long dictionary value {"0": 1, "1": "integer", "2": 0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, long?> GetLongInvalidString(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetLongInvalidStringAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get long dictionary value {"0": 1, "1": "integer", "2": 0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, long?>> GetLongInvalidStringAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, long?>> result = await operations.GetLongInvalidStringWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get float dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, double?> GetFloatValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetFloatValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get float dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, double?>> GetFloatValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, double?>> result = await operations.GetFloatValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutFloatValid(this IDictionary operations, IDictionary<string, double?> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutFloatValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutFloatValidAsync( this IDictionary operations, IDictionary<string, double?> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutFloatValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get float dictionary value {"0": 0.0, "1": null, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, double?> GetFloatInvalidNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetFloatInvalidNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get float dictionary value {"0": 0.0, "1": null, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, double?>> GetFloatInvalidNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, double?>> result = await operations.GetFloatInvalidNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get boolean dictionary value {"0": 1.0, "1": "number", "2": 0.0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, double?> GetFloatInvalidString(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetFloatInvalidStringAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get boolean dictionary value {"0": 1.0, "1": "number", "2": 0.0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, double?>> GetFloatInvalidStringAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, double?>> result = await operations.GetFloatInvalidStringWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get float dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, double?> GetDoubleValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDoubleValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get float dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, double?>> GetDoubleValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, double?>> result = await operations.GetDoubleValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutDoubleValid(this IDictionary operations, IDictionary<string, double?> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutDoubleValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value {"0": 0, "1": -0.01, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutDoubleValidAsync( this IDictionary operations, IDictionary<string, double?> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDoubleValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get float dictionary value {"0": 0.0, "1": null, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, double?> GetDoubleInvalidNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDoubleInvalidNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get float dictionary value {"0": 0.0, "1": null, "2": 1.2e20}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, double?>> GetDoubleInvalidNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, double?>> result = await operations.GetDoubleInvalidNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get boolean dictionary value {"0": 1.0, "1": "number", "2": 0.0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, double?> GetDoubleInvalidString(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDoubleInvalidStringAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get boolean dictionary value {"0": 1.0, "1": "number", "2": 0.0}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, double?>> GetDoubleInvalidStringAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, double?>> result = await operations.GetDoubleInvalidStringWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get string dictionary value {"0": "foo1", "1": "foo2", "2": "foo3"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, string> GetStringValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetStringValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get string dictionary value {"0": "foo1", "1": "foo2", "2": "foo3"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, string>> GetStringValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, string>> result = await operations.GetStringValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value {"0": "foo1", "1": "foo2", "2": "foo3"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutStringValid(this IDictionary operations, IDictionary<string, string> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutStringValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value {"0": "foo1", "1": "foo2", "2": "foo3"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutStringValidAsync( this IDictionary operations, IDictionary<string, string> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutStringValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get string dictionary value {"0": "foo", "1": null, "2": "foo2"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, string> GetStringWithNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetStringWithNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get string dictionary value {"0": "foo", "1": null, "2": "foo2"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, string>> GetStringWithNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, string>> result = await operations.GetStringWithNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get string dictionary value {"0": "foo", "1": 123, "2": "foo2"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, string> GetStringWithInvalid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetStringWithInvalidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get string dictionary value {"0": "foo", "1": 123, "2": "foo2"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, string>> GetStringWithInvalidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, string>> result = await operations.GetStringWithInvalidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get integer dictionary value {"0": "2000-12-01", "1": "1980-01-02", "2":
            /// "1492-10-12"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, DateTime?> GetDateValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDateValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get integer dictionary value {"0": "2000-12-01", "1": "1980-01-02", "2":
            /// "1492-10-12"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, DateTime?>> GetDateValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, DateTime?>> result = await operations.GetDateValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value  {"0": "2000-12-01", "1": "1980-01-02", "2":
            /// "1492-10-12"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutDateValid(this IDictionary operations, IDictionary<string, DateTime?> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutDateValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value  {"0": "2000-12-01", "1": "1980-01-02", "2":
            /// "1492-10-12"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutDateValidAsync( this IDictionary operations, IDictionary<string, DateTime?> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDateValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get date dictionary value {"0": "2012-01-01", "1": null, "2": "1776-07-04"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, DateTime?> GetDateInvalidNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDateInvalidNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get date dictionary value {"0": "2012-01-01", "1": null, "2": "1776-07-04"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, DateTime?>> GetDateInvalidNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, DateTime?>> result = await operations.GetDateInvalidNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get date dictionary value {"0": "2011-03-22", "1": "date"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, DateTime?> GetDateInvalidChars(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDateInvalidCharsAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get date dictionary value {"0": "2011-03-22", "1": "date"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, DateTime?>> GetDateInvalidCharsAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, DateTime?>> result = await operations.GetDateInvalidCharsWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get date-time dictionary value {"0": "2000-12-01t00:00:01z", "1":
            /// "1980-01-02T00:11:35+01:00", "2": "1492-10-12T10:15:01-08:00"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, DateTime?> GetDateTimeValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDateTimeValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get date-time dictionary value {"0": "2000-12-01t00:00:01z", "1":
            /// "1980-01-02T00:11:35+01:00", "2": "1492-10-12T10:15:01-08:00"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, DateTime?>> GetDateTimeValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, DateTime?>> result = await operations.GetDateTimeValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Set dictionary value  {"0": "2000-12-01t00:00:01z", "1":
            /// "1980-01-02T00:11:35+01:00", "2": "1492-10-12T10:15:01-08:00"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutDateTimeValid(this IDictionary operations, IDictionary<string, DateTime?> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutDateTimeValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Set dictionary value  {"0": "2000-12-01t00:00:01z", "1":
            /// "1980-01-02T00:11:35+01:00", "2": "1492-10-12T10:15:01-08:00"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutDateTimeValidAsync( this IDictionary operations, IDictionary<string, DateTime?> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDateTimeValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get date dictionary value {"0": "2000-12-01t00:00:01z", "1": null}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, DateTime?> GetDateTimeInvalidNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDateTimeInvalidNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get date dictionary value {"0": "2000-12-01t00:00:01z", "1": null}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, DateTime?>> GetDateTimeInvalidNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, DateTime?>> result = await operations.GetDateTimeInvalidNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get date dictionary value {"0": "2000-12-01t00:00:01z", "1": "date-time"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, DateTime?> GetDateTimeInvalidChars(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDateTimeInvalidCharsAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get date dictionary value {"0": "2000-12-01t00:00:01z", "1": "date-time"}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, DateTime?>> GetDateTimeInvalidCharsAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, DateTime?>> result = await operations.GetDateTimeInvalidCharsWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get byte dictionary value {"0": hex(FF FF FF FA), "1": hex(01 02 03), "2":
            /// hex (25, 29, 43)} with each item encoded in base64
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, byte[]> GetByteValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetByteValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get byte dictionary value {"0": hex(FF FF FF FA), "1": hex(01 02 03), "2":
            /// hex (25, 29, 43)} with each item encoded in base64
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, byte[]>> GetByteValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, byte[]>> result = await operations.GetByteValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put the dictionary value {"0": hex(FF FF FF FA), "1": hex(01 02 03), "2":
            /// hex (25, 29, 43)} with each elementencoded in base 64
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutByteValid(this IDictionary operations, IDictionary<string, byte[]> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutByteValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put the dictionary value {"0": hex(FF FF FF FA), "1": hex(01 02 03), "2":
            /// hex (25, 29, 43)} with each elementencoded in base 64
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutByteValidAsync( this IDictionary operations, IDictionary<string, byte[]> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutByteValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get byte dictionary value {"0": hex(FF FF FF FA), "1": null} with the
            /// first item base64 encoded
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, byte[]> GetByteInvalidNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetByteInvalidNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get byte dictionary value {"0": hex(FF FF FF FA), "1": null} with the
            /// first item base64 encoded
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, byte[]>> GetByteInvalidNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, byte[]>> result = await operations.GetByteInvalidNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get dictionary of complex type null value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, Widget> GetComplexNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetComplexNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get dictionary of complex type null value
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, Widget>> GetComplexNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, Widget>> result = await operations.GetComplexNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get empty dictionary of complex type {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, Widget> GetComplexEmpty(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetComplexEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get empty dictionary of complex type {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, Widget>> GetComplexEmptyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, Widget>> result = await operations.GetComplexEmptyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get dictionary of complex type with null item {"0": {"integer": 1,
            /// "string": "2"}, "1": null, "2": {"integer": 5, "string": "6"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, Widget> GetComplexItemNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetComplexItemNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get dictionary of complex type with null item {"0": {"integer": 1,
            /// "string": "2"}, "1": null, "2": {"integer": 5, "string": "6"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, Widget>> GetComplexItemNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, Widget>> result = await operations.GetComplexItemNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get dictionary of complex type with empty item {"0": {"integer": 1,
            /// "string": "2"}, "1:" {}, "2": {"integer": 5, "string": "6"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, Widget> GetComplexItemEmpty(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetComplexItemEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get dictionary of complex type with empty item {"0": {"integer": 1,
            /// "string": "2"}, "1:" {}, "2": {"integer": 5, "string": "6"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, Widget>> GetComplexItemEmptyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, Widget>> result = await operations.GetComplexItemEmptyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get dictionary of complex type with {"0": {"integer": 1, "string": "2"},
            /// "1": {"integer": 3, "string": "4"}, "2": {"integer": 5, "string": "6"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, Widget> GetComplexValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetComplexValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get dictionary of complex type with {"0": {"integer": 1, "string": "2"},
            /// "1": {"integer": 3, "string": "4"}, "2": {"integer": 5, "string": "6"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, Widget>> GetComplexValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, Widget>> result = await operations.GetComplexValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put an dictionary of complex type with values {"0": {"integer": 1,
            /// "string": "2"}, "1": {"integer": 3, "string": "4"}, "2": {"integer": 5,
            /// "string": "6"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutComplexValid(this IDictionary operations, IDictionary<string, Widget> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutComplexValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put an dictionary of complex type with values {"0": {"integer": 1,
            /// "string": "2"}, "1": {"integer": 3, "string": "4"}, "2": {"integer": 5,
            /// "string": "6"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutComplexValidAsync( this IDictionary operations, IDictionary<string, Widget> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutComplexValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a null array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IList<string>> GetArrayNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetArrayNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a null array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IList<string>>> GetArrayNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IList<string>>> result = await operations.GetArrayNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an empty dictionary {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IList<string>> GetArrayEmpty(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetArrayEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an empty dictionary {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IList<string>>> GetArrayEmptyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IList<string>>> result = await operations.GetArrayEmptyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an dictionary of array of strings {"0": ["1", "2", "3"], "1": null,
            /// "2": ["7", "8", "9"]}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IList<string>> GetArrayItemNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetArrayItemNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an dictionary of array of strings {"0": ["1", "2", "3"], "1": null,
            /// "2": ["7", "8", "9"]}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IList<string>>> GetArrayItemNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IList<string>>> result = await operations.GetArrayItemNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an array of array of strings [{"0": ["1", "2", "3"], "1": [], "2":
            /// ["7", "8", "9"]}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IList<string>> GetArrayItemEmpty(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetArrayItemEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an array of array of strings [{"0": ["1", "2", "3"], "1": [], "2":
            /// ["7", "8", "9"]}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IList<string>>> GetArrayItemEmptyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IList<string>>> result = await operations.GetArrayItemEmptyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an array of array of strings {"0": ["1", "2", "3"], "1": ["4", "5",
            /// "6"], "2": ["7", "8", "9"]}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IList<string>> GetArrayValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetArrayValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an array of array of strings {"0": ["1", "2", "3"], "1": ["4", "5",
            /// "6"], "2": ["7", "8", "9"]}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IList<string>>> GetArrayValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IList<string>>> result = await operations.GetArrayValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put An array of array of strings {"0": ["1", "2", "3"], "1": ["4", "5",
            /// "6"], "2": ["7", "8", "9"]}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutArrayValid(this IDictionary operations, IDictionary<string, IList<string>> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutArrayValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put An array of array of strings {"0": ["1", "2", "3"], "1": ["4", "5",
            /// "6"], "2": ["7", "8", "9"]}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutArrayValidAsync( this IDictionary operations, IDictionary<string, IList<string>> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutArrayValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get an dictionaries of dictionaries with value null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IDictionary<string, string>> GetDictionaryNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDictionaryNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an dictionaries of dictionaries with value null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IDictionary<string, string>>> GetDictionaryNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IDictionary<string, string>>> result = await operations.GetDictionaryNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IDictionary<string, string>> GetDictionaryEmpty(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDictionaryEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IDictionary<string, string>>> GetDictionaryEmptyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IDictionary<string, string>>> result = await operations.GetDictionaryEmptyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {"0": {"1": "one", "2": "two", "3": "three"}, "1": null, "2": {"7":
            /// "seven", "8": "eight", "9": "nine"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IDictionary<string, string>> GetDictionaryItemNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDictionaryItemNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {"0": {"1": "one", "2": "two", "3": "three"}, "1": null, "2": {"7":
            /// "seven", "8": "eight", "9": "nine"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IDictionary<string, string>>> GetDictionaryItemNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IDictionary<string, string>>> result = await operations.GetDictionaryItemNullWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {"0": {"1": "one", "2": "two", "3": "three"}, "1": {}, "2": {"7":
            /// "seven", "8": "eight", "9": "nine"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IDictionary<string, string>> GetDictionaryItemEmpty(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDictionaryItemEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {"0": {"1": "one", "2": "two", "3": "three"}, "1": {}, "2": {"7":
            /// "seven", "8": "eight", "9": "nine"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IDictionary<string, string>>> GetDictionaryItemEmptyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IDictionary<string, string>>> result = await operations.GetDictionaryItemEmptyWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {"0": {"1": "one", "2": "two", "3": "three"}, "1": {"4": "four",
            /// "5": "five", "6": "six"}, "2": {"7": "seven", "8": "eight", "9": "nine"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, IDictionary<string, string>> GetDictionaryValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetDictionaryValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {"0": {"1": "one", "2": "two", "3": "three"}, "1": {"4": "four",
            /// "5": "five", "6": "six"}, "2": {"7": "seven", "8": "eight", "9": "nine"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, IDictionary<string, string>>> GetDictionaryValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, IDictionary<string, string>>> result = await operations.GetDictionaryValidWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {"0": {"1": "one", "2": "two", "3": "three"}, "1": {"4": "four",
            /// "5": "five", "6": "six"}, "2": {"7": "seven", "8": "eight", "9": "nine"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            public static void PutDictionaryValid(this IDictionary operations, IDictionary<string, IDictionary<string, string>> arrayBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutDictionaryValidAsync(arrayBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get an dictionaries of dictionaries of type &lt;string, string&gt; with
            /// value {"0": {"1": "one", "2": "two", "3": "three"}, "1": {"4": "four",
            /// "5": "five", "6": "six"}, "2": {"7": "seven", "8": "eight", "9": "nine"}}
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='arrayBody'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutDictionaryValidAsync( this IDictionary operations, IDictionary<string, IDictionary<string, string>> arrayBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutDictionaryValidWithOperationResponseAsync(arrayBody, null, cancellationToken).ConfigureAwait(false);
            }

    }
}
