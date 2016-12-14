/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.parameterflattening.implementation;

import retrofit2.Retrofit;
import fixtures.parameterflattening.AvailabilitySets;
import com.google.common.reflect.TypeToken;
import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseBuilder;
import com.microsoft.rest.Validator;
import fixtures.parameterflattening.models.AvailabilitySetUpdateParameters;
import java.io.IOException;
import java.util.Map;
import okhttp3.ResponseBody;
import retrofit2.http.Body;
import retrofit2.http.Headers;
import retrofit2.http.PATCH;
import retrofit2.http.Path;
import retrofit2.Response;
import rx.functions.Func1;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in AvailabilitySets.
 */
public final class AvailabilitySetsImpl implements AvailabilitySets {
    /** The Retrofit service to perform REST calls. */
    private AvailabilitySetsService service;
    /** The service client containing this operation class. */
    private AutoRestParameterFlatteningImpl client;

    /**
     * Initializes an instance of AvailabilitySets.
     *
     * @param retrofit the Retrofit instance built from a Retrofit Builder.
     * @param client the instance of the service client containing this operation class.
     */
    public AvailabilitySetsImpl(Retrofit retrofit, AutoRestParameterFlatteningImpl client) {
        this.service = retrofit.create(AvailabilitySetsService.class);
        this.client = client;
    }

    /**
     * The interface defining all the services for AvailabilitySets to be
     * used by Retrofit to perform actually REST calls.
     */
    interface AvailabilitySetsService {
        @Headers("Content-Type: application/json; charset=utf-8")
        @PATCH("parameterFlattening/{resourceGroupName}/{availabilitySetName}")
        Observable<Response<ResponseBody>> update(@Path("resourceGroupName") String resourceGroupName, @Path("availabilitySetName") String avset, @Body AvailabilitySetUpdateParameters tags);

    }

    /**
     * Updates the tags for an availability set.
     *
     * @param resourceGroupName The name of the resource group.
     * @param avset The name of the storage availability set.
     * @param tags A set of tags. A description about the set of tags.
     */
    public void update(String resourceGroupName, String avset, Map<String, String> tags) {
        updateWithServiceResponseAsync(resourceGroupName, avset, tags).toBlocking().single().getBody();
    }

    /**
     * Updates the tags for an availability set.
     *
     * @param resourceGroupName The name of the resource group.
     * @param avset The name of the storage availability set.
     * @param tags A set of tags. A description about the set of tags.
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> updateAsync(String resourceGroupName, String avset, Map<String, String> tags, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(updateWithServiceResponseAsync(resourceGroupName, avset, tags), serviceCallback);
    }

    /**
     * Updates the tags for an availability set.
     *
     * @param resourceGroupName The name of the resource group.
     * @param avset The name of the storage availability set.
     * @param tags A set of tags. A description about the set of tags.
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<Void> updateAsync(String resourceGroupName, String avset, Map<String, String> tags) {
        return updateWithServiceResponseAsync(resourceGroupName, avset, tags).map(new Func1<ServiceResponse<Void>, Void>() {
            @Override
            public Void call(ServiceResponse<Void> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Updates the tags for an availability set.
     *
     * @param resourceGroupName The name of the resource group.
     * @param avset The name of the storage availability set.
     * @param tags A set of tags. A description about the set of tags.
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> updateWithServiceResponseAsync(String resourceGroupName, String avset, Map<String, String> tags) {
        if (resourceGroupName == null) {
            throw new IllegalArgumentException("Parameter resourceGroupName is required and cannot be null.");
        }
        if (avset == null) {
            throw new IllegalArgumentException("Parameter avset is required and cannot be null.");
        }
        if (tags == null) {
            throw new IllegalArgumentException("Parameter tags is required and cannot be null.");
        }
        Validator.validate(tags);
        AvailabilitySetUpdateParameters tags = new AvailabilitySetUpdateParameters();
        tags.withTags(tags);
        return service.update(resourceGroupName, avset, tags)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = updateDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<Void> updateDelegate(Response<ResponseBody> response) throws ServiceException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ServiceException>(this.client.mapperAdapter())
                .register(200, new TypeToken<Void>() { }.getType())
                .build(response);
    }

}
