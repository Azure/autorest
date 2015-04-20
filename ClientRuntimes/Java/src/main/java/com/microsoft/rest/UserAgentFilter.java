/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.microsoft.rest.pipeline.ServiceRequestFilter;
import org.apache.http.Header;
import org.apache.http.HttpRequest;

/**
 * The Class UserAgentFilter.
 */
public class UserAgentFilter implements ServiceRequestFilter {

    /** The azure SDK product token. */
    private String productUserAgent;

    /**
     * Instantiates a new user agent filter.
     */
    public UserAgentFilter(String productUserAgent) {
        this.productUserAgent = productUserAgent;
    }

    @Override
    public void filter(HttpRequest request) {
        String userAgent;

        if (request.getFirstHeader("User-Agent") != null) {
            Header currentUserAgent = request.getFirstHeader("User-Agent");
            userAgent = productUserAgent + " " + currentUserAgent.getValue();
            request.removeHeader(currentUserAgent);
        } else {
            userAgent = productUserAgent;
        }

        request.setHeader("User-Agent", userAgent);
    }
}
