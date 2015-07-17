namespace Fixtures.SwaggerBatBodyComplex
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
            /// Get complex types with dictionary property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static DictionaryWrapper GetValid(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetValidAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with dictionary property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DictionaryWrapper> GetValidAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DictionaryWrapper> result = await operations.GetValidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put complex types with dictionary property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put a dictionary with 5 key-value pairs: "txt":"notepad",
            /// "bmp":"mspaint", "xls":"excel", "exe":"", "":null
            /// </param>
            public static void PutValid(this IDictionary operations, DictionaryWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutValidAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with dictionary property
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put a dictionary with 5 key-value pairs: "txt":"notepad",
            /// "bmp":"mspaint", "xls":"excel", "exe":"", "":null
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutValidAsync( this IDictionary operations, DictionaryWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutValidWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with dictionary property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static DictionaryWrapper GetEmpty(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetEmptyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with dictionary property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DictionaryWrapper> GetEmptyAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DictionaryWrapper> result = await operations.GetEmptyWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Put complex types with dictionary property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put an empty dictionary
            /// </param>
            public static void PutEmpty(this IDictionary operations, DictionaryWrapper complexBody)
            {
                Task.Factory.StartNew(s => ((IDictionary)s).PutEmptyAsync(complexBody), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Put complex types with dictionary property which is empty
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='complexBody'>
            /// Please put an empty dictionary
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PutEmptyAsync( this IDictionary operations, DictionaryWrapper complexBody, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PutEmptyWithHttpMessagesAsync(complexBody, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get complex types with dictionary property which is null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static DictionaryWrapper GetNull(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetNullAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with dictionary property which is null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DictionaryWrapper> GetNullAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DictionaryWrapper> result = await operations.GetNullWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Get complex types with dictionary property while server doesn't provide a
            /// response payload
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static DictionaryWrapper GetNotProvided(this IDictionary operations)
            {
                return Task.Factory.StartNew(s => ((IDictionary)s).GetNotProvidedAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get complex types with dictionary property while server doesn't provide a
            /// response payload
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<DictionaryWrapper> GetNotProvidedAsync( this IDictionary operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<DictionaryWrapper> result = await operations.GetNotProvidedWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
