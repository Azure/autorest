/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

import org.apache.http.HttpResponse;
import org.apache.http.HttpResponseInterceptor;
import org.apache.http.protocol.HttpContext;

import java.util.LinkedList;

/**
 * The adapter to wrap a list of ServiceResponseFilter to be placed in Apache pipeline.
 */
public class HttpResponseInterceptorAdapter implements HttpResponseInterceptor {
    private LinkedList<ServiceResponseFilter> filters;

    /**
     * Initialize a new instance of HttpResponseInterceptorAdapter.
     */
    public HttpResponseInterceptorAdapter() {
        filters = new LinkedList<ServiceResponseFilter>();
    }

    /**
     * Get all ServiceResponseFilters in the current adapter.
     *
     * @return a linked list of the filters
     */
    public LinkedList<ServiceResponseFilter> getFilterList()
    {
        return filters;
    }

    /* (non-Javadoc)
     * @see org.apache.http.HttpResponseInterceptor#process(org.apache.http.HttpResponse, org.apache.http.protocol.HttpContext)
     */
    @Override
    public void process(HttpResponse response, HttpContext context) {
        for (ServiceResponseFilter filter : filters) {
            filter.filter(response);
        }
    }
}
