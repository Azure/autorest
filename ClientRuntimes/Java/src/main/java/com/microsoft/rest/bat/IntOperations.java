/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.bat;

import com.microsoft.rest.HttpOperationResponse;
import com.microsoft.rest.ServiceException;
import retrofit.Callback;
import retrofit.client.Response;
import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.PUT;

import java.util.concurrent.Future;

public interface IntOperations {
    @GET("/int/null")
    int getNull();

    @GET("/int/null")
    void getNullAsync(Callback<Integer> cb);

    @GET("/int/invalid")
    int getInvalid();

    @GET("/int/invalid")
    void getInvalidAsync(Callback<Integer> cb);

    @PUT("/int/max/32")
    Response putMax32(@Body int intBody) throws ServiceException;

    @PUT("/int/max/32")
    void putMax32Async(Callback<Response> cb) throws ServiceException;
}
