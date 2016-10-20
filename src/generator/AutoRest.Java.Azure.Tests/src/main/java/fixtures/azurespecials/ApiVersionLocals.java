/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.azurespecials;

import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in ApiVersionLocals.
 */
public interface ApiVersionLocals {
    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     */
    void getMethodLocalValid();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> getMethodLocalValidAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> getMethodLocalValidAsync();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> getMethodLocalValidWithServiceResponseAsync();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = null to succeed.
     *
     */
    void getMethodLocalNull();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = null to succeed.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> getMethodLocalNullAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Get method with api-version modeled in the method.  pass in api-version = null to succeed.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> getMethodLocalNullAsync();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = null to succeed.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> getMethodLocalNullWithServiceResponseAsync();
    /**
     * Get method with api-version modeled in the method.  pass in api-version = null to succeed.
     *
     * @param apiVersion This should appear as a method parameter, use value null, this should result in no serialized parameter
     */
    void getMethodLocalNull(String apiVersion);

    /**
     * Get method with api-version modeled in the method.  pass in api-version = null to succeed.
     *
     * @param apiVersion This should appear as a method parameter, use value null, this should result in no serialized parameter
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> getMethodLocalNullAsync(String apiVersion, final ServiceCallback<Void> serviceCallback);

    /**
     * Get method with api-version modeled in the method.  pass in api-version = null to succeed.
     *
     * @param apiVersion This should appear as a method parameter, use value null, this should result in no serialized parameter
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> getMethodLocalNullAsync(String apiVersion);

    /**
     * Get method with api-version modeled in the method.  pass in api-version = null to succeed.
     *
     * @param apiVersion This should appear as a method parameter, use value null, this should result in no serialized parameter
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> getMethodLocalNullWithServiceResponseAsync(String apiVersion);

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     */
    void getPathLocalValid();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> getPathLocalValidAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> getPathLocalValidAsync();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> getPathLocalValidWithServiceResponseAsync();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     */
    void getSwaggerLocalValid();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> getSwaggerLocalValidAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> getSwaggerLocalValidAsync();

    /**
     * Get method with api-version modeled in the method.  pass in api-version = '2.0' to succeed.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> getSwaggerLocalValidWithServiceResponseAsync();

}
