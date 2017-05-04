/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.custombaseurimoreoptions;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceFuture;
import com.microsoft.rest.ServiceResponse;
import fixtures.custombaseurimoreoptions.models.ErrorException;
import java.io.IOException;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in Paths.
 */
public interface Paths {
    /**
     * Get a 200 to test a valid base uri.
     *
     * @param vault The vault name, e.g. https://myvault
     * @param secret Secret value.
     * @param keyName The key name with value 'key1'.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void getEmpty(String vault, String secret, String keyName);

    /**
     * Get a 200 to test a valid base uri.
     *
     * @param vault The vault name, e.g. https://myvault
     * @param secret Secret value.
     * @param keyName The key name with value 'key1'.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> getEmptyAsync(String vault, String secret, String keyName, final ServiceCallback<Void> serviceCallback);

    /**
     * Get a 200 to test a valid base uri.
     *
     * @param vault The vault name, e.g. https://myvault
     * @param secret Secret value.
     * @param keyName The key name with value 'key1'.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> getEmptyAsync(String vault, String secret, String keyName);

    /**
     * Get a 200 to test a valid base uri.
     *
     * @param vault The vault name, e.g. https://myvault
     * @param secret Secret value.
     * @param keyName The key name with value 'key1'.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> getEmptyWithServiceResponseAsync(String vault, String secret, String keyName);
    /**
     * Get a 200 to test a valid base uri.
     *
     * @param vault The vault name, e.g. https://myvault
     * @param secret Secret value.
     * @param keyName The key name with value 'key1'.
     * @param keyVersion The key version. Default value 'v1'.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void getEmpty(String vault, String secret, String keyName, String keyVersion);

    /**
     * Get a 200 to test a valid base uri.
     *
     * @param vault The vault name, e.g. https://myvault
     * @param secret Secret value.
     * @param keyName The key name with value 'key1'.
     * @param keyVersion The key version. Default value 'v1'.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> getEmptyAsync(String vault, String secret, String keyName, String keyVersion, final ServiceCallback<Void> serviceCallback);

    /**
     * Get a 200 to test a valid base uri.
     *
     * @param vault The vault name, e.g. https://myvault
     * @param secret Secret value.
     * @param keyName The key name with value 'key1'.
     * @param keyVersion The key version. Default value 'v1'.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> getEmptyAsync(String vault, String secret, String keyName, String keyVersion);

    /**
     * Get a 200 to test a valid base uri.
     *
     * @param vault The vault name, e.g. https://myvault
     * @param secret Secret value.
     * @param keyName The key name with value 'key1'.
     * @param keyVersion The key version. Default value 'v1'.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> getEmptyWithServiceResponseAsync(String vault, String secret, String keyName, String keyVersion);

}
