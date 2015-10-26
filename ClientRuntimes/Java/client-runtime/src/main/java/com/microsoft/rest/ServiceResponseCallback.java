/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.squareup.okhttp.ResponseBody;
import retrofit.Callback;

/**
 * Inner callback used to merge both successful and failed responses into one
 * callback for customized response handling in a response handling delegate.
 */
public abstract class ServiceResponseCallback<T> implements Callback<ResponseBody> {
    private ServiceCallback<T> serviceCallback;

    public ServiceResponseCallback(ServiceCallback<T> serviceCallback) {
        this.serviceCallback = serviceCallback;
    }

    @Override
    public void onFailure(Throwable t) {
        serviceCallback.failure(new ServiceException(t));
    }
}
