/**
 * Code generated by Microsoft (R) AutoRest Code Generator 1.2.0.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package storage;

import com.microsoft.rest.RestClient;

/**
 * The interface for StorageManagementClient class.
 */
public interface StorageManagementClient {
    /**
     * Gets the REST client.
     *
     * @return the {@link RestClient} object.
    */
    RestClient restClient();

    /**
     * The default base URL.
     */
    String DEFAULT_BASE_URL = "https://management.azure.com";

    /**
     * Gets Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call..
     *
     * @return the subscriptionId value.
     */
    String subscriptionId();

    /**
     * Sets Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call..
     *
     * @param subscriptionId the subscriptionId value.
     * @return the service client itself
     */
    StorageManagementClient withSubscriptionId(String subscriptionId);

    /**
     * Gets Client Api Version..
     *
     * @return the apiVersion value.
     */
    String apiVersion();

    /**
     * Sets Client Api Version..
     *
     * @param apiVersion the apiVersion value.
     * @return the service client itself
     */
    StorageManagementClient withApiVersion(String apiVersion);

    /**
     * Gets the StorageAccounts object to access its operations.
     * @return the StorageAccounts object.
     */
    StorageAccounts storageAccounts();

    /**
     * Gets the Usages object to access its operations.
     * @return the Usages object.
     */
    Usages usages();

}
