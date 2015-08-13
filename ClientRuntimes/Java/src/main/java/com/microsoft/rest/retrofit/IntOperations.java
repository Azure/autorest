/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.retrofit;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponseCallback;
import com.microsoft.rest.ServiceResponseSyncCallback;
import retrofit.Callback;
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
        void getNullAsync(ServiceResponseCallback<Integer> cb);

        @GET("/int/invalid")
        int getInvalid();

        @GET("/int/invalid")
        void getInvalidAsync(Callback<Integer> cb);

        @PUT("/int/max/32")
        Response putMax32(@Body int intBody);

        @PUT("/int/max/32")
        void putMax32Async(@Body int intBody, Callback<Response> cb);
    }

    public int getNull() throws ServiceException, InterruptedException {
//        Response result;
//        try {
//            result = service.getNull();
//            return new GsonConverter(new Gson()).fromBody(result.getBody(), Integer.class);
//        } catch (RetrofitError error) {
//            ServiceException ex = new ServiceException(error);
//            ex.setResponse(error.getResponse());
//            ex.setErrorModel(error.getBody());
//            throw ex;
//        } catch (Exception error) {
//            ServiceException ex = new ServiceException(error);
//            throw ex;
//        }
        ServiceResponseSyncCallback<Integer> cb = new ServiceResponseSyncCallback<Integer>();
        this.getNullAsync(cb);
        while (!cb.isComplete()) {
            synchronized (this) {
                this.wait();
            }
        }
        return cb.getResult();
    }

    public void getNullAsync(final ServiceCallback<Integer> cb) {
        service.getNullAsync(new ServiceResponseCallback<Integer>() {
            @Override
            public void response(Integer result, Response response, RetrofitError error) {
                // Error getting a valid response
                if (response.getStatus() != 200) {
                    ServiceException exception = new ServiceException(error);
                    exception.setResponse(error.getResponse());
                    exception.setErrorModel(error.getBody());
                    cb.failure(exception);
                }
                // Valid response
                if (result == null) {
                    result = (Integer)error.getBodyAs(Integer.class);
                }
                if (response.getStatus() == 200) {
                    cb.success(result, response);
                }
            }
        });
    }

    public Response putMax32(int intBody) throws ServiceException {
        return service.putMax32(intBody);
    }

    public void putMax32Async(int intBody, Callback<Response> cb) {
        service.putMax32Async(intBody, cb);
    }
}
