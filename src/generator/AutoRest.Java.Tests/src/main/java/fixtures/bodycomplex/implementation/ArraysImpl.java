/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.bodycomplex.implementation;

import retrofit2.Retrofit;
import fixtures.bodycomplex.Arrays;
import com.google.common.reflect.TypeToken;
import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseBuilder;
import com.microsoft.rest.Validator;
import fixtures.bodycomplex.models.ArrayWrapper;
import fixtures.bodycomplex.models.ErrorException;
import java.io.IOException;
import okhttp3.ResponseBody;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.PUT;
import retrofit2.Response;
import rx.functions.Func1;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in Arrays.
 */
public final class ArraysImpl implements Arrays {
    /** The Retrofit service to perform REST calls. */
    private ArraysService service;
    /** The service client containing this operation class. */
    private AutoRestComplexTestServiceImpl client;

    /**
     * Initializes an instance of Arrays.
     *
     * @param retrofit the Retrofit instance built from a Retrofit Builder.
     * @param client the instance of the service client containing this operation class.
     */
    public ArraysImpl(Retrofit retrofit, AutoRestComplexTestServiceImpl client) {
        this.service = retrofit.create(ArraysService.class);
        this.client = client;
    }

    /**
     * The interface defining all the services for Arrays to be
     * used by Retrofit to perform actually REST calls.
     */
    interface ArraysService {
        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("complex/array/valid")
        Observable<Response<ResponseBody>> getValid();

        @Headers("Content-Type: application/json; charset=utf-8")
        @PUT("complex/array/valid")
        Observable<Response<ResponseBody>> putValid(@Body ArrayWrapper complexBody);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("complex/array/empty")
        Observable<Response<ResponseBody>> getEmpty();

        @Headers("Content-Type: application/json; charset=utf-8")
        @PUT("complex/array/empty")
        Observable<Response<ResponseBody>> putEmpty(@Body ArrayWrapper complexBody);

        @Headers("Content-Type: application/json; charset=utf-8")
        @GET("complex/array/notprovided")
        Observable<Response<ResponseBody>> getNotProvided();

    }

    /**
     * Get complex types with array property.
     *
     * @return the ArrayWrapper object if successful.
     */
    public ArrayWrapper getValid() {
        return getValidWithServiceResponseAsync().toBlocking().single().getBody();
    }

