/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.google.common.util.concurrent.AbstractFuture;

import retrofit2.Call;

/**
 * An instance of this class provides access to the underlying REST call invocation.
 * This class wraps around the Retrofit Call object and allows updates to it in the
 * progress of a long running operation or a paging operation.
 *
 * @param <T> the type of the returning object
 */
public class ServiceCall<T> extends AbstractFuture<ServiceResponse<T>> {
    /**
     * The Retrofit method invocation.
     */
    private Call<?> call;

    /**
     * Creates an instance of ServiceCall.
     *
     * @param call the Retrofit call to wrap around.
     */
    public ServiceCall(Call<?> call) {
        this.call = call;
    }

    /**
     * Updates the current Retrofit call object.
     *
     * @param call the new call object.
     */
    public void newCall(Call<?> call) {
        this.call = call;
    }

    /**
     * Gets the current Retrofit call object.
     *
     * @return the current call object.
     */
    public Call<?> getCall() {
        return call;
    }

    /**
     * Cancel the Retrofit call if possible. Parameter
     * 'mayInterruptIfRunning is ignored.
     *
     * @param mayInterruptIfRunning ignored
     */
    @Override
    public boolean cancel(boolean mayInterruptIfRunning) {
        if (isCancelled()) {
            return false;
        } else {
            call.cancel();
            return true;
        }
    }

    @Override
    public boolean isCancelled() {
        return call.isCanceled();
    }

    /**
     * Invoke this method to report completed, allowing
     * {@link AbstractFuture#get()} to be unblocked.
     *
     * @param result the service response returned.
     * @return true if successfully reported; false otherwise.
     */
    public boolean success(ServiceResponse<T> result) {
        return set(result);
    }

    /**
     * Invoke this method to report a failure, allowing
     * {@link AbstractFuture#get()} to throw the exception.
     *
     * @param t the exception thrown.
     * @return true if successfully reported; false otherwise.
     */
    public boolean failure(Throwable t) {
        return setException(t);
    }
}
