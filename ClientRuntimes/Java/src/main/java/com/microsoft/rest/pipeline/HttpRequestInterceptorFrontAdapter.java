/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.pipeline;

public class HttpRequestInterceptorFrontAdapter extends HttpRequestInterceptorAdapter {
    public void addFront(ServiceRequestFilter filter) {
        getFilterList().addFirst(filter);
    }
}
