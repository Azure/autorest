namespace Fixtures.Azure.SwaggerBatLro
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    /// <summary>
    /// Long-running Operation for AutoRest
    /// </summary>
    public partial interface ILROsOperations
    {
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Put200SucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPut200SucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Get200SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that does not contain
        /// ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Put200SucceededNoStateWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that does not contain
        /// ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPut200SucceededNoStateWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Get200SucceededNoStateWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 202 to the initial
        /// request, with a location header that points to a polling URL that
        /// returns a 200 and an entity that doesn't contains
        /// ProvisioningState
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Put202Retry200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 202 to the initial
        /// request, with a location header that points to a polling URL that
        /// returns a 200 and an entity that doesn't contains
        /// ProvisioningState
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPut202Retry200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Succeeded’.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetPut202Retry200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Put201CreatingSucceeded200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPut201CreatingSucceeded200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Get201CreatingSucceeded200PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Updating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Put200UpdatingSucceeded204WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Updating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPut200UpdatingSucceeded204WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Polling endpoinnt for Long running put request, service returns a
        /// 200
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Get200CreatingSucceeded200PollWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Created’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Failed’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Put201CreatingFailed200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Created’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Failed’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPut201CreatingFailed200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a ‘200’ with
        /// ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Get201CreatingFailed200PollingWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Put200Acceptedcanceled200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPut200Acceptedcanceled200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Polling endpoinnt for Long running put request, service returns a
        /// 200
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Get200Acceptedcanceled200PollWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> PutAsyncRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPutAsyncRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> PutAsyncNoRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPutAsyncNoRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncNoRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> PutAsyncRetryFailedWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPutAsyncRetryFailedWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncRetryFailedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> PutAsyncNoRetrycanceledWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPutAsyncNoRetrycanceledWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncNoRetrycanceledWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Accepted’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> DeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Accepted’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginDeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Failed’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> DeleteProvisioning202DeletingFailed200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Failed’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginDeleteProvisioning202DeletingFailed200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> DeleteProvisioning202Deletingcanceled200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Canceled’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginDeleteProvisioning202Deletingcanceled200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete succeeds and returns right away
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Delete204SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete succeeds and returns right away
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDelete204SucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Polls return this value until the last poll returns a
        /// ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Delete202Retry200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Polls return this value until the last poll returns a
        /// ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginDelete202Retry200WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Polls return this value until the last poll returns a
        /// ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Delete202NoRetry204WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Polls return this value until the last poll returns a
        /// ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginDelete202NoRetry204WithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncNoRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncNoRetrySucceededWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncRetryFailedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncRetryFailedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncRetrycanceledWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncRetrycanceledWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with 'Location' header. Poll returns a 200 with a
        /// response body after success.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Sku>> Post200WithPayloadWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with 'Location' header. Poll returns a 200 with a
        /// response body after success.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Sku>> BeginPost200WithPayloadWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with 'Location' and 'Retry-After' headers, Polls return
        /// a 200 with a response body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Post202Retry200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with 'Location' and 'Retry-After' headers, Polls return
        /// a 200 with a response body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginPost202Retry200WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with 'Location' header, 204 with noresponse body after
        /// success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Post202NoRetry204WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with 'Location' header, 204 with noresponse body after
        /// success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPost202NoRetry204WithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostAsyncRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginPostAsyncRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostAsyncNoRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginPostAsyncNoRetrySucceededWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostAsyncRetryFailedWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginPostAsyncRetryFailedWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostAsyncRetrycanceledWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginPostAsyncRetrycanceledWithOperationResponseAsync(Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));
    }
}
