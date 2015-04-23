/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

/**
 * The adapter to wrap a list of
 * <code>com.microsoft.rest.pipeline.ServiceResponseFilter</code> to be placed
 * at the front of all the response filters in Apache pipeline.
 */
public class HttpResponseInterceptorFrontAdapter extends HttpResponseInterceptorAdapter {

    /**
     * Add a <code>com.microsoft.rest.pipeline.ServiceResponseFilter</code> to
     * the front of the the filter list.
     * @param filter a ServiceResponseFilter instance
     */
    public void addFront(ServiceResponseFilter filter) {
        getFilterList().addFirst(filter);
    }
}
