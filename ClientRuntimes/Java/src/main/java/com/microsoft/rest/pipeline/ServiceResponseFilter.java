/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

import org.apache.http.HttpResponse;

/**
 * Filter for processing a response received on the wire. An instance
 * of this class needs to be wrapped in HttpResponseInterceptorAdapter to
 * be plugged into Apache pipeline.
 */
public interface ServiceResponseFilter {

    /**
     * Processes an HttpResponse that is about to sent on the wire.
     *
     * @param response an apache HttpResponse
     */
    void filter(HttpResponse response);
}
