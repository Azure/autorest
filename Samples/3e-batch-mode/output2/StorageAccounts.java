/**
 * Code generated by Microsoft (R) AutoRest Code Generator 1.2.1.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package storage;

import .models.CheckNameAvailabilityResult;
import .models.StorageAccount;
import .models.StorageAccountCheckNameAvailabilityParameters;
import .models.StorageAccountCreateParameters;
import .models.StorageAccountKeys;
import .models.StorageAccountListResult;
import .models.StorageAccountRegenerateKeyParameters;
import .models.StorageAccountUpdateParameters;
import com.microsoft.rest.RestException;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceFuture;
import com.microsoft.rest.ServiceResponse;
import java.io.IOException;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in StorageAccounts.
 */
public interface StorageAccounts {
    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the CheckNameAvailabilityResult object if successful.
     */
    CheckNameAvailabilityResult checkNameAvailability(StorageAccountCheckNameAvailabilityParameters accountName);

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<CheckNameAvailabilityResult> checkNameAvailabilityAsync(StorageAccountCheckNameAvailabilityParameters accountName, final ServiceCallback<CheckNameAvailabilityResult> serviceCallback);

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the CheckNameAvailabilityResult object
     */
    Observable<CheckNameAvailabilityResult> checkNameAvailabilityAsync(StorageAccountCheckNameAvailabilityParameters accountName);

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the CheckNameAvailabilityResult object
     */
    Observable<ServiceResponse<CheckNameAvailabilityResult>> checkNameAvailabilityWithServiceResponseAsync(StorageAccountCheckNameAvailabilityParameters accountName);

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the StorageAccount object if successful.
     */
    StorageAccount create(String resourceGroupName, String accountName, StorageAccountCreateParameters parameters);

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<StorageAccount> createAsync(String resourceGroupName, String accountName, StorageAccountCreateParameters parameters, final ServiceCallback<StorageAccount> serviceCallback);

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccount object
     */
    Observable<StorageAccount> createAsync(String resourceGroupName, String accountName, StorageAccountCreateParameters parameters);

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to provide for the created account.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccount object
     */
    Observable<ServiceResponse<StorageAccount>> createWithServiceResponseAsync(String resourceGroupName, String accountName, StorageAccountCreateParameters parameters);

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void delete(String resourceGroupName, String accountName);

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> deleteAsync(String resourceGroupName, String accountName, final ServiceCallback<Void> serviceCallback);

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> deleteAsync(String resourceGroupName, String accountName);

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> deleteWithServiceResponseAsync(String resourceGroupName, String accountName);

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the StorageAccount object if successful.
     */
    StorageAccount getProperties(String resourceGroupName, String accountName);

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<StorageAccount> getPropertiesAsync(String resourceGroupName, String accountName, final ServiceCallback<StorageAccount> serviceCallback);

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccount object
     */
    Observable<StorageAccount> getPropertiesAsync(String resourceGroupName, String accountName);

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccount object
     */
    Observable<ServiceResponse<StorageAccount>> getPropertiesWithServiceResponseAsync(String resourceGroupName, String accountName);

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the StorageAccount object if successful.
     */
    StorageAccount update(String resourceGroupName, String accountName, StorageAccountUpdateParameters parameters);

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<StorageAccount> updateAsync(String resourceGroupName, String accountName, StorageAccountUpdateParameters parameters, final ServiceCallback<StorageAccount> serviceCallback);

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccount object
     */
    Observable<StorageAccount> updateAsync(String resourceGroupName, String accountName, StorageAccountUpdateParameters parameters);

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccount object
     */
    Observable<ServiceResponse<StorageAccount>> updateWithServiceResponseAsync(String resourceGroupName, String accountName, StorageAccountUpdateParameters parameters);

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the StorageAccountKeys object if successful.
     */
    StorageAccountKeys listKeys(String resourceGroupName, String accountName);

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<StorageAccountKeys> listKeysAsync(String resourceGroupName, String accountName, final ServiceCallback<StorageAccountKeys> serviceCallback);

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccountKeys object
     */
    Observable<StorageAccountKeys> listKeysAsync(String resourceGroupName, String accountName);

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccountKeys object
     */
    Observable<ServiceResponse<StorageAccountKeys>> listKeysWithServiceResponseAsync(String resourceGroupName, String accountName);

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the StorageAccountListResult object if successful.
     */
    StorageAccountListResult list();

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<StorageAccountListResult> listAsync(final ServiceCallback<StorageAccountListResult> serviceCallback);

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccountListResult object
     */
    Observable<StorageAccountListResult> listAsync();

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccountListResult object
     */
    Observable<ServiceResponse<StorageAccountListResult>> listWithServiceResponseAsync();

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the StorageAccountListResult object if successful.
     */
    StorageAccountListResult listByResourceGroup(String resourceGroupName);

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<StorageAccountListResult> listByResourceGroupAsync(String resourceGroupName, final ServiceCallback<StorageAccountListResult> serviceCallback);

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccountListResult object
     */
    Observable<StorageAccountListResult> listByResourceGroupAsync(String resourceGroupName);

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccountListResult object
     */
    Observable<ServiceResponse<StorageAccountListResult>> listByResourceGroupWithServiceResponseAsync(String resourceGroupName);

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws RestException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     * @return the StorageAccountKeys object if successful.
     */
    StorageAccountKeys regenerateKey(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParameters regenerateKey);

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<StorageAccountKeys> regenerateKeyAsync(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParameters regenerateKey, final ServiceCallback<StorageAccountKeys> serviceCallback);

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccountKeys object
     */
    Observable<StorageAccountKeys> regenerateKeyAsync(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParameters regenerateKey);

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the observable to the StorageAccountKeys object
     */
    Observable<ServiceResponse<StorageAccountKeys>> regenerateKeyWithServiceResponseAsync(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParameters regenerateKey);

}
