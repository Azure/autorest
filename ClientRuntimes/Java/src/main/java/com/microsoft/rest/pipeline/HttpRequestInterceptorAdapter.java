/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

import org.apache.http.HttpRequest;
import org.apache.http.HttpRequestInterceptor;
import org.apache.http.protocol.HttpContext;

import java.util.LinkedList;

/**
 * The adapter to wrap a list of
 * <code>com.microsoft.rest.pipeline.ServiceRequestFilter</code> to be placed
 * in Apache pipeline.
 */
public class HttpRequestInterceptorAdapter implements HttpRequestInterceptor {
    private LinkedList<ServiceRequestFilter> filters;

    /**
     * Initialize a new instance of HttpRequestInterceptorAdapter.
     */
    public HttpRequestInterceptorAdapter() {
        filters = new LinkedList<ServiceRequestFilter>();
    }

    /**
     * Get all <code>com.microsoft.rest.pipeline.ServiceRequestFilter</code> in
     * the current adapter.
     * @return a linked list of the filters
     */
    public LinkedList<ServiceRequestFilter> getFilterList()
    {
        return filters;
    }

    /* (non-Javadoc)
     * @see org.apache.http.HttpRequestInterceptor#process(org.apache.http.HttpRequest, org.apache.http.protocol.HttpContext)
     */
    @Override
    public void process(HttpRequest request, HttpContext context) {
        for (ServiceRequestFilter filter : filters) {
            filter.filter(request);
        }
    }
}
