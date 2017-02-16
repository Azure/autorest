/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.bodycomplex;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceFuture;
import com.microsoft.rest.ServiceResponse;
import fixtures.bodycomplex.models.ArrayWrapper;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in Arrays.
 */
public interface Arrays {
    /**
     * Get complex types with array property.
     *
     * @return the ArrayWrapper object if successful.
     */
    ArrayWrapper getValid();

    /**
     * Get complex types with array property.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<ArrayWrapper> getValidAsync(final ServiceCallback<ArrayWrapper> serviceCallback);

    /**
     * Get complex types with array property.
     *
     * @return the observable to the ArrayWrapper object
     */
    Observable<ArrayWrapper> getValidAsync();

    /**
     * Get complex types with array property.
     *
     * @return the observable to the ArrayWrapper object
     */
    Observable<ServiceResponse<ArrayWrapper>> getValidWithServiceResponseAsync();

    /**
     * Put complex types with array property.
     *
     * @param complexBody Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y", "The quick brown fox jumps over the lazy dog"
     */
    void putValid(ArrayWrapper complexBody);

    /**
     * Put complex types with array property.
     *
     * @param complexBody Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y", "The quick brown fox jumps over the lazy dog"
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> putValidAsync(ArrayWrapper complexBody, final ServiceCallback<Void> serviceCallback);

    /**
     * Put complex types with array property.
     *
     * @param complexBody Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y", "The quick brown fox jumps over the lazy dog"
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> putValidAsync(ArrayWrapper complexBody);

    /**
     * Put complex types with array property.
     *
     * @param complexBody Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y", "The quick brown fox jumps over the lazy dog"
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> putValidWithServiceResponseAsync(ArrayWrapper complexBody);

    /**
     * Get complex types with array property which is empty.
     *
     * @return the ArrayWrapper object if successful.
     */
    ArrayWrapper getEmpty();

    /**
     * Get complex types with array property which is empty.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<ArrayWrapper> getEmptyAsync(final ServiceCallback<ArrayWrapper> serviceCallback);

    /**
     * Get complex types with array property which is empty.
     *
     * @return the observable to the ArrayWrapper object
     */
    Observable<ArrayWrapper> getEmptyAsync();

    /**
     * Get complex types with array property which is empty.
     *
     * @return the observable to the ArrayWrapper object
     */
    Observable<ServiceResponse<ArrayWrapper>> getEmptyWithServiceResponseAsync();

    /**
     * Put complex types with array property which is empty.
     *
     * @param complexBody Please put an empty array
     */
    void putEmpty(ArrayWrapper complexBody);

    /**
     * Put complex types with array property which is empty.
     *
     * @param complexBody Please put an empty array
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<Void> putEmptyAsync(ArrayWrapper complexBody, final ServiceCallback<Void> serviceCallback);

    /**
     * Put complex types with array property which is empty.
     *
     * @param complexBody Please put an empty array
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> putEmptyAsync(ArrayWrapper complexBody);

    /**
     * Put complex types with array property which is empty.
     *
     * @param complexBody Please put an empty array
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> putEmptyWithServiceResponseAsync(ArrayWrapper complexBody);

    /**
     * Get complex types with array property while server doesn't provide a response payload.
     *
     * @return the ArrayWrapper object if successful.
     */
    ArrayWrapper getNotProvided();

    /**
     * Get complex types with array property while server doesn't provide a response payload.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceFuture} object
     */
    ServiceFuture<ArrayWrapper> getNotProvidedAsync(final ServiceCallback<ArrayWrapper> serviceCallback);

    /**
     * Get complex types with array property while server doesn't provide a response payload.
     *
     * @return the observable to the ArrayWrapper object
     */
    Observable<ArrayWrapper> getNotProvidedAsync();

    /**
     * Get complex types with array property while server doesn't provide a response payload.
     *
     * @return the observable to the ArrayWrapper object
     */
    Observable<ServiceResponse<ArrayWrapper>> getNotProvidedWithServiceResponseAsync();

}
