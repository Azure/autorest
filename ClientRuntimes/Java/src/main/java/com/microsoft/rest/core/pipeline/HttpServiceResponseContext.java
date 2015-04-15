/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */


package com.microsoft.rest.core.pipeline;

import java.io.IOException;
import java.io.InputStream;
import org.apache.http.Header;
import org.apache.http.HttpResponse;
import org.apache.http.entity.InputStreamEntity;
import org.apache.http.protocol.HttpContext;

public class HttpServiceResponseContext implements ServiceResponseContext {
    private HttpResponse clientResponse;
    private HttpContext httpContext;

    public HttpServiceResponseContext(HttpResponse clientResponse,
            HttpContext httpContext) {
        this.clientResponse = clientResponse;
        this.httpContext = httpContext;
    }

    @Override
    public Object getProperty(String name) {
        return httpContext.getAttribute(name);
    }

    @Override
    public void setProperty(String name, Object value) {
        httpContext.setAttribute(name, value);
    }

    @Override
    public int getStatus() {
        return clientResponse.getStatusLine().getStatusCode();
    }

    @Override
    public void setStatus(int status) {
        clientResponse.setStatusCode(status);
    }

    @Override
    public boolean hasEntity() {
        return clientResponse.getEntity() != null;
    }

    @Override
    public String getHeader(String name) {
        Header first = clientResponse.getFirstHeader(name);
        if (first != null) {
            return first.getValue();
        }

        return null;
    }

    @Override
    public void setHeader(String name, String value) {
        clientResponse.setHeader(name, value);
    }

    @Override
    public void removeHeader(String name) {
        clientResponse.removeHeaders(name);
    }

    @Override
    public InputStream getEntityInputStream() {
        try {
            return clientResponse.getEntity().getContent();
        } catch (IOException e) {
            return null;
        } catch (IllegalStateException e) {
            return null;
        }
    }

    @Override
    public void setEntityInputStream(InputStream entity) {
        clientResponse.setEntity(new InputStreamEntity(entity));
    }
}
