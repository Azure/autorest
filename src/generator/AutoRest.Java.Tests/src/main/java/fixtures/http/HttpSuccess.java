/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.http;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceFuture;
import com.microsoft.rest.ServiceResponse;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in HttpSuccess.
 */
public interface HttpSuccess {
    /**
     * Return 200 status code if successful.
     *
     */
    void head200();

    /**
     * Return 200 status code if successful.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> head200Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 200 status code if successful.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> head200Async();

    /**
     * Return 200 status code if successful.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> head200WithServiceResponseAsync();

    /**
     * Get 200 success.
     *
     * @return the boolean object if successful.
     */
    boolean get200();

    /**
     * Get 200 success.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Boolean> get200Async(final ServiceCallback<Boolean> serviceCallback);

    /**
     * Get 200 success.
     *
     * @return the observable to the boolean object
     */
    Observable<Boolean> get200Async();

    /**
     * Get 200 success.
     *
     * @return the observable to the boolean object
     */
    Observable<ServiceResponse<Boolean>> get200WithServiceResponseAsync();

    /**
     * Put boolean value true returning 200 success.
     *
     */
    void put200();

    /**
     * Put boolean value true returning 200 success.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put200Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Put boolean value true returning 200 success.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put200Async();

    /**
     * Put boolean value true returning 200 success.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put200WithServiceResponseAsync();
    /**
     * Put boolean value true returning 200 success.
     *
     * @param booleanValue Simple boolean value true
     */
    void put200(Boolean booleanValue);

    /**
     * Put boolean value true returning 200 success.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put200Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Put boolean value true returning 200 success.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put200Async(Boolean booleanValue);

    /**
     * Put boolean value true returning 200 success.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put200WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returning 200.
     *
     */
    void patch200();

