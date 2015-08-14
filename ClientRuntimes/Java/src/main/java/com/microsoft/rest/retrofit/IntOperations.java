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
import retrofit.client.Response;
import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.PUT;

public interface IntOperations {
    interface IntService {
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

    int getNull() throws ServiceException;

    void getNullAsync(final ServiceCallback<Integer> serviceCallback);

    int getInvalid() throws ServiceException;

    void getInvalidAsync(final ServiceCallback<Integer> serviceCallback);

    void putMax32(int intBody) throws ServiceException;

    void putMax32Async(int intBody, final ServiceCallback<Void> serviceCallback);
}
