/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.pipeline;

import org.apache.http.HttpResponse;
import org.apache.http.HttpResponseInterceptor;
import org.apache.http.protocol.HttpContext;

import java.util.LinkedList;

public class HttpResponseInterceptorAdapter implements HttpResponseInterceptor {
    private LinkedList<ServiceResponseFilter> filters;

    public HttpResponseInterceptorAdapter() {
        filters = new LinkedList<ServiceResponseFilter>();
    }

    public LinkedList<ServiceResponseFilter> getFilterList()
    {
        return filters;
    }

    @Override
    public void process(HttpResponse response, HttpContext context) {
        HttpServiceResponseContext serviceResponseContext = new HttpServiceResponseContext(response, context);
        for (ServiceResponseFilter filter : filters) {
            filter.filter(null, serviceResponseContext);
        }
    }
}
