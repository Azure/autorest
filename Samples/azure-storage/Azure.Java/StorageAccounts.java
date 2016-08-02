/**
 */

package petstore;

import com.microsoft.azure.CloudException;
import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import java.io.IOException;
import java.util.List;
import petstore.models.CheckNameAvailabilityResult;
import petstore.models.StorageAccount;
import petstore.models.StorageAccountCheckNameAvailabilityParameters;
import petstore.models.StorageAccountCreateParameters;
import petstore.models.StorageAccountKeys;
import petstore.models.StorageAccountRegenerateKeyParameters;
import petstore.models.StorageAccountUpdateParameters;

/**
 * An instance of this class provides access to all the operations defined
 * in StorageAccounts.
 */
public interface StorageAccounts {
    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the CheckNameAvailabilityResult object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<CheckNameAvailabilityResult> checkNameAvailability(StorageAccountCheckNameAvailabilityParameters accountName) throws CloudException, IOException, IllegalArgumentException;

    /**
     * Checks that account name is valid and is not in use.
     *
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<CheckNameAvailabilityResult> checkNameAvailabilityAsync(StorageAccountCheckNameAvailabilityParameters accountName, final ServiceCallback<CheckNameAvailabilityResult> serviceCallback) throws IllegalArgumentException;

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param parameters The parameters to provide for the created account.
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @throws InterruptedException exception thrown when long running operation is interrupted
     * @return the StorageAccount object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<StorageAccount> create(String resourceGroupName, String accountName, StorageAccountCreateParameters parameters) throws CloudException, IOException, IllegalArgumentException, InterruptedException;

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param parameters The parameters to provide for the created account.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<StorageAccount> createAsync(String resourceGroupName, String accountName, StorageAccountCreateParameters parameters, final ServiceCallback<StorageAccount> serviceCallback) throws IllegalArgumentException;

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param parameters The parameters to provide for the created account.
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the StorageAccount object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<StorageAccount> beginCreate(String resourceGroupName, String accountName, StorageAccountCreateParameters parameters) throws CloudException, IOException, IllegalArgumentException;

    /**
     * Asynchronously creates a new storage account with the specified parameters. Existing accounts cannot be updated with this API and should instead use the Update Storage Account API. If an account is already created and subsequent PUT request is issued with exact same set of properties, then HTTP 200 would be returned.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param parameters The parameters to provide for the created account.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<StorageAccount> beginCreateAsync(String resourceGroupName, String accountName, StorageAccountCreateParameters parameters, final ServiceCallback<StorageAccount> serviceCallback) throws IllegalArgumentException;

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the {@link ServiceResponse} object if successful.
     */
    ServiceResponse<Void> delete(String resourceGroupName, String accountName) throws CloudException, IOException, IllegalArgumentException;

    /**
     * Deletes a storage account in Microsoft Azure.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> deleteAsync(String resourceGroupName, String accountName, final ServiceCallback<Void> serviceCallback) throws IllegalArgumentException;

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the StorageAccount object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<StorageAccount> getProperties(String resourceGroupName, String accountName) throws CloudException, IOException, IllegalArgumentException;

    /**
     * Returns the properties for the specified storage account including but not limited to name, account type, location, and account status. The ListKeys operation should be used to retrieve storage keys.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<StorageAccount> getPropertiesAsync(String resourceGroupName, String accountName, final ServiceCallback<StorageAccount> serviceCallback) throws IllegalArgumentException;

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API. 
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the StorageAccount object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<StorageAccount> update(String resourceGroupName, String accountName, StorageAccountUpdateParameters parameters) throws CloudException, IOException, IllegalArgumentException;

    /**
     * Updates the account type or tags for a storage account. It can also be used to add a custom domain (note that custom domains cannot be added via the Create operation). Only one custom domain is supported per storage account. In order to replace a custom domain, the old value must be cleared before a new value may be set. To clear a custom domain, simply update the custom domain with empty string. Then call update again with the new cutsom domain name. The update API can only be used to update one of tags, accountType, or customDomain per call. To update multiple of these properties, call the API multiple times with one change per call. This call does not change the storage keys for the account. If you want to change storage account keys, use the RegenerateKey operation. The location and name of the storage account cannot be changed after creation.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param parameters The parameters to update on the account. Note that only one property can be changed at a time using this API. 
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<StorageAccount> updateAsync(String resourceGroupName, String accountName, StorageAccountUpdateParameters parameters, final ServiceCallback<StorageAccount> serviceCallback) throws IllegalArgumentException;

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the StorageAccountKeys object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<StorageAccountKeys> listKeys(String resourceGroupName, String accountName) throws CloudException, IOException, IllegalArgumentException;

    /**
     * Lists the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group.
     * @param accountName The name of the storage account.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<StorageAccountKeys> listKeysAsync(String resourceGroupName, String accountName, final ServiceCallback<StorageAccountKeys> serviceCallback) throws IllegalArgumentException;

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the List&lt;StorageAccount&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<List<StorageAccount>> list() throws CloudException, IOException, IllegalArgumentException;

    /**
     * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<List<StorageAccount>> listAsync(final ServiceCallback<List<StorageAccount>> serviceCallback) throws IllegalArgumentException;

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the List&lt;StorageAccount&gt; object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<List<StorageAccount>> listByResourceGroup(String resourceGroupName) throws CloudException, IOException, IllegalArgumentException;

    /**
     * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<List<StorageAccount>> listByResourceGroupAsync(String resourceGroupName, final ServiceCallback<List<StorageAccount>> serviceCallback) throws IllegalArgumentException;

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @throws CloudException exception thrown from REST call
     * @throws IOException exception thrown from serialization/deserialization
     * @throws IllegalArgumentException exception thrown from invalid parameters
     * @return the StorageAccountKeys object wrapped in {@link ServiceResponse} if successful.
     */
    ServiceResponse<StorageAccountKeys> regenerateKey(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParameters regenerateKey) throws CloudException, IOException, IllegalArgumentException;

    /**
     * Regenerates the access keys for the specified storage account.
     *
     * @param resourceGroupName The name of the resource group within the user's subscription.
     * @param accountName The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
     * @param regenerateKey Specifies name of the key which should be regenerated. key1 or key2 for the default keys
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if callback is null
     * @return the {@link ServiceCall} object
     */
    ServiceCall<StorageAccountKeys> regenerateKeyAsync(String resourceGroupName, String accountName, StorageAccountRegenerateKeyParameters regenerateKey, final ServiceCallback<StorageAccountKeys> serviceCallback) throws IllegalArgumentException;

}
