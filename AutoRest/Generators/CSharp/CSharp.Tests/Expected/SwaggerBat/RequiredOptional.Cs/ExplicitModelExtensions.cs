namespace Fixtures.SwaggerBatRequiredOptional
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class ExplicitModelExtensions
    {
            /// <summary>
            /// Test explicitly required integer. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredIntegerParameter(this IExplicitModel operations, int? bodyParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredIntegerParameterAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required integer. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredIntegerParameterAsync( this IExplicitModel operations, int? bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredIntegerParameterWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional integer. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalIntegerParameter(this IExplicitModel operations, int? bodyParameter = default(int?))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalIntegerParameterAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalIntegerParameterAsync( this IExplicitModel operations, int? bodyParameter = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalIntegerParameterWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required integer. Please put a valid int-wrapper with
            /// &apos;value&apos; = null and the client library should throw before the
            /// request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredIntegerProperty(this IExplicitModel operations, IntWrapper bodyParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredIntegerPropertyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required integer. Please put a valid int-wrapper with
            /// &apos;value&apos; = null and the client library should throw before the
            /// request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredIntegerPropertyAsync( this IExplicitModel operations, IntWrapper bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredIntegerPropertyWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a valid int-wrapper with
            /// &apos;value&apos; = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalIntegerProperty(this IExplicitModel operations, IntOptionalWrapper bodyParameter = default(IntOptionalWrapper))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalIntegerPropertyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a valid int-wrapper with
            /// &apos;value&apos; = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalIntegerPropertyAsync( this IExplicitModel operations, IntOptionalWrapper bodyParameter = default(IntOptionalWrapper), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalIntegerPropertyWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required integer. Please put a header
            /// &apos;headerParameter&apos; =&gt; null and the client library should
            /// throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static Error PostRequiredIntegerHeader(this IExplicitModel operations, int? headerParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredIntegerHeaderAsync(headerParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required integer. Please put a header
            /// &apos;headerParameter&apos; =&gt; null and the client library should
            /// throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredIntegerHeaderAsync( this IExplicitModel operations, int? headerParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredIntegerHeaderWithOperationResponseAsync(headerParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a header
            /// &apos;headerParameter&apos; =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static void PostOptionalIntegerHeader(this IExplicitModel operations, int? headerParameter = default(int?))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalIntegerHeaderAsync(headerParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a header
            /// &apos;headerParameter&apos; =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalIntegerHeaderAsync( this IExplicitModel operations, int? headerParameter = default(int?), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalIntegerHeaderWithOperationResponseAsync(headerParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required string. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredStringParameter(this IExplicitModel operations, string bodyParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredStringParameterAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required string. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredStringParameterAsync( this IExplicitModel operations, string bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredStringParameterWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional string. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalStringParameter(this IExplicitModel operations, string bodyParameter = default(string))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalStringParameterAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional string. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalStringParameterAsync( this IExplicitModel operations, string bodyParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalStringParameterWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required string. Please put a valid string-wrapper with
            /// &apos;value&apos; = null and the client library should throw before the
            /// request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredStringProperty(this IExplicitModel operations, StringWrapper bodyParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredStringPropertyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required string. Please put a valid string-wrapper with
            /// &apos;value&apos; = null and the client library should throw before the
            /// request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredStringPropertyAsync( this IExplicitModel operations, StringWrapper bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredStringPropertyWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a valid string-wrapper with
            /// &apos;value&apos; = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalStringProperty(this IExplicitModel operations, StringOptionalWrapper bodyParameter = default(StringOptionalWrapper))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalStringPropertyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a valid string-wrapper with
            /// &apos;value&apos; = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalStringPropertyAsync( this IExplicitModel operations, StringOptionalWrapper bodyParameter = default(StringOptionalWrapper), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalStringPropertyWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required string. Please put a header
            /// &apos;headerParameter&apos; =&gt; null and the client library should
            /// throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static Error PostRequiredStringHeader(this IExplicitModel operations, string headerParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredStringHeaderAsync(headerParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required string. Please put a header
            /// &apos;headerParameter&apos; =&gt; null and the client library should
            /// throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredStringHeaderAsync( this IExplicitModel operations, string headerParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredStringHeaderWithOperationResponseAsync(headerParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional string. Please put a header
            /// &apos;headerParameter&apos; =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalStringHeader(this IExplicitModel operations, string bodyParameter = default(string))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalStringHeaderAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional string. Please put a header
            /// &apos;headerParameter&apos; =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalStringHeaderAsync( this IExplicitModel operations, string bodyParameter = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalStringHeaderWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required complex object. Please put null and the client
            /// library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredClassParameter(this IExplicitModel operations, Product bodyParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredClassParameterAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required complex object. Please put null and the client
            /// library should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredClassParameterAsync( this IExplicitModel operations, Product bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredClassParameterWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional complex object. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalClassParameter(this IExplicitModel operations, Product bodyParameter = default(Product))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalClassParameterAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional complex object. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalClassParameterAsync( this IExplicitModel operations, Product bodyParameter = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalClassParameterWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required complex object. Please put a valid class-wrapper
            /// with &apos;value&apos; = null and the client library should throw before
            /// the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredClassProperty(this IExplicitModel operations, ClassWrapper bodyParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredClassPropertyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required complex object. Please put a valid class-wrapper
            /// with &apos;value&apos; = null and the client library should throw before
            /// the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredClassPropertyAsync( this IExplicitModel operations, ClassWrapper bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredClassPropertyWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional complex object. Please put a valid class-wrapper
            /// with &apos;value&apos; = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalClassProperty(this IExplicitModel operations, ClassOptionalWrapper bodyParameter = default(ClassOptionalWrapper))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalClassPropertyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional complex object. Please put a valid class-wrapper
            /// with &apos;value&apos; = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalClassPropertyAsync( this IExplicitModel operations, ClassOptionalWrapper bodyParameter = default(ClassOptionalWrapper), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalClassPropertyWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required array. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredArrayParameter(this IExplicitModel operations, IList<string> bodyParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredArrayParameterAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required array. Please put null and the client library
            /// should throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredArrayParameterAsync( this IExplicitModel operations, IList<string> bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredArrayParameterWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional array. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalArrayParameter(this IExplicitModel operations, IList<string> bodyParameter = default(IList<string>))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalArrayParameterAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional array. Please put null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalArrayParameterAsync( this IExplicitModel operations, IList<string> bodyParameter = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalArrayParameterWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required array. Please put a valid array-wrapper with
            /// &apos;value&apos; = null and the client library should throw before the
            /// request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static Error PostRequiredArrayProperty(this IExplicitModel operations, ArrayWrapper bodyParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredArrayPropertyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required array. Please put a valid array-wrapper with
            /// &apos;value&apos; = null and the client library should throw before the
            /// request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredArrayPropertyAsync( this IExplicitModel operations, ArrayWrapper bodyParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredArrayPropertyWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional array. Please put a valid array-wrapper with
            /// &apos;value&apos; = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            public static void PostOptionalArrayProperty(this IExplicitModel operations, ArrayOptionalWrapper bodyParameter = default(ArrayOptionalWrapper))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalArrayPropertyAsync(bodyParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional array. Please put a valid array-wrapper with
            /// &apos;value&apos; = null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='bodyParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalArrayPropertyAsync( this IExplicitModel operations, ArrayOptionalWrapper bodyParameter = default(ArrayOptionalWrapper), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalArrayPropertyWithOperationResponseAsync(bodyParameter, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Test explicitly required array. Please put a header
            /// &apos;headerParameter&apos; =&gt; null and the client library should
            /// throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static Error PostRequiredArrayHeader(this IExplicitModel operations, IList<string> headerParameter)
            {
                return Task.Factory.StartNew(s => ((IExplicitModel)s).PostRequiredArrayHeaderAsync(headerParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly required array. Please put a header
            /// &apos;headerParameter&apos; =&gt; null and the client library should
            /// throw before the request is sent.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Error> PostRequiredArrayHeaderAsync( this IExplicitModel operations, IList<string> headerParameter, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Error> result = await operations.PostRequiredArrayHeaderWithOperationResponseAsync(headerParameter, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a header
            /// &apos;headerParameter&apos; =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            public static void PostOptionalArrayHeader(this IExplicitModel operations, IList<string> headerParameter = default(IList<string>))
            {
                Task.Factory.StartNew(s => ((IExplicitModel)s).PostOptionalArrayHeaderAsync(headerParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Test explicitly optional integer. Please put a header
            /// &apos;headerParameter&apos; =&gt; null.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='headerParameter'>
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostOptionalArrayHeaderAsync( this IExplicitModel operations, IList<string> headerParameter = default(IList<string>), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostOptionalArrayHeaderWithOperationResponseAsync(headerParameter, cancellationToken).ConfigureAwait(false);
            }

    }
}
