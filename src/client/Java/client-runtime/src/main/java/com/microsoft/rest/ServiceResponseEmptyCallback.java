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
     * The client service call object.
     */
    private ServiceCall<T> serviceCall;

    /**
     * The client callback.
     */
    private ServiceCallback<T> serviceCallback;

    /**
     * Creates an instance of ServiceResponseCallback.
     *
     * @param serviceCall the client service call to call on a terminal state.
     * @param serviceCallback the client callback to call on a terminal state.
     */
    public ServiceResponseEmptyCallback(ServiceCall<T> serviceCall, ServiceCallback<T> serviceCallback) {
        this.serviceCall = serviceCall;
        this.serviceCallback = serviceCallback;
    }

    @Override
    public void onFailure(Call<Void> call, Throwable t) {
        if (serviceCallback != null) {
            serviceCallback.failure(t);
        }
        if (serviceCall != null) {
            serviceCall.failure(t);
        }
    }
}
