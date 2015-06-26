namespace Fixtures.Azure.SwaggerBatAzureSpecials
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    public static partial class SkipUrlEncodingOperationsExtensions
    {
            /// <summary>
            /// Get method with unencoded path parameter with value
            /// &apos;path1/path2/path3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='unencodedPathParam'>
            /// Unencoded path parameter with value &apos;path1/path2/path3&apos;
            /// </param>
            public static void GetMethodPathValid(this ISkipUrlEncodingOperations operations, string unencodedPathParam)
            {
                Task.Factory.StartNew(s => ((ISkipUrlEncodingOperations)s).GetMethodPathValidAsync(unencodedPathParam), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get method with unencoded path parameter with value
            /// &apos;path1/path2/path3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='unencodedPathParam'>
            /// Unencoded path parameter with value &apos;path1/path2/path3&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetMethodPathValidAsync( this ISkipUrlEncodingOperations operations, string unencodedPathParam, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetMethodPathValidWithOperationResponseAsync(unencodedPathParam, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get method with unencoded path parameter with value
            /// &apos;path1/path2/path3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='unencodedPathParam'>
            /// Unencoded path parameter with value &apos;path1/path2/path3&apos;
            /// </param>
            public static void GetPathPathValid(this ISkipUrlEncodingOperations operations, string unencodedPathParam)
            {
                Task.Factory.StartNew(s => ((ISkipUrlEncodingOperations)s).GetPathPathValidAsync(unencodedPathParam), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get method with unencoded path parameter with value
            /// &apos;path1/path2/path3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='unencodedPathParam'>
            /// Unencoded path parameter with value &apos;path1/path2/path3&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetPathPathValidAsync( this ISkipUrlEncodingOperations operations, string unencodedPathParam, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetPathPathValidWithOperationResponseAsync(unencodedPathParam, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get method with unencoded path parameter with value
            /// &apos;path1/path2/path3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='unencodedPathParam'>
            /// An unencoded path parameter with value &apos;path1/path2/path3&apos;.
            /// Possible values for this parameter include: &apos;path1/path2/path3&apos;
            /// </param>
            public static void GetSwaggerPathValid(this ISkipUrlEncodingOperations operations, string unencodedPathParam)
            {
                Task.Factory.StartNew(s => ((ISkipUrlEncodingOperations)s).GetSwaggerPathValidAsync(unencodedPathParam), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get method with unencoded path parameter with value
            /// &apos;path1/path2/path3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='unencodedPathParam'>
            /// An unencoded path parameter with value &apos;path1/path2/path3&apos;.
            /// Possible values for this parameter include: &apos;path1/path2/path3&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetSwaggerPathValidAsync( this ISkipUrlEncodingOperations operations, string unencodedPathParam, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetSwaggerPathValidWithOperationResponseAsync(unencodedPathParam, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get method with unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='q1'>
            /// Unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </param>
            public static void GetMethodQueryValid(this ISkipUrlEncodingOperations operations, string q1)
            {
                Task.Factory.StartNew(s => ((ISkipUrlEncodingOperations)s).GetMethodQueryValidAsync(q1), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get method with unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='q1'>
            /// Unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetMethodQueryValidAsync( this ISkipUrlEncodingOperations operations, string q1, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetMethodQueryValidWithOperationResponseAsync(q1, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get method with unencoded query parameter with value null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='q1'>
            /// Unencoded query parameter with value null
            /// </param>
            public static void GetMethodQueryNull(this ISkipUrlEncodingOperations operations, string q1 = default(string))
            {
                Task.Factory.StartNew(s => ((ISkipUrlEncodingOperations)s).GetMethodQueryNullAsync(q1), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get method with unencoded query parameter with value null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='q1'>
            /// Unencoded query parameter with value null
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetMethodQueryNullAsync( this ISkipUrlEncodingOperations operations, string q1 = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetMethodQueryNullWithOperationResponseAsync(q1, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get method with unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='q1'>
            /// Unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </param>
            public static void GetPathQueryValid(this ISkipUrlEncodingOperations operations, string q1)
            {
                Task.Factory.StartNew(s => ((ISkipUrlEncodingOperations)s).GetPathQueryValidAsync(q1), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get method with unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='q1'>
            /// Unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetPathQueryValidAsync( this ISkipUrlEncodingOperations operations, string q1, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetPathQueryValidWithOperationResponseAsync(q1, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get method with unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='q1'>
            /// An unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;. Possible values for this
            /// parameter include: &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </param>
            public static void GetSwaggerQueryValid(this ISkipUrlEncodingOperations operations, string q1 = default(string))
            {
                Task.Factory.StartNew(s => ((ISkipUrlEncodingOperations)s).GetSwaggerQueryValidAsync(q1), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get method with unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='q1'>
            /// An unencoded query parameter with value
            /// &apos;value1&amp;q2=value2&amp;q3=value3&apos;. Possible values for this
            /// parameter include: &apos;value1&amp;q2=value2&amp;q3=value3&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task GetSwaggerQueryValidAsync( this ISkipUrlEncodingOperations operations, string q1 = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.GetSwaggerQueryValidWithOperationResponseAsync(q1, cancellationToken).ConfigureAwait(false);
            }

    }
}
