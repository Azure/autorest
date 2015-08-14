/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.retrofit;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseBuilder;
import com.microsoft.rest.ServiceResponseCallback;
import com.microsoft.rest.retrofit.models.ErrorModel;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import retrofit.client.Response;
import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.PUT;

public class IntOperations {
    private IntService service;

    public IntOperations(RestAdapter restAdapter) {
        service = restAdapter.create(IntService.class);
    }

    private interface IntService {
        @GET("/int/null")
        Response getNull();

        @GET("/int/null")
        void getNullAsync(ServiceResponseCallback cb);

        @GET("/int/invalid")
        Response getInvalid();

        @GET("/int/invalid")
        void getInvalidAsync(ServiceResponseCallback cb);

        @PUT("/int/max/32")
        Response putMax32(@Body int intBody);

        @PUT("/int/max/32")
        void putMax32Async(@Body int intBody, ServiceResponseCallback cb);
    }

    public int getNull() throws ServiceException {
        try {
            return getNullDelegate(service.getNull(), null).getBody();
        } catch (RetrofitError error) {
            return getNullDelegate(error.getResponse(), error).getBody();
        }
    }

    public void getNullAsync(final ServiceCallback<Integer> serviceCallback) {
        service.getNullAsync(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(getNullDelegate(response, error));
                } catch (ServiceException ex) {
                    serviceCallback.failure(ex);
                }
            }
        });
    }

    private ServiceResponse<Integer> getNullDelegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Integer>()
                .register(200, Integer.class)
                .registerError(ErrorModel.class)
                .build(response, error);
    }

    public int getInvalid() throws ServiceException {
        try {
            return getInvalidDelegate(service.getInvalid(), null).getBody();
        } catch (RetrofitError error) {
            return getInvalidDelegate(error.getResponse(), error).getBody();
        }
    }

    public void getInvalidAsync(final ServiceCallback<Integer> serviceCallback) {
        service.getInvalidAsync(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(getInvalidDelegate(response, error));
                } catch (ServiceException ex) {
                    serviceCallback.failure(ex);
                }
            }
        });
    }

    private ServiceResponse<Integer> getInvalidDelegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Integer>()
                .register(200, Integer.class)
                .registerError(ErrorModel.class)
                .build(response, error);
    }


    public void putMax32(int intBody) throws ServiceException {
        try {
            putMax32Delegate(service.putMax32(intBody), null);
        } catch (RetrofitError error) {
            putMax32Delegate(error.getResponse(), error);
        }
    }

    public void putMax32Async(int intBody, final ServiceCallback<Void> serviceCallback) {
        service.putMax32Async(intBody, new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    serviceCallback.success(putMax32Delegate(response, error));
                } catch (ServiceException ex) {
                    serviceCallback.failure(ex);
                }
            }
        });
    }

    private ServiceResponse<Void> putMax32Delegate(Response response, RetrofitError error) throws ServiceException {
        return new ServiceResponseBuilder<Void>()
                .register(200, Void.class)
                .registerError(ErrorModel.class)
                .build(response, error);
    }
}
