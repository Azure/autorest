/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

import org.apache.http.HttpRequest;

/**
 * Filter for processing a request before it's sent on the wire. An instance
 * of this class needs to be wrapped in HttpRequestInterceptorAdapter to
 * be plugged into Apache pipeline.
 */
public interface ServiceRequestFilter {

    /**
     * Processes an HttpRequest that is about to sent on the wire.
     *
     * @param request an apache HttpRequest
     */
    void filter(HttpRequest request);
}
