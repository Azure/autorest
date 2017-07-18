// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.Azure.AcceptanceTestsAzureSpecials
{
    using Fixtures.Azure;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for ApiVersionDefaultOperations.
    /// </summary>
    public static partial class ApiVersionDefaultOperationsExtensions
    {
            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static void GetMethodGlobalValid(this IApiVersionDefaultOperations operations)
            {
                operations.GetMethodGlobalValidAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task GetMethodGlobalValidAsync(this IApiVersionDefaultOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.GetMethodGlobalValidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static void GetMethodGlobalNotProvidedValid(this IApiVersionDefaultOperations operations)
            {
                operations.GetMethodGlobalNotProvidedValidAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task GetMethodGlobalNotProvidedValidAsync(this IApiVersionDefaultOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.GetMethodGlobalNotProvidedValidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static void GetPathGlobalValid(this IApiVersionDefaultOperations operations)
            {
                operations.GetPathGlobalValidAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task GetPathGlobalValidAsync(this IApiVersionDefaultOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.GetPathGlobalValidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static void GetSwaggerGlobalValid(this IApiVersionDefaultOperations operations)
            {
                operations.GetSwaggerGlobalValidAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// GET method with api-version modeled in global settings.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task GetSwaggerGlobalValidAsync(this IApiVersionDefaultOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.GetSwaggerGlobalValidWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

    }
}
