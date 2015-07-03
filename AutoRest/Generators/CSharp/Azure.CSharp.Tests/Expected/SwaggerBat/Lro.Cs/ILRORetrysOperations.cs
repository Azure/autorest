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
    public partial interface ILRORetrysOperations
    {
        /// <summary>
        /// Long running put request, service returns a 500, then a 201 to the
        /// initial request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Put201CreatingSucceeded200WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 500, then a 201 to the
        /// initial request, with an entity that contains
        /// ProvisioningState=’Creating’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPut201CreatingSucceeded200WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request poller, service returns a 500, then a
        /// ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetRetry201CreatingSucceeded200PollingWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 500, then a 200 to the
        /// initial request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> PutAsyncRelativeRetrySucceededWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 500, then a 200 to the
        /// initial request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginPutAsyncRelativeRetrySucceededWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 500, then a 200 to the
        /// initial request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncRelativeRetrySucceededWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 500, then a  202 to
        /// the initial request, with an entity that contains
        /// ProvisioningState=’Accepted’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> DeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 500, then a  202 to
        /// the initial request, with an entity that contains
        /// ProvisioningState=’Accepted’.  Polls return this value until the
        /// last poll returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> BeginDeleteProvisioning202Accepted200SucceededWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 500, then a 202 to
        /// the initial request. Polls return this value until the last poll
        /// returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Delete202Retry200WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 500, then a 202 to
        /// the initial request. Polls return this value until the last poll
        /// returns a ‘200’ with ProvisioningState=’Succeeded’
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDelete202Retry200WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 500, then a 202 to
        /// the initial request. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncRelativeRetrySucceededWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 500, then a 202 to
        /// the initial request. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncRelativeRetrySucceededWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 500, then a 202 to
        /// the initial request, with 'Location' and 'Retry-After' headers,
        /// Polls return a 200 with a response body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Post202Retry200WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 500, then a 202 to
        /// the initial request, with 'Location' and 'Retry-After' headers,
        /// Polls return a 200 with a response body after success
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginPost202Retry200WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 500, then a 202 to
        /// the initial request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> PostAsyncRelativeRetrySucceededWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 500, then a 202 to
        /// the initial request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='product'>
        /// Product to put
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginPostAsyncRelativeRetrySucceededWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
