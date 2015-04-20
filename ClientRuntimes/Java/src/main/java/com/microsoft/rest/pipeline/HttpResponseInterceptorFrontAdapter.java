/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

public class HttpResponseInterceptorFrontAdapter extends HttpResponseInterceptorAdapter {
    public void addFront(ServiceResponseFilter filter) {
        getFilterList().addFirst(filter);
    }
}
