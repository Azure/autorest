/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

/**
 * The adapter to wrap a list of
 * <code>com.microsoft.rest.pipeline.ServiceRequestFilter</code> to be placed
 * at the front of all the request filters in Apache pipeline.
 */
public class HttpRequestInterceptorFrontAdapter extends HttpRequestInterceptorAdapter {

    /**
     * Add a <code>com.microsoft.rest.pipeline.ServiceRequestFilter</code> to
     * the front of the the filter list.
     * @param filter a ServiceRequestFilter instance
     */
    public void addFront(ServiceRequestFilter filter) {
        getFilterList().addFirst(filter);
    }
}
