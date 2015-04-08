/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */


package com.microsoft.rest.core.pipeline;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.Header;
import org.apache.http.HttpRequest;
import org.apache.http.protocol.HttpContext;

public class HttpServiceRequestContext implements ServiceRequestContext {
    private final HttpRequest clientRequest;
    private final HttpContext httpContext;

    public HttpServiceRequestContext(HttpRequest clientRequest,
            HttpContext httpContext) {
        this.clientRequest = clientRequest;
        this.httpContext = httpContext;
    }

    @Override
    public Object getProperty(final String name) {
        return httpContext.getAttribute(name);
    }

    @Override
    public void setProperty(final String name, final Object value) {
        httpContext.setAttribute(name, value);
    }

    @Override
    public Map<String, String> getAllHeaders() {
        Map<String, String> allHeaders = new HashMap<String, String>();
        for (Header header : clientRequest.getAllHeaders()) {
            allHeaders.put(header.getName(), header.getValue());
        }
        return allHeaders;
    }

    @Override
    public URI getURI() {
        try {
            return new URI(clientRequest.getRequestLine().getUri());
        } catch (URISyntaxException e) {
            return null;
        }
    }

    @Override
    public void setURI(final URI uri) {
        // Do nothing. not supported
    }

    @Override
    public String getMethod() {
        return clientRequest.getRequestLine().getMethod();
    }

    @Override
    public void setMethod(String method) {
        // Do nothing. not supported
    }

    @Override
    public Object getEntity() {
        // Do nothing. not supported
        return null;
    }

    @Override
    public void setEntity(final Object entity) {
        // Do nothing. not supported
    }

    @Override
    public String getHeader(final String name) {
        final Header first = clientRequest.getFirstHeader(name);
        return first != null ? first.getValue() : null;
    }

    @Override
    public void setHeader(final String name, final String value) {
        clientRequest.setHeader(name, value);
    }

    @Override
    public void removeHeader(final String name) {
        clientRequest.removeHeaders(name);
    }
}