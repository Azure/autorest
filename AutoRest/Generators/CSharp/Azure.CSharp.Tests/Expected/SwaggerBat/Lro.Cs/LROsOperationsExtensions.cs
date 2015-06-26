namespace Fixtures.Azure.SwaggerBatLro
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    public static partial class LROsOperationsExtensions
    {
            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Put200Succeeded(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Put200SucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Put200SucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Put200SucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPut200Succeeded(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPut200SucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPut200SucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPut200SucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product Get200Succeeded(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Get200SucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Get200SucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Get200SucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that does not contain ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Put200SucceededNoState(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Put200SucceededNoStateAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that does not contain ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Put200SucceededNoStateAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Put200SucceededNoStateWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that does not contain ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPut200SucceededNoState(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPut200SucceededNoStateAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that does not contain ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPut200SucceededNoStateAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPut200SucceededNoStateWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product Get200SucceededNoState(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Get200SucceededNoStateAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Get200SucceededNoStateAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Get200SucceededNoStateWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 202 to the initial request,
            /// with a location header that points to a polling URL that returns a 200
            /// and an entity that doesn&apos;t contains ProvisioningState
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Put202Retry200(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Put202Retry200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 202 to the initial request,
            /// with a location header that points to a polling URL that returns a 200
            /// and an entity that doesn&apos;t contains ProvisioningState
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Put202Retry200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Put202Retry200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 202 to the initial request,
            /// with a location header that points to a polling URL that returns a 200
            /// and an entity that doesn&apos;t contains ProvisioningState
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPut202Retry200(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPut202Retry200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 202 to the initial request,
            /// with a location header that points to a polling URL that returns a 200
            /// and an entity that doesn&apos;t contains ProvisioningState
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPut202Retry200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPut202Retry200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product GetPut202Retry200(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).GetPut202Retry200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Succeeded’.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> GetPut202Retry200Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.GetPut202Retry200WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Put201CreatingSucceeded200(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Put201CreatingSucceeded200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Put201CreatingSucceeded200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Put201CreatingSucceeded200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPut201CreatingSucceeded200(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPut201CreatingSucceeded200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPut201CreatingSucceeded200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPut201CreatingSucceeded200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request poller, service returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product Get201CreatingSucceeded200Polling(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Get201CreatingSucceeded200PollingAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request poller, service returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Get201CreatingSucceeded200PollingAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Get201CreatingSucceeded200PollingWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Updating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Put200UpdatingSucceeded204(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Put200UpdatingSucceeded204Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Updating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Put200UpdatingSucceeded204Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Put200UpdatingSucceeded204WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Updating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPut200UpdatingSucceeded204(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPut200UpdatingSucceeded204Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Updating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPut200UpdatingSucceeded204Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPut200UpdatingSucceeded204WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Polling endpoinnt for Long running put request, service returns a 200
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product Get200CreatingSucceeded200Poll(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Get200CreatingSucceeded200PollAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Polling endpoinnt for Long running put request, service returns a 200
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Get200CreatingSucceeded200PollAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Get200CreatingSucceeded200PollWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Created’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Failed’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Put201CreatingFailed200(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Put201CreatingFailed200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Created’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Failed’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Put201CreatingFailed200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Put201CreatingFailed200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Created’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Failed’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPut201CreatingFailed200(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPut201CreatingFailed200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Created’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Failed’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPut201CreatingFailed200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPut201CreatingFailed200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request poller, service returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product Get201CreatingFailed200Polling(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Get201CreatingFailed200PollingAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request poller, service returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Get201CreatingFailed200PollingAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Get201CreatingFailed200PollingWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Canceled’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Put200Acceptedcanceled200(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Put200Acceptedcanceled200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Canceled’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Put200Acceptedcanceled200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Put200Acceptedcanceled200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Canceled’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPut200Acceptedcanceled200(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPut200Acceptedcanceled200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 201 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Canceled’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPut200Acceptedcanceled200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPut200Acceptedcanceled200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Polling endpoinnt for Long running put request, service returns a 200
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product Get200Acceptedcanceled200Poll(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Get200Acceptedcanceled200PollAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Polling endpoinnt for Long running put request, service returns a 200
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Get200Acceptedcanceled200PollAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Get200Acceptedcanceled200PollWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product PutAsyncRetrySucceeded(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).PutAsyncRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> PutAsyncRetrySucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.PutAsyncRetrySucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPutAsyncRetrySucceeded(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPutAsyncRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPutAsyncRetrySucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPutAsyncRetrySucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product GetAsyncRetrySucceeded(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).GetAsyncRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> GetAsyncRetrySucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.GetAsyncRetrySucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product PutAsyncNoRetrySucceeded(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).PutAsyncNoRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> PutAsyncNoRetrySucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.PutAsyncNoRetrySucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPutAsyncNoRetrySucceeded(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPutAsyncNoRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPutAsyncNoRetrySucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPutAsyncNoRetrySucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product GetAsyncNoRetrySucceeded(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).GetAsyncNoRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> GetAsyncNoRetrySucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.GetAsyncNoRetrySucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product PutAsyncRetryFailed(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).PutAsyncRetryFailedAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> PutAsyncRetryFailedAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.PutAsyncRetryFailedWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPutAsyncRetryFailed(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPutAsyncRetryFailedAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPutAsyncRetryFailedAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPutAsyncRetryFailedWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product GetAsyncRetryFailed(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).GetAsyncRetryFailedAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> GetAsyncRetryFailedAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.GetAsyncRetryFailedWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product PutAsyncNoRetrycanceled(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).PutAsyncNoRetrycanceledAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> PutAsyncNoRetrycanceledAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.PutAsyncNoRetrycanceledWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPutAsyncNoRetrycanceled(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPutAsyncNoRetrycanceledAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPutAsyncNoRetrycanceledAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPutAsyncNoRetrycanceledWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product GetAsyncNoRetrycanceled(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).GetAsyncNoRetrycanceledAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 200 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> GetAsyncNoRetrycanceledAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.GetAsyncNoRetrycanceledWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Accepted’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product DeleteProvisioning202Accepted200Succeeded(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).DeleteProvisioning202Accepted200SucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Accepted’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> DeleteProvisioning202Accepted200SucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.DeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Accepted’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product BeginDeleteProvisioning202Accepted200Succeeded(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDeleteProvisioning202Accepted200SucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Accepted’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginDeleteProvisioning202Accepted200SucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginDeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Failed’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product DeleteProvisioning202DeletingFailed200(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).DeleteProvisioning202DeletingFailed200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Failed’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> DeleteProvisioning202DeletingFailed200Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.DeleteProvisioning202DeletingFailed200WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Failed’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product BeginDeleteProvisioning202DeletingFailed200(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDeleteProvisioning202DeletingFailed200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Failed’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginDeleteProvisioning202DeletingFailed200Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginDeleteProvisioning202DeletingFailed200WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Canceled’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product DeleteProvisioning202Deletingcanceled200(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).DeleteProvisioning202Deletingcanceled200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Canceled’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> DeleteProvisioning202Deletingcanceled200Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.DeleteProvisioning202Deletingcanceled200WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Canceled’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product BeginDeleteProvisioning202Deletingcanceled200(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDeleteProvisioning202Deletingcanceled200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’.  Polls return
            /// this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Canceled’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginDeleteProvisioning202Deletingcanceled200Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginDeleteProvisioning202Deletingcanceled200WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete succeeds and returns right away
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void Delete204Succeeded(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).Delete204SucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete succeeds and returns right away
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task Delete204SucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Delete204SucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete succeeds and returns right away
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void BeginDelete204Succeeded(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDelete204SucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete succeeds and returns right away
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginDelete204SucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginDelete204SucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product Delete202Retry200(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Delete202Retry200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Delete202Retry200Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Delete202Retry200WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product BeginDelete202Retry200(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDelete202Retry200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginDelete202Retry200Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginDelete202Retry200WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product Delete202NoRetry204(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Delete202NoRetry204Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Delete202NoRetry204Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Delete202NoRetry204WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product BeginDelete202NoRetry204(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDelete202NoRetry204Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginDelete202NoRetry204Async( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginDelete202NoRetry204WithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void DeleteAsyncRetrySucceeded(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).DeleteAsyncRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DeleteAsyncRetrySucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DeleteAsyncRetrySucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void BeginDeleteAsyncRetrySucceeded(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDeleteAsyncRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginDeleteAsyncRetrySucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginDeleteAsyncRetrySucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void DeleteAsyncNoRetrySucceeded(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).DeleteAsyncNoRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DeleteAsyncNoRetrySucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DeleteAsyncNoRetrySucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void BeginDeleteAsyncNoRetrySucceeded(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDeleteAsyncNoRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginDeleteAsyncNoRetrySucceededAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginDeleteAsyncNoRetrySucceededWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void DeleteAsyncRetryFailed(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).DeleteAsyncRetryFailedAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DeleteAsyncRetryFailedAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DeleteAsyncRetryFailedWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void BeginDeleteAsyncRetryFailed(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDeleteAsyncRetryFailedAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginDeleteAsyncRetryFailedAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginDeleteAsyncRetryFailedWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void DeleteAsyncRetrycanceled(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).DeleteAsyncRetrycanceledAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DeleteAsyncRetrycanceledAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DeleteAsyncRetrycanceledWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void BeginDeleteAsyncRetrycanceled(this ILROsOperations operations)
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginDeleteAsyncRetrycanceledAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 202 to the initial request.
            /// Poll the endpoint indicated in the Azure-AsyncOperation header for
            /// operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginDeleteAsyncRetrycanceledAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginDeleteAsyncRetrycanceledWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; header. Poll returns a 200 with a response body
            /// after success.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Sku Post200WithPayload(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Post200WithPayloadAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; header. Poll returns a 200 with a response body
            /// after success.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Sku> Post200WithPayloadAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Sku> result = await operations.Post200WithPayloadWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; header. Poll returns a 200 with a response body
            /// after success.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Sku BeginPost200WithPayload(this ILROsOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPost200WithPayloadAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; header. Poll returns a 200 with a response body
            /// after success.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Sku> BeginPost200WithPayloadAsync( this ILROsOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Sku> result = await operations.BeginPost200WithPayloadWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; and &apos;Retry-After&apos; headers, Polls
            /// return a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void Post202Retry200(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).Post202Retry200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; and &apos;Retry-After&apos; headers, Polls
            /// return a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task Post202Retry200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Post202Retry200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; and &apos;Retry-After&apos; headers, Polls
            /// return a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void BeginPost202Retry200(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPost202Retry200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; and &apos;Retry-After&apos; headers, Polls
            /// return a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginPost202Retry200Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginPost202Retry200WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; header, 204 with noresponse body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Post202NoRetry204(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).Post202NoRetry204Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; header, 204 with noresponse body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> Post202NoRetry204Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Post202NoRetry204WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; header, 204 with noresponse body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPost202NoRetry204(this ILROsOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPost202NoRetry204Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with &apos;Location&apos; header, 204 with noresponse body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginPost202NoRetry204Async( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPost202NoRetry204WithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void PostAsyncRetrySucceeded(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).PostAsyncRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostAsyncRetrySucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostAsyncRetrySucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void BeginPostAsyncRetrySucceeded(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPostAsyncRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginPostAsyncRetrySucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginPostAsyncRetrySucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void PostAsyncNoRetrySucceeded(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).PostAsyncNoRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostAsyncNoRetrySucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostAsyncNoRetrySucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void BeginPostAsyncNoRetrySucceeded(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPostAsyncNoRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginPostAsyncNoRetrySucceededAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginPostAsyncNoRetrySucceededWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void PostAsyncRetryFailed(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).PostAsyncRetryFailedAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostAsyncRetryFailedAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostAsyncRetryFailedWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void BeginPostAsyncRetryFailed(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPostAsyncRetryFailedAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginPostAsyncRetryFailedAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginPostAsyncRetryFailedWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void PostAsyncRetrycanceled(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).PostAsyncRetrycanceledAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task PostAsyncRetrycanceledAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostAsyncRetrycanceledWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void BeginPostAsyncRetrycanceled(this ILROsOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILROsOperations)s).BeginPostAsyncRetrycanceledAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 202 to the initial request,
            /// with an entity that contains ProvisioningState=’Creating’. Poll the
            /// endpoint indicated in the Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginPostAsyncRetrycanceledAsync( this ILROsOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginPostAsyncRetrycanceledWithOperationResponseAsync(product, cancellationToken).ConfigureAwait(false);
            }

    }
}
