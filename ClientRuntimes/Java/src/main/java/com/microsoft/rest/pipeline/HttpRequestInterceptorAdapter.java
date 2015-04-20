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

public class HttpRequestInterceptorAdapter implements HttpRequestInterceptor {
    private LinkedList<ServiceRequestFilter> filters;

    public HttpRequestInterceptorAdapter() {
        filters = new LinkedList<ServiceRequestFilter>();
    }

    public LinkedList<ServiceRequestFilter> getFilterList()
    {
        return filters;
    }

    @Override
    public void process(HttpRequest request, HttpContext context) {
        for (ServiceRequestFilter filter : filters) {
            filter.filter(request);
        }
    }
}
