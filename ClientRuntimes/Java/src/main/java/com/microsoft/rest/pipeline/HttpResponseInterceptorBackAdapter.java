/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

/**
 * The adapter to wrap a list of ServiceResponseFilter to be placed
 * at the end of all the response filters in Apache pipeline.
 */
public class HttpResponseInterceptorBackAdapter extends HttpResponseInterceptorAdapter {

    /**
     * Add a ServiceResponseFilter to the end of the the filter list.
     *
     * @param filter a ServiceResponseFilter instance
     */
    public void addBack(ServiceResponseFilter filter) {
        getFilterList().addLast(filter);
    }
}
