/*
*/

import { ServiceClientOptions, RequestOptions, ServiceCallback, HttpOperationResponse } from 'ms-rest';
import * as models from '../models';


/**
 * @class
 * StorageAccounts
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the StorageManagementClient.
 */
export interface StorageAccounts {


    /**
     * Checks that account name is valid and is not in use.
     *
     * @param {object} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {string} accountName.name
     *
     * @param {string} [accountName.type]
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<CheckNameAvailabilityResult>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    checkNameAvailabilityWithHttpOperationResponse(accountName: models.StorageAccountCheckNameAvailabilityParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.CheckNameAvailabilityResult>>;

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param {object} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {string} accountName.name
     *
     * @param {string} [accountName.type]
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {CheckNameAvailabilityResult} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {CheckNameAvailabilityResult} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link CheckNameAvailabilityResult} for more
     *                      information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    checkNameAvailability(accountName: models.StorageAccountCheckNameAvailabilityParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.CheckNameAvailabilityResult>;
    checkNameAvailability(accountName: models.StorageAccountCheckNameAvailabilityParameters, callback: ServiceCallback<models.CheckNameAvailabilityResult>): void;
    checkNameAvailability(accountName: models.StorageAccountCheckNameAvailabilityParameters, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.CheckNameAvailabilityResult>): void;


    /**
     * Asynchronously creates a new storage account with the specified parameters.
     * Existing accounts cannot be updated with this API and should instead use the
     * Update Storage Account API. If an account is already created and subsequent
     * PUT request is issued with exact same set of properties, then HTTP 200 would
     * be returned.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} parameters The parameters to provide for the created
     * account.
     *
     * @param {string} parameters.location Resource location
     *
     * @param {object} [parameters.tags] Resource tags
     *
     * @param {object} [parameters.properties]
     *
     * @param {string} parameters.properties.accountType Gets or sets the account
     * type. Possible values include: 'Standard_LRS', 'Standard_ZRS',
     * 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<StorageAccount>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    createWithHttpOperationResponse(resourceGroupName: string, accountName: string, parameters: models.StorageAccountCreateParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.StorageAccount>>;

    /**
     * Asynchronously creates a new storage account with the specified parameters.
     * Existing accounts cannot be updated with this API and should instead use the
     * Update Storage Account API. If an account is already created and subsequent
     * PUT request is issued with exact same set of properties, then HTTP 200 would
     * be returned.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} parameters The parameters to provide for the created
     * account.
     *
     * @param {string} parameters.location Resource location
     *
     * @param {object} [parameters.tags] Resource tags
     *
     * @param {object} [parameters.properties]
     *
     * @param {string} parameters.properties.accountType Gets or sets the account
     * type. Possible values include: 'Standard_LRS', 'Standard_ZRS',
     * 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {StorageAccount} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {StorageAccount} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link StorageAccount} for more information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    create(resourceGroupName: string, accountName: string, parameters: models.StorageAccountCreateParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.StorageAccount>;
    create(resourceGroupName: string, accountName: string, parameters: models.StorageAccountCreateParameters, callback: ServiceCallback<models.StorageAccount>): void;
    create(resourceGroupName: string, accountName: string, parameters: models.StorageAccountCreateParameters, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.StorageAccount>): void;


    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<null>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    deleteMethodWithHttpOperationResponse(resourceGroupName: string, accountName: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<void>>;

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {null} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {null} [result]   - The deserialized result object if an error did not occur.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    deleteMethod(resourceGroupName: string, accountName: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<void>;
    deleteMethod(resourceGroupName: string, accountName: string, callback: ServiceCallback<void>): void;
    deleteMethod(resourceGroupName: string, accountName: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<void>): void;


    /**
     * Returns the properties for the specified storage account including but not
     * limited to name, account type, location, and account status. The ListKeys
     * operation should be used to retrieve storage keys.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<StorageAccount>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    getPropertiesWithHttpOperationResponse(resourceGroupName: string, accountName: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.StorageAccount>>;

    /**
     * Returns the properties for the specified storage account including but not
     * limited to name, account type, location, and account status. The ListKeys
     * operation should be used to retrieve storage keys.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {StorageAccount} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {StorageAccount} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link StorageAccount} for more information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    getProperties(resourceGroupName: string, accountName: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.StorageAccount>;
    getProperties(resourceGroupName: string, accountName: string, callback: ServiceCallback<models.StorageAccount>): void;
    getProperties(resourceGroupName: string, accountName: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.StorageAccount>): void;


    /**
     * Updates the account type or tags for a storage account. It can also be used
     * to add a custom domain (note that custom domains cannot be added via the
     * Create operation). Only one custom domain is supported per storage account.
     * In order to replace a custom domain, the old value must be cleared before a
     * new value may be set. To clear a custom domain, simply update the custom
     * domain with empty string. Then call update again with the new cutsom domain
     * name. The update API can only be used to update one of tags, accountType, or
     * customDomain per call. To update multiple of these properties, call the API
     * multiple times with one change per call. This call does not change the
     * storage keys for the account. If you want to change storage account keys,
     * use the RegenerateKey operation. The location and name of the storage
     * account cannot be changed after creation.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} parameters The parameters to update on the account. Note
     * that only one property can be changed at a time using this API.
     *
     * @param {object} [parameters.tags] Resource tags
     *
     * @param {object} [parameters.properties]
     *
     * @param {string} [parameters.properties.accountType] Gets or sets the account
     * type. Note that StandardZRS and PremiumLRS accounts cannot be changed to
     * other account types, and other account types cannot be changed to
     * StandardZRS or PremiumLRS. Possible values include: 'Standard_LRS',
     * 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
     *
     * @param {object} [parameters.properties.customDomain] User domain assigned to
     * the storage account. Name is the CNAME source. Only one custom domain is
     * supported per storage account at this time. To clear the existing custom
     * domain, use an empty string for the custom domain name property.
     *
     * @param {string} parameters.properties.customDomain.name Gets or sets the
     * custom domain name. Name is the CNAME source.
     *
     * @param {boolean} [parameters.properties.customDomain.useSubDomain] Indicates
     * whether indirect CName validation is enabled. Default value is false. This
     * should only be set on updates
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<StorageAccount>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    updateWithHttpOperationResponse(resourceGroupName: string, accountName: string, parameters: models.StorageAccountUpdateParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.StorageAccount>>;

    /**
     * Updates the account type or tags for a storage account. It can also be used
     * to add a custom domain (note that custom domains cannot be added via the
     * Create operation). Only one custom domain is supported per storage account.
     * In order to replace a custom domain, the old value must be cleared before a
     * new value may be set. To clear a custom domain, simply update the custom
     * domain with empty string. Then call update again with the new cutsom domain
     * name. The update API can only be used to update one of tags, accountType, or
     * customDomain per call. To update multiple of these properties, call the API
     * multiple times with one change per call. This call does not change the
     * storage keys for the account. If you want to change storage account keys,
     * use the RegenerateKey operation. The location and name of the storage
     * account cannot be changed after creation.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} parameters The parameters to update on the account. Note
     * that only one property can be changed at a time using this API.
     *
     * @param {object} [parameters.tags] Resource tags
     *
     * @param {object} [parameters.properties]
     *
     * @param {string} [parameters.properties.accountType] Gets or sets the account
     * type. Note that StandardZRS and PremiumLRS accounts cannot be changed to
     * other account types, and other account types cannot be changed to
     * StandardZRS or PremiumLRS. Possible values include: 'Standard_LRS',
     * 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
     *
     * @param {object} [parameters.properties.customDomain] User domain assigned to
     * the storage account. Name is the CNAME source. Only one custom domain is
     * supported per storage account at this time. To clear the existing custom
     * domain, use an empty string for the custom domain name property.
     *
     * @param {string} parameters.properties.customDomain.name Gets or sets the
     * custom domain name. Name is the CNAME source.
     *
     * @param {boolean} [parameters.properties.customDomain.useSubDomain] Indicates
     * whether indirect CName validation is enabled. Default value is false. This
     * should only be set on updates
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {StorageAccount} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {StorageAccount} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link StorageAccount} for more information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    update(resourceGroupName: string, accountName: string, parameters: models.StorageAccountUpdateParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.StorageAccount>;
    update(resourceGroupName: string, accountName: string, parameters: models.StorageAccountUpdateParameters, callback: ServiceCallback<models.StorageAccount>): void;
    update(resourceGroupName: string, accountName: string, parameters: models.StorageAccountUpdateParameters, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.StorageAccount>): void;


    /**
     * Lists the access keys for the specified storage account.
     *
     * @param {string} resourceGroupName The name of the resource group.
     *
     * @param {string} accountName The name of the storage account.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<StorageAccountKeys>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    listKeysWithHttpOperationResponse(resourceGroupName: string, accountName: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.StorageAccountKeys>>;

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param {string} resourceGroupName The name of the resource group.
     *
     * @param {string} accountName The name of the storage account.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {StorageAccountKeys} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {StorageAccountKeys} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link StorageAccountKeys} for more information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    listKeys(resourceGroupName: string, accountName: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.StorageAccountKeys>;
    listKeys(resourceGroupName: string, accountName: string, callback: ServiceCallback<models.StorageAccountKeys>): void;
    listKeys(resourceGroupName: string, accountName: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.StorageAccountKeys>): void;


    /**
     * Lists all the storage accounts available under the subscription. Note that
     * storage keys are not returned; use the ListKeys operation for this.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<StorageAccountListResult>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    listWithHttpOperationResponse(options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.StorageAccountListResult>>;

    /**
     * Lists all the storage accounts available under the subscription. Note that
     * storage keys are not returned; use the ListKeys operation for this.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {StorageAccountListResult} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {StorageAccountListResult} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link StorageAccountListResult} for more
     *                      information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    list(options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.StorageAccountListResult>;
    list(callback: ServiceCallback<models.StorageAccountListResult>): void;
    list(options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.StorageAccountListResult>): void;


    /**
     * Lists all the storage accounts available under the given resource group.
     * Note that storage keys are not returned; use the ListKeys operation for
     * this.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<StorageAccountListResult>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    listByResourceGroupWithHttpOperationResponse(resourceGroupName: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.StorageAccountListResult>>;

    /**
     * Lists all the storage accounts available under the given resource group.
     * Note that storage keys are not returned; use the ListKeys operation for
     * this.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {StorageAccountListResult} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {StorageAccountListResult} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link StorageAccountListResult} for more
     *                      information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    listByResourceGroup(resourceGroupName: string, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.StorageAccountListResult>;
    listByResourceGroup(resourceGroupName: string, callback: ServiceCallback<models.StorageAccountListResult>): void;
    listByResourceGroup(resourceGroupName: string, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.StorageAccountListResult>): void;


    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} regenerateKeyParameter Specifies name of the key which
     * should be regenerated. key1 or key2 for the default keys
     *
     * @param {string} regenerateKeyParameter.keyName
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<StorageAccountKeys>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    regenerateKeyWithHttpOperationResponse(resourceGroupName: string, accountName: string, regenerateKeyParameter: models.StorageAccountRegenerateKeyParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.StorageAccountKeys>>;

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} regenerateKeyParameter Specifies name of the key which
     * should be regenerated. key1 or key2 for the default keys
     *
     * @param {string} regenerateKeyParameter.keyName
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {StorageAccountKeys} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {StorageAccountKeys} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link StorageAccountKeys} for more information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    regenerateKey(resourceGroupName: string, accountName: string, regenerateKeyParameter: models.StorageAccountRegenerateKeyParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.StorageAccountKeys>;
    regenerateKey(resourceGroupName: string, accountName: string, regenerateKeyParameter: models.StorageAccountRegenerateKeyParameters, callback: ServiceCallback<models.StorageAccountKeys>): void;
    regenerateKey(resourceGroupName: string, accountName: string, regenerateKeyParameter: models.StorageAccountRegenerateKeyParameters, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.StorageAccountKeys>): void;


    /**
     * Asynchronously creates a new storage account with the specified parameters.
     * Existing accounts cannot be updated with this API and should instead use the
     * Update Storage Account API. If an account is already created and subsequent
     * PUT request is issued with exact same set of properties, then HTTP 200 would
     * be returned.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} parameters The parameters to provide for the created
     * account.
     *
     * @param {string} parameters.location Resource location
     *
     * @param {object} [parameters.tags] Resource tags
     *
     * @param {object} [parameters.properties]
     *
     * @param {string} parameters.properties.accountType Gets or sets the account
     * type. Possible values include: 'Standard_LRS', 'Standard_ZRS',
     * 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<StorageAccount>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    beginCreateWithHttpOperationResponse(resourceGroupName: string, accountName: string, parameters: models.StorageAccountCreateParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.StorageAccount>>;

    /**
     * Asynchronously creates a new storage account with the specified parameters.
     * Existing accounts cannot be updated with this API and should instead use the
     * Update Storage Account API. If an account is already created and subsequent
     * PUT request is issued with exact same set of properties, then HTTP 200 would
     * be returned.
     *
     * @param {string} resourceGroupName The name of the resource group within the
     * user's subscription.
     *
     * @param {string} accountName The name of the storage account within the
     * specified resource group. Storage account names must be between 3 and 24
     * characters in length and use numbers and lower-case letters only.
     *
     * @param {object} parameters The parameters to provide for the created
     * account.
     *
     * @param {string} parameters.location Resource location
     *
     * @param {object} [parameters.tags] Resource tags
     *
     * @param {object} [parameters.properties]
     *
     * @param {string} parameters.properties.accountType Gets or sets the account
     * type. Possible values include: 'Standard_LRS', 'Standard_ZRS',
     * 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {StorageAccount} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {StorageAccount} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link StorageAccount} for more information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    beginCreate(resourceGroupName: string, accountName: string, parameters: models.StorageAccountCreateParameters, options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.StorageAccount>;
    beginCreate(resourceGroupName: string, accountName: string, parameters: models.StorageAccountCreateParameters, callback: ServiceCallback<models.StorageAccount>): void;
    beginCreate(resourceGroupName: string, accountName: string, parameters: models.StorageAccountCreateParameters, options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.StorageAccount>): void;
}

/**
 * @class
 * UsageOperations
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the StorageManagementClient.
 */
export interface UsageOperations {


