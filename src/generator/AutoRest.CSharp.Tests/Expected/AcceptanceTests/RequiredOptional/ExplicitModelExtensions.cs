// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.AcceptanceTestsRequiredOptional
{
    using Models;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for ExplicitModel.
    /// </summary>
    public static partial class ExplicitModelExtensions
    {
            /// <summary>
            /// Test explicitly required integer. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredIntegerParameter(this IExplicitModel operations, int bodyParameter)
            {
                return operations.PostRequiredIntegerParameterAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required integer. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredIntegerParameterAsync(this IExplicitModel operations, int bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredIntegerParameterWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional integer. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalIntegerParameter(this IExplicitModel operations, int? bodyParameter = default(int?))
            {
                operations.PostOptionalIntegerParameterAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalIntegerParameterAsync(this IExplicitModel operations, int? bodyParameter = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalIntegerParameterWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required integer. Please put a valid int-wrapper with
            /// 'value' = null and the client library should throw before the request is
            /// sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            public static Error PostRequiredIntegerProperty(this IExplicitModel operations, int value)
            {
                return operations.PostRequiredIntegerPropertyAsync(value).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required integer. Please put a valid int-wrapper with
            /// 'value' = null and the client library should throw before the request is
            /// sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredIntegerPropertyAsync(this IExplicitModel operations, int value, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredIntegerPropertyWithHttpMessagesAsync(value, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a valid int-wrapper with
            /// 'value' = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            public static void PostOptionalIntegerProperty(this IExplicitModel operations, int? value = default(int?))
            {
                operations.PostOptionalIntegerPropertyAsync(value).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a valid int-wrapper with
            /// 'value' = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalIntegerPropertyAsync(this IExplicitModel operations, int? value = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalIntegerPropertyWithHttpMessagesAsync(value, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required integer. Please put a header 'headerParameter'
            /// =&gt; null and the client library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static Error PostRequiredIntegerHeader(this IExplicitModel operations, int headerParameter)
            {
                return operations.PostRequiredIntegerHeaderAsync(headerParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required integer. Please put a header 'headerParameter'
            /// =&gt; null and the client library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredIntegerHeaderAsync(this IExplicitModel operations, int headerParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredIntegerHeaderWithHttpMessagesAsync(headerParameter, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a header 'headerParameter'
            /// =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static void PostOptionalIntegerHeader(this IExplicitModel operations, int? headerParameter = default(int?))
            {
                operations.PostOptionalIntegerHeaderAsync(headerParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a header 'headerParameter'
            /// =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalIntegerHeaderAsync(this IExplicitModel operations, int? headerParameter = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalIntegerHeaderWithHttpMessagesAsync(headerParameter, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required string. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredStringParameter(this IExplicitModel operations, string bodyParameter)
            {
                return operations.PostRequiredStringParameterAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required string. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredStringParameterAsync(this IExplicitModel operations, string bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredStringParameterWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional string. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalStringParameter(this IExplicitModel operations, string bodyParameter = default(string))
            {
                operations.PostOptionalStringParameterAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional string. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalStringParameterAsync(this IExplicitModel operations, string bodyParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalStringParameterWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required string. Please put a valid string-wrapper with
            /// 'value' = null and the client library should throw before the request is
            /// sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            public static Error PostRequiredStringProperty(this IExplicitModel operations, string value)
            {
                return operations.PostRequiredStringPropertyAsync(value).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required string. Please put a valid string-wrapper with
            /// 'value' = null and the client library should throw before the request is
            /// sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredStringPropertyAsync(this IExplicitModel operations, string value, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredStringPropertyWithHttpMessagesAsync(value, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a valid string-wrapper with
            /// 'value' = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            public static void PostOptionalStringProperty(this IExplicitModel operations, string value = default(string))
            {
                operations.PostOptionalStringPropertyAsync(value).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a valid string-wrapper with
            /// 'value' = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalStringPropertyAsync(this IExplicitModel operations, string value = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalStringPropertyWithHttpMessagesAsync(value, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required string. Please put a header 'headerParameter'
            /// =&gt; null and the client library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static Error PostRequiredStringHeader(this IExplicitModel operations, string headerParameter)
            {
                return operations.PostRequiredStringHeaderAsync(headerParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required string. Please put a header 'headerParameter'
            /// =&gt; null and the client library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredStringHeaderAsync(this IExplicitModel operations, string headerParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredStringHeaderWithHttpMessagesAsync(headerParameter, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional string. Please put a header 'headerParameter'
            /// =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalStringHeader(this IExplicitModel operations, string bodyParameter = default(string))
            {
                operations.PostOptionalStringHeaderAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional string. Please put a header 'headerParameter'
            /// =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalStringHeaderAsync(this IExplicitModel operations, string bodyParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalStringHeaderWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required complex object. Please put null and the client
            /// library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredClassParameter(this IExplicitModel operations, Product bodyParameter)
            {
                return operations.PostRequiredClassParameterAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required complex object. Please put null and the client
            /// library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredClassParameterAsync(this IExplicitModel operations, Product bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredClassParameterWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional complex object. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalClassParameter(this IExplicitModel operations, Product bodyParameter = default(Product))
            {
                operations.PostOptionalClassParameterAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional complex object. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalClassParameterAsync(this IExplicitModel operations, Product bodyParameter = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalClassParameterWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required complex object. Please put a valid class-wrapper
            /// with 'value' = null and the client library should throw before the request
            /// is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            public static Error PostRequiredClassProperty(this IExplicitModel operations, Product value)
            {
                return operations.PostRequiredClassPropertyAsync(value).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required complex object. Please put a valid class-wrapper
            /// with 'value' = null and the client library should throw before the request
            /// is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredClassPropertyAsync(this IExplicitModel operations, Product value, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredClassPropertyWithHttpMessagesAsync(value, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional complex object. Please put a valid class-wrapper
            /// with 'value' = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            public static void PostOptionalClassProperty(this IExplicitModel operations, Product value = default(Product))
            {
                operations.PostOptionalClassPropertyAsync(value).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional complex object. Please put a valid class-wrapper
            /// with 'value' = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalClassPropertyAsync(this IExplicitModel operations, Product value = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalClassPropertyWithHttpMessagesAsync(value, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required array. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredArrayParameter(this IExplicitModel operations, IList<string> bodyParameter)
            {
                return operations.PostRequiredArrayParameterAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required array. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredArrayParameterAsync(this IExplicitModel operations, IList<string> bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredArrayParameterWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional array. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalArrayParameter(this IExplicitModel operations, IList<string> bodyParameter = default(IList<string>))
            {
                operations.PostOptionalArrayParameterAsync(bodyParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional array. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalArrayParameterAsync(this IExplicitModel operations, IList<string> bodyParameter = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalArrayParameterWithHttpMessagesAsync(bodyParameter, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required array. Please put a valid array-wrapper with
            /// 'value' = null and the client library should throw before the request is
            /// sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            public static Error PostRequiredArrayProperty(this IExplicitModel operations, IList<string> value)
            {
                return operations.PostRequiredArrayPropertyAsync(value).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required array. Please put a valid array-wrapper with
            /// 'value' = null and the client library should throw before the request is
            /// sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredArrayPropertyAsync(this IExplicitModel operations, IList<string> value, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredArrayPropertyWithHttpMessagesAsync(value, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional array. Please put a valid array-wrapper with
            /// 'value' = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            public static void PostOptionalArrayProperty(this IExplicitModel operations, IList<string> value = default(IList<string>))
            {
                operations.PostOptionalArrayPropertyAsync(value).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional array. Please put a valid array-wrapper with
            /// 'value' = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='value'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalArrayPropertyAsync(this IExplicitModel operations, IList<string> value = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalArrayPropertyWithHttpMessagesAsync(value, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Test explicitly required array. Please put a header 'headerParameter' =&gt;
            /// null and the client library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static Error PostRequiredArrayHeader(this IExplicitModel operations, IList<string> headerParameter)
            {
                return operations.PostRequiredArrayHeaderAsync(headerParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required array. Please put a header 'headerParameter' =&gt;
            /// null and the client library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredArrayHeaderAsync(this IExplicitModel operations, IList<string> headerParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.PostRequiredArrayHeaderWithHttpMessagesAsync(headerParameter, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a header 'headerParameter'
            /// =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static void PostOptionalArrayHeader(this IExplicitModel operations, IList<string> headerParameter = default(IList<string>))
            {
                operations.PostOptionalArrayHeaderAsync(headerParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a header 'headerParameter'
            /// =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task PostOptionalArrayHeaderAsync(this IExplicitModel operations, IList<string> headerParameter = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.PostOptionalArrayHeaderWithHttpMessagesAsync(headerParameter, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

    }
}
