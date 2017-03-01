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
import fixtures.http.models.ErrorException;
import java.io.IOException;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in HttpRetrys.
 */
public interface HttpRetrys {
    /**
     * Return 408 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void head408();

    /**
     * Return 408 status code, then 200 after retry.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> head408Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 408 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> head408Async();

    /**
     * Return 408 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> head408WithServiceResponseAsync();

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void put500();

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put500Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put500Async();

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put500WithServiceResponseAsync();
    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void put500(Boolean booleanValue);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put500Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put500Async(Boolean booleanValue);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put500WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void patch500();

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch500Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch500Async();

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch500WithServiceResponseAsync();
    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void patch500(Boolean booleanValue);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch500Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch500Async(Boolean booleanValue);

    /**
     * Return 500 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch500WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Return 502 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void get502();

    /**
     * Return 502 status code, then 200 after retry.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> get502Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 502 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> get502Async();

    /**
     * Return 502 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> get502WithServiceResponseAsync();

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void post503();

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post503Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post503Async();

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post503WithServiceResponseAsync();
    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void post503(Boolean booleanValue);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> post503Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> post503Async(Boolean booleanValue);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> post503WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void delete503();

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> delete503Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> delete503Async();

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> delete503WithServiceResponseAsync();
    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void delete503(Boolean booleanValue);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> delete503Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> delete503Async(Boolean booleanValue);

    /**
     * Return 503 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> delete503WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void put504();

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put504Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put504Async();

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put504WithServiceResponseAsync();
    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void put504(Boolean booleanValue);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> put504Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> put504Async(Boolean booleanValue);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> put504WithServiceResponseAsync(Boolean booleanValue);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void patch504();

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch504Async(final ServiceCallback<Void> serviceCallback);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch504Async();

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch504WithServiceResponseAsync();
    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @throws ErrorException thrown if the request is rejected by server
     * @throws RuntimeException all other wrapped checked exceptions if the request fails to be sent
     */
    void patch504(Boolean booleanValue);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> patch504Async(Boolean booleanValue, final ServiceCallback<Void> serviceCallback);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> patch504Async(Boolean booleanValue);

    /**
     * Return 504 status code, then 200 after retry.
     *
     * @param booleanValue Simple boolean value true
     * @throws IllegalArgumentException thrown if parameters fail the validation
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> patch504WithServiceResponseAsync(Boolean booleanValue);

}
