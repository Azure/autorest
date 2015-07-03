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
    public partial interface ILROSADsOperations
    {
        /// <summary>
        /// Long running put request, service returns a 400 to the initial
        /// request
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
        Task<AzureOperationResponse<Product>> PutNonRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 400 to the initial
        /// request
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
        Task<AzureOperationResponse<Product>> BeginPutNonRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// DO NOT CALL THIS METHOD. For completion only
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetNonRetry400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a Product with
        /// 'ProvisioningState' = 'Creating' and 201 response code
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
        Task<AzureOperationResponse<Product>> PutNonRetry201Creating400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a Product with
        /// 'ProvisioningState' = 'Creating' and 201 response code
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
        Task<AzureOperationResponse<Product>> BeginPutNonRetry201Creating400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running opeartion polling returns a 400 with no error body
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetNonRetry201Creating400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 with
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
        Task<AzureOperationResponse<Product>> PutAsyncRelativeRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 with
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
        Task<AzureOperationResponse<Product>> BeginPutAsyncRelativeRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// DO NOT CALL THIS METHOD. For completion only
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncRelativeRetry400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 400 with an error
        /// body
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteNonRetry400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 400 with an error
        /// body
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteNonRetry400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 with a location
        /// header
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Delete202NonRetry400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 with a location
        /// header
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDelete202NonRetry400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncRelativeRetry400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncRelativeRetry400WithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 400 with no error body
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
        Task<AzureOperationResponse> PostNonRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 400 with no error body
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
        Task<AzureOperationResponse> BeginPostNonRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 with a location
        /// header
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
        Task<AzureOperationResponse> Post202NonRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 with a location
        /// header
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
        Task<AzureOperationResponse> BeginPost202NonRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
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
        Task<AzureOperationResponse> PostAsyncRelativeRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
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
        Task<AzureOperationResponse> BeginPostAsyncRelativeRetry400WithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request with no payload
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
        Task<AzureOperationResponse<Product>> PutError201NoProvisioningStatePayloadWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 201 to the initial
        /// request with no payload
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
        Task<AzureOperationResponse<Product>> BeginPutError201NoProvisioningStatePayloadWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// DO NOT CALL THIS METHOD. For completion only
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetError201NoProvisioningStatePayloadWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse<Product>> PutAsyncRelativeRetryNoStatusWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse<Product>> BeginPutAsyncRelativeRetryNoStatusWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncRelativeRetryNoStatusWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse<Product>> PutAsyncRelativeRetryNoStatusPayloadWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse<Product>> BeginPutAsyncRelativeRetryNoStatusPayloadWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncRelativeRetryNoStatusPayloadWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 204 to the initial
        /// request, indicating success.
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Delete204SucceededWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 204 to the initial
        /// request, indicating success.
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDelete204SucceededWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncRelativeRetryNoStatusWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncRelativeRetryNoStatusWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, without a location header.
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
        Task<AzureOperationResponse> Post202NoLocationWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, without a location header.
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
        Task<AzureOperationResponse> BeginPost202NoLocationWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse> PostAsyncRelativeRetryNoPayloadWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse> BeginPostAsyncRelativeRetryNoPayloadWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that is not a valid json
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
        Task<AzureOperationResponse<Product>> Put200InvalidJsonWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that is not a valid json
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
        Task<AzureOperationResponse<Product>> BeginPut200InvalidJsonWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// SHOUD NOT BE CALLED
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> Get200SucceededWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. The endpoint indicated in the
        /// Azure-AsyncOperation header is invalid.
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
        Task<AzureOperationResponse<Product>> PutAsyncRelativeRetryInvalidHeaderWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. The endpoint indicated in the
        /// Azure-AsyncOperation header is invalid.
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
        Task<AzureOperationResponse<Product>> BeginPutAsyncRelativeRetryInvalidHeaderWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// SHOULD NOT BE CALLED
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncRelativeRetryInvalidHeaderWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse<Product>> PutAsyncRelativeRetryInvalidJsonPollingWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse<Product>> BeginPutAsyncRelativeRetryInvalidJsonPollingWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running put request, service returns a 200 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. Poll the endpoint indicated in the
        /// Azure-AsyncOperation header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse<Product>> GetAsyncRelativeRetryInvalidJsonPollingWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request receing a reponse with an invalid 'Location' and
        /// 'Retry-After' headers
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> Delete202RetryInvalidHeaderWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request receing a reponse with an invalid 'Location' and
        /// 'Retry-After' headers
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDelete202RetryInvalidHeaderWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. The endpoint indicated in the Azure-AsyncOperation
        /// header is invalid
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncRelativeRetryInvalidHeaderWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. The endpoint indicated in the Azure-AsyncOperation
        /// header is invalid
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncRelativeRetryInvalidHeaderWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> DeleteAsyncRelativeRetryInvalidJsonPollingWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running delete request, service returns a 202 to the initial
        /// request. Poll the endpoint indicated in the Azure-AsyncOperation
        /// header for operation status
        /// </summary>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<AzureOperationResponse> BeginDeleteAsyncRelativeRetryInvalidJsonPollingWithOperationResponseAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with invalid 'Location' and 'Retry-After' headers.
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
        Task<AzureOperationResponse> Post202RetryInvalidHeaderWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with invalid 'Location' and 'Retry-After' headers.
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
        Task<AzureOperationResponse> BeginPost202RetryInvalidHeaderWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. The endpoint indicated in the
        /// Azure-AsyncOperation header is invalid.
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
        Task<AzureOperationResponse> PostAsyncRelativeRetryInvalidHeaderWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
        /// ProvisioningState=’Creating’. The endpoint indicated in the
        /// Azure-AsyncOperation header is invalid.
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
        Task<AzureOperationResponse> BeginPostAsyncRelativeRetryInvalidHeaderWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse> PostAsyncRelativeRetryInvalidJsonPollingWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Long running post request, service returns a 202 to the initial
        /// request, with an entity that contains
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
        Task<AzureOperationResponse> BeginPostAsyncRelativeRetryInvalidJsonPollingWithOperationResponseAsync(Product product = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
