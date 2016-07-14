/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit2.Call;
import retrofit2.Callback;

/**
 * Inner callback used to merge both successful and failed responses into one
 * callback for customized response handling in a response handling delegate.
 *
 * @param <T> the response body type
 */
public abstract class ServiceResponseEmptyCallback<T> implements Callback<Void> {
    /**
     * The client callback.
     */
    private ServiceCallback<T> serviceCallback;

    /**
     * Creates an instance of ServiceResponseCallback.
     *
     * @param serviceCallback the client callback to call on a terminal state.
     */
    public ServiceResponseEmptyCallback(ServiceCallback<T> serviceCallback) {
        this.serviceCallback = serviceCallback;
    }

    @Override
    public void onFailure(Call<Void> call, Throwable t) {
        serviceCallback.failure(new ServiceException(t));
    }
}
