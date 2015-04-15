/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.pipeline;

public class HttpRequestInterceptorBackAdapter extends HttpRequestInterceptorAdapter {
    public void addBack(ServiceRequestFilter filter) {
        getFilterList().addLast(filter);
    }
}