    /**
     * Patch true Boolean value in request returning 200.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch200Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Patch true Boolean value in request returning 200.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch200Async();

    /**
     * Patch true Boolean value in request returning 200.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch200WithServiceResponseAsync();
    /**
     * Patch true Boolean value in request returning 200.
     *
     * @param booleanValue Simple boolean value true
     */
    void patch200(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returning 200.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch200Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Patch true Boolean value in request returning 200.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch200Async(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returning 200.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch200WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Post bollean value true in request that returns a 200.
     *
     */
    void post200();

    /**
     * Post bollean value true in request that returns a 200.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post200Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Post bollean value true in request that returns a 200.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post200Async();

    /**
     * Post bollean value true in request that returns a 200.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post200WithServiceResponseAsync();
    /**
     * Post bollean value true in request that returns a 200.
     *
     * @param booleanValue Simple boolean value true
     */
    void post200(Boolean booleanValue);

    /**
     * Post bollean value true in request that returns a 200.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post200Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Post bollean value true in request that returns a 200.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post200Async(Boolean booleanValue);

    /**
     * Post bollean value true in request that returns a 200.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post200WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Delete simple boolean value true returns 200.
     *
     */
    void delete200();

    /**
     * Delete simple boolean value true returns 200.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> delete200Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Delete simple boolean value true returns 200.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> delete200Async();

    /**
     * Delete simple boolean value true returns 200.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> delete200WithServiceResponseAsync();
    /**
     * Delete simple boolean value true returns 200.
     *
     * @param booleanValue Simple boolean value true
     */
    void delete200(Boolean booleanValue);

    /**
     * Delete simple boolean value true returns 200.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> delete200Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Delete simple boolean value true returns 200.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> delete200Async(Boolean booleanValue);

    /**
     * Delete simple boolean value true returns 200.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> delete200WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Put true Boolean value in request returns 201.
     *
     */
    void put201();

    /**
     * Put true Boolean value in request returns 201.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put201Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Put true Boolean value in request returns 201.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put201Async();

    /**
     * Put true Boolean value in request returns 201.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put201WithServiceResponseAsync();
    /**
     * Put true Boolean value in request returns 201.
     *
     * @param booleanValue Simple boolean value true
     */
    void put201(Boolean booleanValue);

    /**
     * Put true Boolean value in request returns 201.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put201Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Put true Boolean value in request returns 201.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put201Async(Boolean booleanValue);

    /**
     * Put true Boolean value in request returns 201.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put201WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 201 (Created).
     *
     */
    void post201();

    /**
     * Post true Boolean value in request returns 201 (Created).
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post201Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Post true Boolean value in request returns 201 (Created).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post201Async();

    /**
     * Post true Boolean value in request returns 201 (Created).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post201WithServiceResponseAsync();
    /**
     * Post true Boolean value in request returns 201 (Created).
     *
     * @param booleanValue Simple boolean value true
     */
    void post201(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 201 (Created).
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post201Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Post true Boolean value in request returns 201 (Created).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post201Async(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 201 (Created).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post201WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Put true Boolean value in request returns 202 (Accepted).
     *
     */
    void put202();

    /**
     * Put true Boolean value in request returns 202 (Accepted).
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put202Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Put true Boolean value in request returns 202 (Accepted).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put202Async();

    /**
     * Put true Boolean value in request returns 202 (Accepted).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put202WithServiceResponseAsync();
    /**
     * Put true Boolean value in request returns 202 (Accepted).
     *
     * @param booleanValue Simple boolean value true
     */
    void put202(Boolean booleanValue);

    /**
     * Put true Boolean value in request returns 202 (Accepted).
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put202Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Put true Boolean value in request returns 202 (Accepted).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put202Async(Boolean booleanValue);

    /**
     * Put true Boolean value in request returns 202 (Accepted).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put202WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returns 202.
     *
     */
    void patch202();

    /**
     * Patch true Boolean value in request returns 202.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch202Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Patch true Boolean value in request returns 202.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch202Async();

    /**
     * Patch true Boolean value in request returns 202.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch202WithServiceResponseAsync();
    /**
     * Patch true Boolean value in request returns 202.
     *
     * @param booleanValue Simple boolean value true
     */
    void patch202(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returns 202.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch202Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Patch true Boolean value in request returns 202.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch202Async(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returns 202.
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch202WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 202 (Accepted).
     *
     */
    void post202();

    /**
     * Post true Boolean value in request returns 202 (Accepted).
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post202Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Post true Boolean value in request returns 202 (Accepted).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post202Async();

    /**
     * Post true Boolean value in request returns 202 (Accepted).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post202WithServiceResponseAsync();
    /**
     * Post true Boolean value in request returns 202 (Accepted).
     *
     * @param booleanValue Simple boolean value true
     */
    void post202(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 202 (Accepted).
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post202Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Post true Boolean value in request returns 202 (Accepted).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post202Async(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 202 (Accepted).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post202WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Delete true Boolean value in request returns 202 (accepted).
     *
     */
    void delete202();

    /**
     * Delete true Boolean value in request returns 202 (accepted).
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> delete202Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Delete true Boolean value in request returns 202 (accepted).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> delete202Async();

    /**
     * Delete true Boolean value in request returns 202 (accepted).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> delete202WithServiceResponseAsync();
    /**
     * Delete true Boolean value in request returns 202 (accepted).
     *
     * @param booleanValue Simple boolean value true
     */
    void delete202(Boolean booleanValue);

    /**
     * Delete true Boolean value in request returns 202 (accepted).
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> delete202Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Delete true Boolean value in request returns 202 (accepted).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> delete202Async(Boolean booleanValue);

    /**
     * Delete true Boolean value in request returns 202 (accepted).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> delete202WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Return 204 status code if successful.
     *
     */
    void head204();

    /**
     * Return 204 status code if successful.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> head204Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 204 status code if successful.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> head204Async();

    /**
     * Return 204 status code if successful.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> head204WithServiceResponseAsync();

    /**
     * Put true Boolean value in request returns 204 (no content).
     *
     */
    void put204();

    /**
     * Put true Boolean value in request returns 204 (no content).
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put204Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Put true Boolean value in request returns 204 (no content).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put204Async();

    /**
     * Put true Boolean value in request returns 204 (no content).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put204WithServiceResponseAsync();
    /**
     * Put true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     */
    void put204(Boolean booleanValue);

    /**
     * Put true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put204Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Put true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put204Async(Boolean booleanValue);

    /**
     * Put true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put204WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returns 204 (no content).
     *
     */
    void patch204();

    /**
     * Patch true Boolean value in request returns 204 (no content).
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch204Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Patch true Boolean value in request returns 204 (no content).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch204Async();

    /**
     * Patch true Boolean value in request returns 204 (no content).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch204WithServiceResponseAsync();
    /**
     * Patch true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     */
    void patch204(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch204Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Patch true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch204Async(Boolean booleanValue);

    /**
     * Patch true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch204WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 204 (no content).
     *
     */
    void post204();

    /**
     * Post true Boolean value in request returns 204 (no content).
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post204Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Post true Boolean value in request returns 204 (no content).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post204Async();

    /**
     * Post true Boolean value in request returns 204 (no content).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post204WithServiceResponseAsync();
    /**
     * Post true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     */
    void post204(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post204Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Post true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post204Async(Boolean booleanValue);

    /**
     * Post true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post204WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Delete true Boolean value in request returns 204 (no content).
     *
     */
    void delete204();

    /**
     * Delete true Boolean value in request returns 204 (no content).
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> delete204Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Delete true Boolean value in request returns 204 (no content).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> delete204Async();

    /**
     * Delete true Boolean value in request returns 204 (no content).
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> delete204WithServiceResponseAsync();
    /**
     * Delete true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     */
    void delete204(Boolean booleanValue);

    /**
     * Delete true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> delete204Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Delete true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> delete204Async(Boolean booleanValue);

    /**
     * Delete true Boolean value in request returns 204 (no content).
     *
     * @param booleanValue Simple boolean value true
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> delete204WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Return 404 status code.
     *
     */
    void head404();

    /**
     * Return 404 status code.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> head404Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 404 status code.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> head404Async();

    /**
     * Return 404 status code.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> head404WithServiceResponseAsync();

}
