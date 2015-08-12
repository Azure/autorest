/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.bat;

import com.microsoft.rest.ServiceException;
import retrofit.Callback;
import retrofit.RestAdapter;
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
        int getNull() throws ServiceException;

        @GET("/int/null")
        void getNullAsync(Callback<Integer> cb);

        @GET("/int/invalid")
        int getInvalid() throws ServiceException;

        @GET("/int/invalid")
        void getInvalidAsync(Callback<Integer> cb);

        @PUT("/int/max/32")
        Response putMax32(@Body int intBody) throws ServiceException;

        @PUT("/int/max/32")
        void putMax32Async(@Body int intBody, Callback<Response> cb);
    }

    public int getNull() throws ServiceException {
        return service.getNull();
    }

    public void getNullAsync(Callback<Integer> cb) {
        service.getNullAsync(cb);
    }

    public Response putMax32(int intBody) throws ServiceException {
        return service.putMax32(intBody);
    }

    public void putMax32Async(int intBody, Callback<Response> cb) {
        service.putMax32Async(intBody, cb);
    }
}
