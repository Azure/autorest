/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import retrofit2.Call;

/**
 * An instance of this class provides access to the underlying REST call invocation.
 * This class wraps around the Retrofit Call object and allows updates to it in the
 * progress of a long running operation or a paging operation.
 */
public class ServiceCall {
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
     * Cancel the Retrofit call if possible.
     */
    public void cancel() {
        call.cancel();
    }

    /**
     * If the Retrofit call has been canceled.
     *
     * @return true if the call has been canceled; false otherwise.
     */
    public boolean isCanceled() {
        return call.isCanceled();
    }
}
