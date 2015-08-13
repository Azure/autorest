/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.retrofit;

import com.google.gson.Gson;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.ServiceResponseCallback;
import retrofit.Callback;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import retrofit.client.Response;
import retrofit.converter.GsonConverter;
import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.PUT;
import retrofit.mime.TypedInput;

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
        int getInvalid();

        @GET("/int/invalid")
        void getInvalidAsync(Callback<Integer> cb);

        @PUT("/int/max/32")
        Response putMax32(@Body int intBody);

        @PUT("/int/max/32")
        void putMax32Async(@Body int intBody, Callback<Response> cb);
    }

    public int getNull() throws ServiceException {
        Response response;

        try {
            response = service.getNull();
        } catch (RetrofitError error) {
            response = error.getResponse();
        }

        return getNullResponse(response).getBody();
    }

    public void getNullAsync(final ServiceCallback<Integer> cb) {
        service.getNullAsync(new ServiceResponseCallback() {
            @Override
            public void response(Response response, RetrofitError error) {
                try {
                    ServiceResponse<Integer> res = getNullResponse(response);
                    cb.success(res.getBody(), res.getResponse());
                } catch (ServiceException ex) {
                    cb.failure(ex);
                }
            }
        });
    }

    private ServiceResponse<Integer> getNullResponse(Response response) throws ServiceException {
        if (response == null) {
            throw new ServiceException("Service returns null without throwing an exception.");
        }

        ServiceResponse<Integer> result;
        try {
            TypedInput responseContent = response.getBody();
            GsonConverter converter = new GsonConverter(new Gson());
            if (response.getStatus() == 200) {
                result = new ServiceResponse<Integer>(
                        (Integer) converter.fromBody(responseContent, Integer.class),
                        response);
            } else {
                ServiceException exception = new ServiceException();
                exception.setResponse(response);
                throw exception;
            }
            return result;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }


    public Response putMax32(int intBody) throws ServiceException {
        return service.putMax32(intBody);
    }

    public void putMax32Async(int intBody, Callback<Response> cb) {
        service.putMax32Async(intBody, cb);
    }
}