    /**
     * Get complex types with array property.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<ArrayWrapper> getValidAsync(final ServiceCallback<ArrayWrapper> serviceCallback) {
        return ServiceCall.create(getValidWithServiceResponseAsync(), serviceCallback);
    }

    /**
     * Get complex types with array property.
     *
     * @return the observable to the ArrayWrapper object
     */
    public Observable<ArrayWrapper> getValidAsync() {
        return getValidWithServiceResponseAsync().map(new Func1<ServiceResponse<ArrayWrapper>, ArrayWrapper>() {
            @Override
            public ArrayWrapper call(ServiceResponse<ArrayWrapper> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Get complex types with array property.
     *
     * @return the observable to the ArrayWrapper object
     */
    public Observable<ServiceResponse<ArrayWrapper>> getValidWithServiceResponseAsync() {
        return service.getValid()
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<ArrayWrapper>>>() {
                @Override
                public Observable<ServiceResponse<ArrayWrapper>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<ArrayWrapper> clientResponse = getValidDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<ArrayWrapper> getValidDelegate(Response<ResponseBody> response) throws ErrorException, IOException {
        return new ServiceResponseBuilder<ArrayWrapper, ErrorException>(this.client.mapperAdapter())
                .register(200, new TypeToken<ArrayWrapper>() { }.getType())
                .registerError(ErrorException.class)
                .build(response);
    }

    /**
     * Put complex types with array property.
     *
     * @param complexBody Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y", "The quick brown fox jumps over the lazy dog"
     */
    public void putValid(ArrayWrapper complexBody) {
        putValidWithServiceResponseAsync(complexBody).toBlocking().single().getBody();
    }

    /**
     * Put complex types with array property.
     *
     * @param complexBody Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y", "The quick brown fox jumps over the lazy dog"
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> putValidAsync(ArrayWrapper complexBody, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(putValidWithServiceResponseAsync(complexBody), serviceCallback);
    }

    /**
     * Put complex types with array property.
     *
     * @param complexBody Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y", "The quick brown fox jumps over the lazy dog"
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<Void> putValidAsync(ArrayWrapper complexBody) {
        return putValidWithServiceResponseAsync(complexBody).map(new Func1<ServiceResponse<Void>, Void>() {
            @Override
            public Void call(ServiceResponse<Void> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Put complex types with array property.
     *
     * @param complexBody Please put an array with 4 items: "1, 2, 3, 4", "", null, "&amp;S#$(*Y", "The quick brown fox jumps over the lazy dog"
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> putValidWithServiceResponseAsync(ArrayWrapper complexBody) {
        if (complexBody == null) {
            throw new IllegalArgumentException("Parameter complexBody is required and cannot be null.");
        }
        Validator.validate(complexBody);
        return service.putValid(complexBody)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = putValidDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<Void> putValidDelegate(Response<ResponseBody> response) throws ErrorException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ErrorException>(this.client.mapperAdapter())
                .register(200, new TypeToken<Void>() { }.getType())
                .registerError(ErrorException.class)
                .build(response);
    }

    /**
     * Get complex types with array property which is empty.
     *
     * @return the ArrayWrapper object if successful.
     */
    public ArrayWrapper getEmpty() {
        return getEmptyWithServiceResponseAsync().toBlocking().single().getBody();
    }

    /**
     * Get complex types with array property which is empty.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<ArrayWrapper> getEmptyAsync(final ServiceCallback<ArrayWrapper> serviceCallback) {
        return ServiceCall.create(getEmptyWithServiceResponseAsync(), serviceCallback);
    }

    /**
     * Get complex types with array property which is empty.
     *
     * @return the observable to the ArrayWrapper object
     */
    public Observable<ArrayWrapper> getEmptyAsync() {
        return getEmptyWithServiceResponseAsync().map(new Func1<ServiceResponse<ArrayWrapper>, ArrayWrapper>() {
            @Override
            public ArrayWrapper call(ServiceResponse<ArrayWrapper> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Get complex types with array property which is empty.
     *
     * @return the observable to the ArrayWrapper object
     */
    public Observable<ServiceResponse<ArrayWrapper>> getEmptyWithServiceResponseAsync() {
        return service.getEmpty()
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<ArrayWrapper>>>() {
                @Override
                public Observable<ServiceResponse<ArrayWrapper>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<ArrayWrapper> clientResponse = getEmptyDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<ArrayWrapper> getEmptyDelegate(Response<ResponseBody> response) throws ErrorException, IOException {
        return new ServiceResponseBuilder<ArrayWrapper, ErrorException>(this.client.mapperAdapter())
                .register(200, new TypeToken<ArrayWrapper>() { }.getType())
                .registerError(ErrorException.class)
                .build(response);
    }

    /**
     * Put complex types with array property which is empty.
     *
     * @param complexBody Please put an empty array
     */
    public void putEmpty(ArrayWrapper complexBody) {
        putEmptyWithServiceResponseAsync(complexBody).toBlocking().single().getBody();
    }

    /**
     * Put complex types with array property which is empty.
     *
     * @param complexBody Please put an empty array
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<Void> putEmptyAsync(ArrayWrapper complexBody, final ServiceCallback<Void> serviceCallback) {
        return ServiceCall.create(putEmptyWithServiceResponseAsync(complexBody), serviceCallback);
    }

    /**
     * Put complex types with array property which is empty.
     *
     * @param complexBody Please put an empty array
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<Void> putEmptyAsync(ArrayWrapper complexBody) {
        return putEmptyWithServiceResponseAsync(complexBody).map(new Func1<ServiceResponse<Void>, Void>() {
            @Override
            public Void call(ServiceResponse<Void> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Put complex types with array property which is empty.
     *
     * @param complexBody Please put an empty array
     * @return the {@link ServiceResponse} object if successful.
     */
    public Observable<ServiceResponse<Void>> putEmptyWithServiceResponseAsync(ArrayWrapper complexBody) {
        if (complexBody == null) {
            throw new IllegalArgumentException("Parameter complexBody is required and cannot be null.");
        }
        Validator.validate(complexBody);
        return service.putEmpty(complexBody)
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<Void>>>() {
                @Override
                public Observable<ServiceResponse<Void>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<Void> clientResponse = putEmptyDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<Void> putEmptyDelegate(Response<ResponseBody> response) throws ErrorException, IOException, IllegalArgumentException {
        return new ServiceResponseBuilder<Void, ErrorException>(this.client.mapperAdapter())
                .register(200, new TypeToken<Void>() { }.getType())
                .registerError(ErrorException.class)
                .build(response);
    }

    /**
     * Get complex types with array property while server doesn't provide a response payload.
     *
     * @return the ArrayWrapper object if successful.
     */
    public ArrayWrapper getNotProvided() {
        return getNotProvidedWithServiceResponseAsync().toBlocking().single().getBody();
    }

    /**
     * Get complex types with array property while server doesn't provide a response payload.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    public ServiceCall<ArrayWrapper> getNotProvidedAsync(final ServiceCallback<ArrayWrapper> serviceCallback) {
        return ServiceCall.create(getNotProvidedWithServiceResponseAsync(), serviceCallback);
    }

    /**
     * Get complex types with array property while server doesn't provide a response payload.
     *
     * @return the observable to the ArrayWrapper object
     */
    public Observable<ArrayWrapper> getNotProvidedAsync() {
        return getNotProvidedWithServiceResponseAsync().map(new Func1<ServiceResponse<ArrayWrapper>, ArrayWrapper>() {
            @Override
            public ArrayWrapper call(ServiceResponse<ArrayWrapper> response) {
                return response.getBody();
            }
        });
    }

    /**
     * Get complex types with array property while server doesn't provide a response payload.
     *
     * @return the observable to the ArrayWrapper object
     */
    public Observable<ServiceResponse<ArrayWrapper>> getNotProvidedWithServiceResponseAsync() {
        return service.getNotProvided()
            .flatMap(new Func1<Response<ResponseBody>, Observable<ServiceResponse<ArrayWrapper>>>() {
                @Override
                public Observable<ServiceResponse<ArrayWrapper>> call(Response<ResponseBody> response) {
                    try {
                        ServiceResponse<ArrayWrapper> clientResponse = getNotProvidedDelegate(response);
                        return Observable.just(clientResponse);
                    } catch (Throwable t) {
                        return Observable.error(t);
                    }
                }
            });
    }

    private ServiceResponse<ArrayWrapper> getNotProvidedDelegate(Response<ResponseBody> response) throws ErrorException, IOException {
        return new ServiceResponseBuilder<ArrayWrapper, ErrorException>(this.client.mapperAdapter())
                .register(200, new TypeToken<ArrayWrapper>() { }.getType())
                .registerError(ErrorException.class)
                .build(response);
    }

}
