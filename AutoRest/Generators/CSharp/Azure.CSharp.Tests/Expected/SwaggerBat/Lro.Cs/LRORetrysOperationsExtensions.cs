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

    public static partial class LRORetrysOperationsExtensions
    {
            /// <summary>
            /// Long running put request, service returns a 500, then a 201 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product Put201CreatingSucceeded200(this ILRORetrysOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILRORetrysOperations)s).Put201CreatingSucceeded200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 201 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’.
            /// Polls return this value until the last poll returns a ‘200’ with
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
            public static async Task<Product> Put201CreatingSucceeded200Async( this ILRORetrysOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.Put201CreatingSucceeded200WithOperationResponseAsync(product, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 201 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’.
            /// Polls return this value until the last poll returns a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPut201CreatingSucceeded200(this ILRORetrysOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILRORetrysOperations)s).BeginPut201CreatingSucceeded200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 201 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’.
            /// Polls return this value until the last poll returns a ‘200’ with
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
            public static async Task<Product> BeginPut201CreatingSucceeded200Async( this ILRORetrysOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPut201CreatingSucceeded200WithOperationResponseAsync(product, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request poller, service returns a 500, then a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product GetRetry201CreatingSucceeded200Polling(this ILRORetrysOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILRORetrysOperations)s).GetRetry201CreatingSucceeded200PollingAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request poller, service returns a 500, then a ‘200’ with
            /// ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> GetRetry201CreatingSucceeded200PollingAsync( this ILRORetrysOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.GetRetry201CreatingSucceeded200PollingWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 200 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’. Poll
            /// the endpoint indicated in the Azure-AsyncOperation header for operation
            /// status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product PutAsyncRelativeRetrySucceeded(this ILRORetrysOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILRORetrysOperations)s).PutAsyncRelativeRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 200 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’. Poll
            /// the endpoint indicated in the Azure-AsyncOperation header for operation
            /// status
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
            public static async Task<Product> PutAsyncRelativeRetrySucceededAsync( this ILRORetrysOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.PutAsyncRelativeRetrySucceededWithOperationResponseAsync(product, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 200 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’. Poll
            /// the endpoint indicated in the Azure-AsyncOperation header for operation
            /// status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static Product BeginPutAsyncRelativeRetrySucceeded(this ILRORetrysOperations operations, Product product = default(Product))
            {
                return Task.Factory.StartNew(s => ((ILRORetrysOperations)s).BeginPutAsyncRelativeRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 200 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’. Poll
            /// the endpoint indicated in the Azure-AsyncOperation header for operation
            /// status
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
            public static async Task<Product> BeginPutAsyncRelativeRetrySucceededAsync( this ILRORetrysOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginPutAsyncRelativeRetrySucceededWithOperationResponseAsync(product, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 200 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’. Poll
            /// the endpoint indicated in the Azure-AsyncOperation header for operation
            /// status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product GetAsyncRelativeRetrySucceeded(this ILRORetrysOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILRORetrysOperations)s).GetAsyncRelativeRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running put request, service returns a 500, then a 200 to the initial
            /// request, with an entity that contains ProvisioningState=’Creating’. Poll
            /// the endpoint indicated in the Azure-AsyncOperation header for operation
            /// status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> GetAsyncRelativeRetrySucceededAsync( this ILRORetrysOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.GetAsyncRelativeRetrySucceededWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a  202 to the
            /// initial request, with an entity that contains
            /// ProvisioningState=’Accepted’.  Polls return this value until the last
            /// poll returns a ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product DeleteProvisioning202Accepted200Succeeded(this ILRORetrysOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILRORetrysOperations)s).DeleteProvisioning202Accepted200SucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a  202 to the
            /// initial request, with an entity that contains
            /// ProvisioningState=’Accepted’.  Polls return this value until the last
            /// poll returns a ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> DeleteProvisioning202Accepted200SucceededAsync( this ILRORetrysOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.DeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a  202 to the
            /// initial request, with an entity that contains
            /// ProvisioningState=’Accepted’.  Polls return this value until the last
            /// poll returns a ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static Product BeginDeleteProvisioning202Accepted200Succeeded(this ILRORetrysOperations operations)
            {
                return Task.Factory.StartNew(s => ((ILRORetrysOperations)s).BeginDeleteProvisioning202Accepted200SucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a  202 to the
            /// initial request, with an entity that contains
            /// ProvisioningState=’Accepted’.  Polls return this value until the last
            /// poll returns a ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Product> BeginDeleteProvisioning202Accepted200SucceededAsync( this ILRORetrysOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<Product> result = await operations.BeginDeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a 202 to the
            /// initial request. Polls return this value until the last poll returns a
            /// ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void Delete202Retry200(this ILRORetrysOperations operations)
            {
                Task.Factory.StartNew(s => ((ILRORetrysOperations)s).Delete202Retry200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a 202 to the
            /// initial request. Polls return this value until the last poll returns a
            /// ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task Delete202Retry200Async( this ILRORetrysOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Delete202Retry200WithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a 202 to the
            /// initial request. Polls return this value until the last poll returns a
            /// ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void BeginDelete202Retry200(this ILRORetrysOperations operations)
            {
                Task.Factory.StartNew(s => ((ILRORetrysOperations)s).BeginDelete202Retry200Async(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a 202 to the
            /// initial request. Polls return this value until the last poll returns a
            /// ‘200’ with ProvisioningState=’Succeeded’
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginDelete202Retry200Async( this ILRORetrysOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginDelete202Retry200WithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a 202 to the
            /// initial request. Poll the endpoint indicated in the Azure-AsyncOperation
            /// header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void DeleteAsyncRelativeRetrySucceeded(this ILRORetrysOperations operations)
            {
                Task.Factory.StartNew(s => ((ILRORetrysOperations)s).DeleteAsyncRelativeRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a 202 to the
            /// initial request. Poll the endpoint indicated in the Azure-AsyncOperation
            /// header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DeleteAsyncRelativeRetrySucceededAsync( this ILRORetrysOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DeleteAsyncRelativeRetrySucceededWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a 202 to the
            /// initial request. Poll the endpoint indicated in the Azure-AsyncOperation
            /// header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void BeginDeleteAsyncRelativeRetrySucceeded(this ILRORetrysOperations operations)
            {
                Task.Factory.StartNew(s => ((ILRORetrysOperations)s).BeginDeleteAsyncRelativeRetrySucceededAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running delete request, service returns a 500, then a 202 to the
            /// initial request. Poll the endpoint indicated in the Azure-AsyncOperation
            /// header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task BeginDeleteAsyncRelativeRetrySucceededAsync( this ILRORetrysOperations operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginDeleteAsyncRelativeRetrySucceededWithOperationResponseAsync(null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 500, then a 202 to the
            /// initial request, with 'Location' and 'Retry-After' headers, Polls return
            /// a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void Post202Retry200(this ILRORetrysOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILRORetrysOperations)s).Post202Retry200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 500, then a 202 to the
            /// initial request, with 'Location' and 'Retry-After' headers, Polls return
            /// a 200 with a response body after success
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
            public static async Task Post202Retry200Async( this ILRORetrysOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.Post202Retry200WithOperationResponseAsync(product, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 500, then a 202 to the
            /// initial request, with 'Location' and 'Retry-After' headers, Polls return
            /// a 200 with a response body after success
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void BeginPost202Retry200(this ILRORetrysOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILRORetrysOperations)s).BeginPost202Retry200Async(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 500, then a 202 to the
            /// initial request, with 'Location' and 'Retry-After' headers, Polls return
            /// a 200 with a response body after success
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
            public static async Task BeginPost202Retry200Async( this ILRORetrysOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginPost202Retry200WithOperationResponseAsync(product, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 500, then a 202 to the
            /// initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void PostAsyncRelativeRetrySucceeded(this ILRORetrysOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILRORetrysOperations)s).PostAsyncRelativeRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 500, then a 202 to the
            /// initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
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
            public static async Task PostAsyncRelativeRetrySucceededAsync( this ILRORetrysOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.PostAsyncRelativeRetrySucceededWithOperationResponseAsync(product, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Long running post request, service returns a 500, then a 202 to the
            /// initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='product'>
            /// Product to put
            /// </param>
            public static void BeginPostAsyncRelativeRetrySucceeded(this ILRORetrysOperations operations, Product product = default(Product))
            {
                Task.Factory.StartNew(s => ((ILRORetrysOperations)s).BeginPostAsyncRelativeRetrySucceededAsync(product), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Long running post request, service returns a 500, then a 202 to the
            /// initial request, with an entity that contains
            /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
            /// Azure-AsyncOperation header for operation status
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
            public static async Task BeginPostAsyncRelativeRetrySucceededAsync( this ILRORetrysOperations operations, Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.BeginPostAsyncRelativeRetrySucceededWithOperationResponseAsync(product, null, cancellationToken).ConfigureAwait(false);
            }

    }
}
