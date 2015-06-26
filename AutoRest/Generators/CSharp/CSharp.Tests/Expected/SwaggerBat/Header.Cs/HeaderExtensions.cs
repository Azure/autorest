namespace Fixtures.SwaggerBatHeader
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class HeaderExtensions
    {
            /// <summary>
            /// Send a post request with header value &quot;User-Agent&quot;:
            /// &quot;overwrite&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='userAgent'>
            /// Send a post request with header value &quot;User-Agent&quot;:
            /// &quot;overwrite&quot;
            /// </param>
            public static void ParamExistingKey(this IHeader operations, string userAgent)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamExistingKeyAsync(userAgent), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header value &quot;User-Agent&quot;:
            /// &quot;overwrite&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='userAgent'>
            /// Send a post request with header value &quot;User-Agent&quot;:
            /// &quot;overwrite&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamExistingKeyAsync( this IHeader operations, string userAgent, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamExistingKeyWithOperationResponseAsync(userAgent, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header value &quot;User-Agent&quot;:
            /// &quot;overwrite&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void ResponseExistingKey(this IHeader operations)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseExistingKeyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header value &quot;User-Agent&quot;:
            /// &quot;overwrite&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseExistingKeyAsync( this IHeader operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseExistingKeyWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header value &quot;Content-Type&quot;:
            /// &quot;text/html&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='contentType'>
            /// Send a post request with header value &quot;Content-Type&quot;:
            /// &quot;text/html&quot;
            /// </param>
            public static void ParamProtectedKey(this IHeader operations, string contentType)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamProtectedKeyAsync(contentType), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header value &quot;Content-Type&quot;:
            /// &quot;text/html&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='contentType'>
            /// Send a post request with header value &quot;Content-Type&quot;:
            /// &quot;text/html&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamProtectedKeyAsync( this IHeader operations, string contentType, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamProtectedKeyWithOperationResponseAsync(contentType, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header value &quot;Content-Type&quot;:
            /// &quot;text/html&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void ResponseProtectedKey(this IHeader operations)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseProtectedKeyAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header value &quot;Content-Type&quot;:
            /// &quot;text/html&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseProtectedKeyAsync( this IHeader operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseProtectedKeyWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot;, &quot;value&quot;: 1 or &quot;scenario&quot;:
            /// &quot;negative&quot;, &quot;value&quot;: -2
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values 1 or -2
            /// </param>
            public static void ParamInteger(this IHeader operations, string scenario, int? value)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamIntegerAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot;, &quot;value&quot;: 1 or &quot;scenario&quot;:
            /// &quot;negative&quot;, &quot;value&quot;: -2
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values 1 or -2
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamIntegerAsync( this IHeader operations, string scenario, int? value, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamIntegerWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: 1 or -2
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            public static void ResponseInteger(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseIntegerAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: 1 or -2
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseIntegerAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseIntegerWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot;, &quot;value&quot;: 105 or &quot;scenario&quot;:
            /// &quot;negative&quot;, &quot;value&quot;: -2
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values 105 or -2
            /// </param>
            public static void ParamLong(this IHeader operations, string scenario, long? value)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamLongAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot;, &quot;value&quot;: 105 or &quot;scenario&quot;:
            /// &quot;negative&quot;, &quot;value&quot;: -2
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values 105 or -2
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamLongAsync( this IHeader operations, string scenario, long? value, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamLongWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: 105 or -2
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            public static void ResponseLong(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseLongAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: 105 or -2
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseLongAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseLongWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot;, &quot;value&quot;: 0.07 or &quot;scenario&quot;:
            /// &quot;negative&quot;, &quot;value&quot;: -3.0
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values 0.07 or -3.0
            /// </param>
            public static void ParamFloat(this IHeader operations, string scenario, double? value)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamFloatAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot;, &quot;value&quot;: 0.07 or &quot;scenario&quot;:
            /// &quot;negative&quot;, &quot;value&quot;: -3.0
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values 0.07 or -3.0
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamFloatAsync( this IHeader operations, string scenario, double? value, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamFloatWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: 0.07 or -3.0
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            public static void ResponseFloat(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseFloatAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: 0.07 or -3.0
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseFloatAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseFloatWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot;, &quot;value&quot;: 7e120 or &quot;scenario&quot;:
            /// &quot;negative&quot;, &quot;value&quot;: -3.0
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values 7e120 or -3.0
            /// </param>
            public static void ParamDouble(this IHeader operations, string scenario, double? value)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamDoubleAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot;, &quot;value&quot;: 7e120 or &quot;scenario&quot;:
            /// &quot;negative&quot;, &quot;value&quot;: -3.0
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values 7e120 or -3.0
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamDoubleAsync( this IHeader operations, string scenario, double? value, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamDoubleWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: 7e120 or -3.0
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            public static void ResponseDouble(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseDoubleAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: 7e120 or -3.0
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;positive&quot; or &quot;negative&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseDoubleAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseDoubleWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;true&quot;, &quot;value&quot;: true or &quot;scenario&quot;:
            /// &quot;false&quot;, &quot;value&quot;: false
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;true&quot; or &quot;false&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values true or false
            /// </param>
            public static void ParamBool(this IHeader operations, string scenario, bool? value)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamBoolAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;true&quot;, &quot;value&quot;: true or &quot;scenario&quot;:
            /// &quot;false&quot;, &quot;value&quot;: false
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;true&quot; or &quot;false&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values true or false
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamBoolAsync( this IHeader operations, string scenario, bool? value, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamBoolWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: true or false
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;true&quot; or &quot;false&quot;
            /// </param>
            public static void ResponseBool(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseBoolAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header value &quot;value&quot;: true or false
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;true&quot; or &quot;false&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseBoolAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseBoolWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;The quick brown fox jumps
            /// over the lazy dog&quot; or &quot;scenario&quot;: &quot;null&quot;,
            /// &quot;value&quot;: null or &quot;scenario&quot;: &quot;empty&quot;,
            /// &quot;value&quot;: &quot;&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &quot;The quick brown fox jumps
            /// over the lazy dog&quot; or null or &quot;&quot;
            /// </param>
            public static void ParamString(this IHeader operations, string scenario, string value = default(string))
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamStringAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;The quick brown fox jumps
            /// over the lazy dog&quot; or &quot;scenario&quot;: &quot;null&quot;,
            /// &quot;value&quot;: null or &quot;scenario&quot;: &quot;empty&quot;,
            /// &quot;value&quot;: &quot;&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &quot;The quick brown fox jumps
            /// over the lazy dog&quot; or null or &quot;&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamStringAsync( this IHeader operations, string scenario, string value = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamStringWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header values &quot;The quick brown fox jumps over the
            /// lazy dog&quot; or null or &quot;&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
            /// </param>
            public static void ResponseString(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseStringAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header values &quot;The quick brown fox jumps over the
            /// lazy dog&quot; or null or &quot;&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseStringAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseStringWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;2010-01-01&quot; or
            /// &quot;scenario&quot;: &quot;min&quot;, &quot;value&quot;:
            /// &quot;0001-01-01&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;min&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &quot;2010-01-01&quot; or
            /// &quot;0001-01-01&quot;
            /// </param>
            public static void ParamDate(this IHeader operations, string scenario, DateTime? value)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamDateAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;2010-01-01&quot; or
            /// &quot;scenario&quot;: &quot;min&quot;, &quot;value&quot;:
            /// &quot;0001-01-01&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;min&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &quot;2010-01-01&quot; or
            /// &quot;0001-01-01&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamDateAsync( this IHeader operations, string scenario, DateTime? value, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamDateWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header values &quot;2010-01-01&quot; or
            /// &quot;0001-01-01&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;min&quot;
            /// </param>
            public static void ResponseDate(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseDateAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header values &quot;2010-01-01&quot; or
            /// &quot;0001-01-01&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;min&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseDateAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseDateWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;2010-01-01T12:34:56Z&quot; or
            /// &quot;scenario&quot;: &quot;min&quot;, &quot;value&quot;:
            /// &quot;0001-01-01T00:00:00Z&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;min&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &quot;2010-01-01T12:34:56Z&quot; or
            /// &quot;0001-01-01T00:00:00Z&quot;
            /// </param>
            public static void ParamDatetime(this IHeader operations, string scenario, DateTime? value)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamDatetimeAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;2010-01-01T12:34:56Z&quot; or
            /// &quot;scenario&quot;: &quot;min&quot;, &quot;value&quot;:
            /// &quot;0001-01-01T00:00:00Z&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;min&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &quot;2010-01-01T12:34:56Z&quot; or
            /// &quot;0001-01-01T00:00:00Z&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamDatetimeAsync( this IHeader operations, string scenario, DateTime? value, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamDatetimeWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header values &quot;2010-01-01T12:34:56Z&quot; or
            /// &quot;0001-01-01T00:00:00Z&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;min&quot;
            /// </param>
            public static void ResponseDatetime(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseDatetimeAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header values &quot;2010-01-01T12:34:56Z&quot; or
            /// &quot;0001-01-01T00:00:00Z&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;min&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseDatetimeAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseDatetimeWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
            /// </param>
            public static void ParamByte(this IHeader operations, string scenario, byte[] value)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamByteAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamByteAsync( this IHeader operations, string scenario, byte[] value, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamByteWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header values &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;
            /// </param>
            public static void ResponseByte(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseByteAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header values &quot;啊齄丂狛狜隣郎隣兀﨩&quot;
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseByteAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseByteWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;GREY&quot; or
            /// &quot;scenario&quot;: &quot;null&quot;, &quot;value&quot;: null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &apos;GREY&apos; . Possible values
            /// for this parameter include: &apos;White&apos;, &apos;black&apos;,
            /// &apos;GREY&apos;
            /// </param>
            public static void ParamEnum(this IHeader operations, string scenario, GreyscaleColors? value = default(GreyscaleColors?))
            {
                Task.Factory.StartNew(s => ((IHeader)s).ParamEnumAsync(scenario, value), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot;, &quot;value&quot;: &quot;GREY&quot; or
            /// &quot;scenario&quot;: &quot;null&quot;, &quot;value&quot;: null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
            /// </param>
            /// <param name='value'>
            /// Send a post request with header values &apos;GREY&apos; . Possible values
            /// for this parameter include: &apos;White&apos;, &apos;black&apos;,
            /// &apos;GREY&apos;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ParamEnumAsync( this IHeader operations, string scenario, GreyscaleColors? value = default(GreyscaleColors?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ParamEnumWithOperationResponseAsync(scenario, value, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get a response with header values &quot;GREY&quot; or null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
            /// </param>
            public static void ResponseEnum(this IHeader operations, string scenario)
            {
                Task.Factory.StartNew(s => ((IHeader)s).ResponseEnumAsync(scenario), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a response with header values &quot;GREY&quot; or null
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='scenario'>
            /// Send a post request with header values &quot;scenario&quot;:
            /// &quot;valid&quot; or &quot;null&quot; or &quot;empty&quot;
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task ResponseEnumAsync( this IHeader operations, string scenario, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.ResponseEnumWithOperationResponseAsync(scenario, cancellationToken).ConfigureAwait(false);
            }

    }
}