    /**
     * Gets the current usage count and the limit for the resources under the
     * subscription.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @returns {Promise} A promise is returned
     *
     * @resolve {HttpOperationResponse<UsageListResult>} - The deserialized result object.
     *
     * @reject {Error|ServiceError} - The error object.
     */
    listWithHttpOperationResponse(options?: { customHeaders? : { [headerName: string]: string; } }): Promise<HttpOperationResponse<models.UsageListResult>>;

    /**
     * Gets the current usage count and the limit for the resources under the
     * subscription.
     *
     * @param {object} [options] Optional Parameters.
     *
     * @param {object} [options.customHeaders] Headers that will be added to the
     * request
     *
     * @param {ServiceCallback} [optionalCallback] - The optional callback.
     *
     * @returns {ServiceCallback|Promise} If a callback was passed as the last
     * parameter then it returns the callback else returns a Promise.
     *
     * {Promise} A promise is returned.
     *
     *                      @resolve {UsageListResult} - The deserialized result object.
     *
     *                      @reject {Error|ServiceError} - The error object.
     *
     * {ServiceCallback} optionalCallback(err, result, request, response)
     *
     *                      {Error|ServiceError}  err        - The Error object if an error occurred, null otherwise.
     *
     *                      {UsageListResult} [result]   - The deserialized result object if an error did not occur.
     *                      See {@link UsageListResult} for more information.
     *
     *                      {WebResource} [request]  - The HTTP Request object if an error did not occur.
     *
     *                      {http.IncomingMessage} [response] - The HTTP Response stream if an error did not occur.
     */
    list(options?: { customHeaders? : { [headerName: string]: string; } }): Promise<models.UsageListResult>;
    list(callback: ServiceCallback<models.UsageListResult>): void;
    list(options: { customHeaders? : { [headerName: string]: string; } }, callback: ServiceCallback<models.UsageListResult>): void;
}
